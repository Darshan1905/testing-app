// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/dynamic_link/firebase_dynamic_link.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_occupation_table.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/add_occupation_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/occupations_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/search_occupation_other_info_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/unit_group_and_general_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_repository.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';

class OccupationDetailBloc extends RxBlocTypeBase {
  BuildContext? _context;
  String errorMsg = "";
  final isLoadingSubject = BehaviorSubject<bool>.seeded(false); //loader

  Stream<bool> get loadingStream => isLoadingSubject.stream;

  //OCCUPATION ADD-REMOVE STREAM
  final occuAddRemoveLoaderStream = BehaviorSubject<bool>.seeded(false);

  set setOccuAddRemoveLoader(bool value) {
    occuAddRemoveLoaderStream.sink.add(value);
  }

  //Unit Group and General Detail API variable List
  final unitGroupAndGeneralDetailStream =
      BehaviorSubject<UnitGroupAndGeneralDetailModel>();

  UnitGroupAndGeneralDetailModel get getUnitGroupAndGeneralDetail =>
      unitGroupAndGeneralDetailStream.stream.value;

  set setUnitGroupAndGeneralDetail(
      UnitGroupAndGeneralDetailModel unitGroupAndGeneralDetailModel) {
    unitGroupAndGeneralDetailStream.sink.add(unitGroupAndGeneralDetailModel);
  }

  //OCCUPATION OTHER INFO STREAM
  final occupationOtherInfoDataStream =
      BehaviorSubject<OccupationOtherInfoData>();

  OccupationOtherInfoData get getOccupationOtherInfoData =>
      occupationOtherInfoDataStream.stream.value;

  set setOccupationOtherInfoData(
      OccupationOtherInfoData occupationOtherInfoData) {
    occupationOtherInfoDataStream.sink.add(occupationOtherInfoData);
  }

  //POINT SCORE DATA
  final ugPointScoreDataStream = BehaviorSubject<UgPointScore>();

  //CAVEAT NOTE DATA
  final caveatNotesDataStream = BehaviorSubject<CaveatNotes>();

  //RELATED OCCUPATION DATA
  final relatedOccupationDataStream = BehaviorSubject<RelatedOccupation>();

  //EMPLOYEE STATISTICS STREAM
  final employmentStatisticsDataStream =
      BehaviorSubject<EmploymentStatistics>();

  // [Specialisation List]
  List<OtherInfoRow>? _specialisationList;

  List<OtherInfoRow> get getSpecialisationList => _specialisationList ?? [];

  // [Assessing Authority List]
  List<OtherInfoRow>? _assessingAuthList;

  List<OtherInfoRow> get getAssessingAuthList => _assessingAuthList ?? [];

  // [Related Occupation List]
  List<RelatedOccupation>? _relatedOccupationList;

  List<RelatedOccupation>? get getRelatedOccupationList =>
      _relatedOccupationList;

  // [Caveats List]
  List<CaveatNotes>? _caveatsInfoList;

  List<CaveatNotes>? get getCaveatsInfoList => _caveatsInfoList;

  set setCaveatsInfoList(List<CaveatNotes> caveatsList) {
    _caveatsInfoList = caveatsList;
  }

  // [EMPLOYMENT STATISTICS List]
  List<EmploymentStatistics>? _employeeStatisticList;

  List<EmploymentStatistics> get getEmployeeStatisticList =>
      _employeeStatisticList ?? [];

  set setEmployeeStatisticList(List<EmploymentStatistics> employeeList) {
    _employeeStatisticList = employeeList;
  }

  setBuildContextForBloc(BuildContext context) {
    _context = context;
  }

  /*
  * [START]  We use below 3 variable to hold the occupation
  * detail in entire Occupation search module
  * */
  String selectedOccupationID = "";
  String selectedOccupationMainID = "";
  String selectedOccupationName = "";
  bool selectedOccupationIsAdded = false;

  //[OCCUPATION MODULE] WHEN WE REDIRECT TO PARTICULAR OCCUPATION DETAIL PAGE STORE IN RECENT
  //STORE DATA IN RECENT-OCCUPATION-TABLE//
  storeRecentOccupationDetails(OccupationRowData? occupationData,
      [OccupationOtherInfoData? getOccupationOtherInfoData]) async {
    //IF ID EXIST IN TABLE
    bool? isExist = await RecentOccupationTable.checkOccupationExists(
        strOccID: occupationData?.id.toString() ?? "");
    var timestampValue = DateTime.now().millisecondsSinceEpoch;
    if (isExist == true) {
      //IF ID EXIST THEN UPDATE MOST VISITED COUNT
      var visitedData = await RecentOccupationTable.returnExistsData(
          strOccID: occupationData?.id.toString() ?? "");
      await RecentOccupationTable.updateMostVisitedCount(
          mostVisited: ((visitedData?.mostVisited ?? 0) + 1),
          timestamp: timestampValue,
          strOccID: occupationData?.id.toString() ?? "");
    } else {
      //INSERT OCCUPATION SELECTED DATA IN TABLE
      var recentOccupationTable = RecentOccupationTable(
          occuID: occupationData?.id,
          occuMainID: occupationData?.mainId,
          occuName: occupationData?.name,
          mostVisited: 0,
          skillLevel: getOccupationOtherInfoData?.skillLevel ?? 0,
          timestamp: timestampValue);
      await RecentOccupationTable.insert(
          recentOccupationTable: recentOccupationTable);
    }
  }

  // [OCCUPATION MODULE] We store Occupation Id & Name
  Future<void> setOccupationSelection(
      {required String occID,
      required String occMainID,
      required String occName,
      required bool isAdded}) async {
    selectedOccupationID = occID;
    selectedOccupationMainID = occMainID;
    selectedOccupationName = occName;
    //print(await SearchOccupationRepo.shared.isOccupationIsExistInDB(occID));
    selectedOccupationIsAdded =
        await MyBookmarkTable.checkBookmarkExists(bookmarkID: occID) != 0;
    // print("********* $selectedOccupationIsAdded");
  }

  // [END]

  // [SPECIALISATION]
  void setUpSpecialisationData(String strSpecialisation) {
    // NOTE: Specialisation data will come with comma(,) separated in string
    try {
      _specialisationList = [];
      OtherInfoRow model = OtherInfoRow();
      if (strSpecialisation.isNotEmpty) {
        if (strSpecialisation.contains("\n")) {
          List data = strSpecialisation.split("\n");
          for (var row in data) {
            if (row.isNotEmpty) {
              model = OtherInfoRow();
              model.title = row;
              model.subtitle = "";
              model.link = "";
              _specialisationList!.add(model);
            }
          }
        } else {
          model.title = strSpecialisation;
          model.subtitle = "";
          model.link = "";
          _specialisationList!.add(model);
        }
      } else {
        _specialisationList = [];
      }
    } catch (e) {
      printLog(e);
      _specialisationList = [];
    }
  }

  // [ASSESSING AUTHORITY]
  void setUpAssessingAuthorityData(String strAssessingAuthority) {
    // NOTE: Specialisation data will come with backward-slash(/) separated in string
    try {
      _assessingAuthList = [];
      OtherInfoRow model = OtherInfoRow();
      if (strAssessingAuthority.isNotEmpty) {
        if (strAssessingAuthority.contains("/")) {
          List data = strAssessingAuthority.split("/");
          for (var row in data) {
            if (row.isNotEmpty) {
              model = OtherInfoRow();
              model.title = row;
              model.subtitle = "";
              model.link = "";
              model.isLink = true;
              _assessingAuthList!.add(model);
            }
          }
        } else {
          model.title = strAssessingAuthority;
          model.subtitle = "";
          model.link = "";
          model.isLink = true;
          _assessingAuthList!.add(model);
        }
      } else {
        _assessingAuthList = [];
      }
    } catch (e) {
      printLog(e);
      _assessingAuthList = [];
    }
  }

  //Unit Group And General Detail API Calling
  Future<void> getUnitGroupAndGeneralDetailData(String occupationID) async {
    try {
      isLoadingSubject.sink.add(true);
      errorMsg = "";
      String param = "occupation_code=$occupationID";
      BaseResponseModel result =
          await SearchOccupationRepo.getUnitGroupAndGeneralDetailInformation(
              param);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        // increase local count of dynamic rating according to module into stored data of shared preference...
        //DynamicRatingCalculation.updateRatingLocalCountByModuleName(PreferencesHelper.occupationDetail);

        unitGroupAndGeneralDetailStream.sink
            .add(UnitGroupAndGeneralDetailModel.fromJson(result.data));

        if (getUnitGroupAndGeneralDetail.flag == true &&
            getUnitGroupAndGeneralDetail.data != null) {
          if (getUnitGroupAndGeneralDetail.data!.occupationData != null) {
            setOccupationOtherInfoData =
                getUnitGroupAndGeneralDetail.data!.occupationData![0];
          }

          // set Occupation detail
          setOccupationSelection(
              occID: getOccupationOtherInfoData.occupationCode ?? "",
              occMainID: getOccupationOtherInfoData.mainOccupationCode ?? "",
              occName: getOccupationOtherInfoData.occupationName ?? "",
              isAdded: false);

          //SoAllVisaTypeBloc().callAllVisaTypeDetail(selectedOccupationID ?? '');

          // RELATED OCCUPATION LIST
          _relatedOccupationList =
              getUnitGroupAndGeneralDetail.data!.relatedOccupation;

          //CAVEATS LIST
          setCaveatsInfoList = getUnitGroupAndGeneralDetail.data!.caveatNotes!;

          //EMPLOYMENT STATISTICS LIST
          setEmployeeStatisticList =
              getUnitGroupAndGeneralDetail.data!.employmentStatistics!;

          // SPECIALISATION DETAILS
          setUpSpecialisationData(getUnitGroupAndGeneralDetail
              .data!.occupationData![0].specialisation!);

          // Assessing Authority
          setUpAssessingAuthorityData(getUnitGroupAndGeneralDetail
              .data!.occupationData![0].assessingAuthorith!);

          //Occupation Visit Count
          toUpdateOccupationVisitCount(occupationID);
        } else {
          setOccupationOtherInfoData = OccupationOtherInfoData();
        }
        errorMsg = getUnitGroupAndGeneralDetail.message.toString();
        isLoadingSubject.sink.add(false);
      } else {
        setOccupationOtherInfoData = OccupationOtherInfoData();
        setUnitGroupAndGeneralDetail = UnitGroupAndGeneralDetailModel();
        Toast.show(_context!, message: errorMsg, gravity: Toast.toastTop);
        isLoadingSubject.sink.add(false);
      }
    } catch (e) {
      setOccupationOtherInfoData = OccupationOtherInfoData();
      isLoadingSubject.sink.add(false);
      errorMsg = e.toString();
      debugPrint(e.toString());
    }
  }

  // GET Occupation Visit List from Firebase RealTime database
  Future<void> toUpdateOccupationVisitCount(String occupationID) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref(FirebaseRealtimeDatabaseConstants.occupationVisitListString);

    await databaseReference.once().then((event) async {
      if (event.snapshot.exists) {
        final data = jsonEncode(event.snapshot.value);
        List<OccupationRowData> fbOccupationList = (jsonDecode(data) as List)
            .map<OccupationRowData>((json) => OccupationRowData.fromJson(json))
            .toList();

        for (int i = 0; i < fbOccupationList.length; i++) {
          if (fbOccupationList[i].id == occupationID) {
            //update visit_count on firebase realtime database JSON
            databaseReference.child("$i").update({
              'visit_count': int.parse(fbOccupationList[i].visitCount == null
                      ? '0'
                      : fbOccupationList[i].visitCount.toString()) +
                  1,
            }).catchError((onError) {
              FirebaseAnalyticLog.shared.eventTracking(
                screenName: RouteName.occupationSearchScreen,
                actionEvent: 'occupation visit',
                message: "occupation visit ${onError.toString()}",
              );
            });
          }
        }
      }
    });
  }

  // [DELETE] occupation
  deleteOccupation(String occupationID, String userId) async {
    try {
      setOccuAddRemoveLoader = true;
      var params = {
        NetworkAPIConstant.reqResKeys.userId: userId,
        RequestParameterKey.occupationId: occupationID
      };
      BaseResponseModel result =
          await SearchOccupationRepo.deleteOccupation(jsonEncode(params));
      // print(result.body);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        BaseResponseModel model = BaseResponseModel.completed(result);
        // Delete from Database Table
        SearchOccupationRepo.deleteOccupationFromDB(occupationID);

        //Delete from My Bookmark Table
        MyBookmarkTable.deleteBookmarkById(bookmarkID: occupationID);

        // set selected occupation detail
        await setOccupationSelection(
            occMainID: selectedOccupationMainID,
            occName: selectedOccupationName,
            isAdded: false,
            occID: selectedOccupationID);
        setOccuAddRemoveLoader = false;
        Toast.show(
            message: model.message ?? StringHelper.occupationRemovedMsg,
            type: Toast.toastSuccess,
            _context!,
            gravity: Toast.toastTop);
      } else {
        if (result.statusCode == NetworkAPIConstant.statusCodeNoInternet) {
          errorMsg = StringHelper.internetConnection;
        } else {
          errorMsg = StringHelper.occupationFailToDelete;
        }
        Toast.show(_context!,
            message: errorMsg, gravity: Toast.toastTop, type: Toast.toastError);
        printLog(errorMsg);
        setOccuAddRemoveLoader = false;
      }
    } catch (e) {
      printLog(e);
      setOccuAddRemoveLoader = false;
    }
  }

  // [ADD] occupation
  addOccupation(OccupationData occObject, int userId, bool showToast) async {
    try {
      setOccuAddRemoveLoader = true;
      List<OccupationData> data = [];
      AddOccupationJsonRequestModel requestJSON =
          AddOccupationJsonRequestModel();
      requestJSON.userid = userId;
      data.add(occObject);
      requestJSON.occupations = data;
      BaseResponseModel result =
          await SearchOccupationRepo.addOccupation(jsonEncode(requestJSON));

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        errorMsg = "";
        BaseResponseModel model = BaseResponseModel.completed(result.data);
        if (showToast) {
          Toast.show(
              message: model.message ?? StringHelper.occupationAddedMsg,
              _context!,
              type: Toast.toastSuccess,
              gravity: Toast.toastTop);
        }

        //Insert newly added occupations to My Bookmark Table
        var occupationListTable = MyBookmarkTable(
            name: occObject.name,
            code: occObject.id,
            subCode: occObject.mainId,
            subList: "",
            type: BookmarkType.OCCUPATION.name,
            skillLevel: 0);

        await MyBookmarkTable.insert(myBookmarkTable: occupationListTable);

        // set selected occupation detail
        await setOccupationSelection(
            occID: occObject.id ?? "",
            occMainID: occObject.mainId ?? "",
            occName: occObject.name ?? "",
            isAdded: true);

        setOccuAddRemoveLoader = false;
      } else {
        if (result.statusCode == NetworkAPIConstant.statusCodeNoInternet) {
          errorMsg = StringHelper.internetConnection;
        } else {
          errorMsg = StringHelper.occupationFailToAdd;
        }
        Toast.show(_context!,
            message: errorMsg, type: Toast.toastError, gravity: Toast.toastTop);
        setOccuAddRemoveLoader = false;
        debugPrint(errorMsg);
      }
    } catch (e) {
      printLog(e);
      setOccuAddRemoveLoader = false;
    }
  }

  initialAPICalling(String occupationID) async {
    try {
      getUnitGroupAndGeneralDetailData(occupationID);
    } catch (e) {
      printLog(e);
    }
  }

  shareOccupationLink(String occupationID, String occupationName) async {
    String link =
        '${Constants.occusearchDomainName}?occupation_code=$occupationID';
    Uri dynamicLink = await FirebaseDynamicLink.shared.createDynamicLink(
        link: link,
        title: "OccuSearch: $occupationName",
        description: "Search from the futuristic Occupations with OccuSearch",
        imageUrl: Constants.occuSearchLogoUrl,
        fallbackUrl: null);
    await Share.share(dynamicLink.toString(),
        subject: "OccuSearch: $occupationName occupation");
  }

  @override
  void dispose() {}
}

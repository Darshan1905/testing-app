// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:in_app_update/in_app_update.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_course_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_occupation_table.dart';
import 'package:occusearch/features/contact_us/model/contact_us_model.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';
import 'package:occusearch/features/dashboard/dashboard_repository.dart';
import 'package:occusearch/features/dashboard/model/dashboard_details_model.dart';
import 'package:occusearch/features/dashboard/model/other_services_model.dart';
import 'package:occusearch/features/dashboard/model/recent_search_model.dart';
import 'package:occusearch/features/dashboard/model/unitgroup_occupationlist_model.dart';
import 'package:occusearch/features/dashboard/recent_updates/model/recent_update_model.dart';
import 'package:occusearch/features/dashboard/widget/app_update_alert_for_android.dart';
import 'package:occusearch/features/dashboard/widget/app_update_widget_ios.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_repository.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

@RxBloc()
class DashboardBloc extends RxBlocTypeBase {
  // ---------------  [RECENT UPDATE DATA]  ---------------
  final _recentUpdateStream = BehaviorSubject<List<Recordset>>();

  Stream<List<Recordset>> get getRecentUpdateList => _recentUpdateStream.stream;

  set setRecentUpdateList(List<Recordset> recordList) => _recentUpdateStream.sink.add(recordList);

  PackageInfo? packageInfo;

  final isRecentUpdateLoading = BehaviorSubject<bool>.seeded(false);

  //DashboardData
  final dashboardDetailStream = BehaviorSubject<List<DashboardDetails>>();

  Stream<List<DashboardDetails>> get getDashboardDetailList => dashboardDetailStream.stream;

  set setDashboardDetailList(List<DashboardDetails> dashboardData) =>
      dashboardDetailStream.sink.add(dashboardData);

  final bookmarkByTypeListStream = BehaviorSubject<List<MyBookmarkTable>>();

  //Dashboard Contact branch stream data
  final contactBranchStream = BehaviorSubject<AussizzBranches>();

  Stream<AussizzBranches> get getContactBranchStream => contactBranchStream.stream;

  final isContactBranchLoading = BehaviorSubject<bool>.seeded(false);

  getDashboardData(BuildContext context, int userId) async {
    var param = {NetworkAPIConstant.reqResKeys.userId: userId};

    //Dashboard Api call
    BaseResponseModel result = await DashboardRepository.getDashboardData(param);

    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess && result.flag == true) {
      UserModel model = UserModel.fromJson(result.data);

      if (model.data != null) {
        setDashboardDetailList = model.data!;
        if (model.data != null &&
                (model.data![0].occupations != null && model.data![0].occupations!.isNotEmpty) ||
            (model.data![0].courses != null && model.data![0].courses!.isNotEmpty)) {
          setOccupationList(model.data![0].occupations ?? [], model.data![0].courses ?? []);
        } else {
          setOccupationList([], []);
        }
      }
    } else {
      Toast.show(context, message: result.message.toString(), type: Toast.toastError);
    }
  }

  setOccupationList(
      List<OccupationRowData> occupationList, List<CoursesRowData> coursesList) async {
    // Delete table before inserting in MyBookmark Table
    MyBookmarkTable.deleteTable();

    List<MyBookmarkTable> data = [];

    // [INSERT USER OCCUPATION]
    if (occupationList.isNotEmpty) {
      for (int i = 0; i < occupationList.length; i++) {
        bool selectedOccupationIsAdded =
            await MyBookmarkTable.checkBookmarkExists(bookmarkID: occupationList[i].id!) != 0;
        if (selectedOccupationIsAdded == false) {
          var occupationListTable = MyBookmarkTable(
              code: occupationList[i].id,
              subCode: occupationList[i].id,
              name: occupationList[i].name,
              subList: "",
              type: BookmarkType.OCCUPATION.name,
              skillLevel: 0);

          data.add(occupationListTable);

          MyBookmarkTable.insert(myBookmarkTable: occupationListTable);
        }
      }
    }

    // [INSERT USER COURSE]
    if (coursesList.isNotEmpty) {
      for (int i = 0; i < coursesList.length; i++) {
        bool selectedCourseIsAdded =
            await MyBookmarkTable.checkBookmarkExists(bookmarkID: coursesList[i].cricosCode!) != 0;
        if (selectedCourseIsAdded == false) {
          var courseListTable = MyBookmarkTable(
              name: coursesList[i].courseName,
              code: coursesList[i].cricosCode,
              subCode: coursesList[i].ascedCode,
              subList: "",
              type: BookmarkType.COURSE.name,
              skillLevel: 0);

          data.add(courseListTable);

          MyBookmarkTable.insert(myBookmarkTable: courseListTable);
        }
      }
    }

    bookmarkByTypeListStream.sink.add(data);
  }

  getRecentUpdateDataList(BuildContext context, bool isHardRefresh, GlobalBloc? globalBloc) async {
    try {
      isRecentUpdateLoading.sink.add(true);
      String param = "page_no=1&from_date=&to_date=&pagesize=5&recent_id=0";
      BaseResponseModel result = await DashboardRepository.getRecentUpdatesDio(param);
      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess && result.flag == true) {
        // debugPrint(
        //     "#DashboardBloc# @getRecentUpdateDataList()@ ${result.data}");
        LatestUpdateModel model = LatestUpdateModel.fromJson(result.data);
        if (model.flag == true && model.data != null && model.data!.recentChanges != null) {
          setRecentUpdateList = model.data!.recentChanges ?? [];
          globalBloc!.recentUpdateList = model.data!.recentChanges ?? [];
        } else {
          setRecentUpdateList = [];
        }
        isRecentUpdateLoading.sink.add(false);
      } else {
        setRecentUpdateList = [];
        isRecentUpdateLoading.sink.add(false);
        Utility.showToastErrorMessage(context, result.statusCode);
      }
    } catch (e) {
      isRecentUpdateLoading.sink.add(false);
    }
  }

  // ---------------  [OTHER PRODUCT DATA]  ---------------

  final _otherProductStream = BehaviorSubject<List<OtherServiceData>>();
  final isOtherProductLoading = BehaviorSubject<bool>.seeded(false);

  Stream<List<OtherServiceData>> get getOtherProductList => _otherProductStream.stream;

  //Other Services data fetch from Firebase
  fetchOtherProductFromRemoteConfig(String? deviceDialCode) async {
    isOtherProductLoading.sink.add(true);
    String fbOtherService = await FirebaseRemoteConfigController.shared
        .Data(key: FirebaseRemoteConfigConstants.keyOtherServices);
    OtherServicesModel otherServicesModel =
        OtherServicesModel.fromJson(json.decode(fbOtherService));
    isOtherProductLoading.sink.add(false);
    if (otherServicesModel.data != null) {
      List<OtherServiceData> list = [];

      for (var serviceData in otherServicesModel.data!) {
        if (serviceData.countryAllow != null && serviceData.countryAllow == "ALL") {
          list.add(serviceData);
        } else if (serviceData.countryAllow != null && serviceData.countryAllow == deviceDialCode) {
          list.add(serviceData);
        } else if (serviceData.countryAllow != null &&
            "AU" != deviceDialCode &&
            serviceData.countryAllow == "NOT-AU") {
          list.add(serviceData);
        }
      }
      _otherProductStream.sink.add(list);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate(BuildContext context) async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (FirebaseRemoteConfigController.shared.severity == "0") {
          InAppUpdate.performImmediateUpdate()
              // ignore: invalid_return_type_for_catch_error
              .catchError((e) => Toast.show(context, message: e.toString()));
        } else {
          //forcefully update dialog for android
          appUpdateAlertWidget(context, FirebaseRemoteConfigController.shared.description);
        }
      }
    }).catchError((e) {});
  }

  checkAppUpdate(BuildContext context, String severity, String version, String desc) async {
    /*update app dialog for iPhone*/
    packageInfo = await PackageInfo.fromPlatform();
    var iPhoneVersion = "";
    String appUpdateURL = "https://itunes.apple.com/lookup?id=1619089046";
    BaseResponseModel result = await DashboardRepository.getAppVersion(appUpdateURL);

    if (result.statusCode == Constants.statusCodeForApiData && result.flag == true) {
      iPhoneVersion = json.decode(result.data)['results'][0]['version'];
      if (iPhoneVersion.isNotEmpty) {
        int appStoreVersion = Utility.getExtendedVersionNumber(iPhoneVersion); // return 10020003
        int currentAppVersion = Utility.getExtendedVersionNumber(packageInfo?.version ?? '');
        var value = currentAppVersion.compareTo(appStoreVersion);
        if (value == -1) {
          if (severity == "0") {
            appUpdateAlertWidgetiOS(context, desc);
          } else {
            appUpdateAlertWidget(context, desc);
          }
        }
      }
    }
  }

  //MERGE RECENT COURSE SEARCH AND RECENT OCCUPATION SEARCH LIST IN MODEL
  final allRecentSearchListStream = BehaviorSubject<List<RecentSearchData>>();

  Stream<List<RecentSearchData>> get getAllRecentSearchListStream =>
      allRecentSearchListStream.stream;

  getRecentSearchMergedData(
      CoursesBloc coursesBloc, OccupationListBloc occupationBloc, GlobalBloc globalBloc) async {
    List<RecentSearchData> allRecentSearchList = [];

    //COURSE
    List<RecentCourseTable> courseRecentList = [];
    if (globalBloc.subscriptionType == AppType.PAID) {
      List<RecentCourseTable> recentCourseTable = await coursesBloc.getCourseRecentList();
      courseRecentList.addAll(recentCourseTable);

      for (int i = 0; i < courseRecentList.length; i++) {
        RecentSearchData recentSearchModel = RecentSearchData(
            code: courseRecentList[i].cricos,
            mainId: courseRecentList[i].ascedCode,
            name: courseRecentList[i].courseName,
            skillLevel: courseRecentList[i].skillLevel,
            timestamp: courseRecentList[i].timestamp,
            type: RecentSearchType.COURSE.name);
        allRecentSearchList.add(recentSearchModel);

        allRecentSearchListStream.sink.add(allRecentSearchList);
      }
    }

    //Occupation
    List<RecentOccupationTable> recentListOccupation = [];
    List<RecentOccupationTable> recentOccupationTable =
        await occupationBloc.getOccupationsRecentList();
    recentListOccupation.addAll(recentOccupationTable);

    for (int i = 0; i < recentListOccupation.length; i++) {
      RecentSearchData recentSearchModel = RecentSearchData(
          code: recentListOccupation[i].occuID,
          mainId: recentListOccupation[i].occuMainID,
          name: recentListOccupation[i].occuName,
          skillLevel: recentListOccupation[i].skillLevel,
          timestamp: recentListOccupation[i].timestamp,
          type: RecentSearchType.OCCUPATION.name);
      allRecentSearchList.add(recentSearchModel);

      allRecentSearchListStream.sink.add(allRecentSearchList);
    }

    allRecentSearchList.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
  }

  //Related occupations list variables
  final ugCodeOccupationModelSubject = BehaviorSubject<UnitGroupOccupationListModel?>();

  //Get
  Stream<UnitGroupOccupationListModel?> get getUGCodeOccupationModelStream =>
      ugCodeOccupationModelSubject.stream;

  //Show related occupations list on the basis of last searched occupation
  Future<void> getOccupationListFromUnitGroup() async {
    ugCodeOccupationModelSubject.sink.add(UnitGroupOccupationListModel.loading(true));
    //get last viewed occupation from database
    List<RecentOccupationTable>? recentOccupationList =
        await RecentOccupationTable.getLastRecordOfOccupation();
    //get data from local DB
    var unitGroupData = await UnitGroupRepository.getAllUnitGroupFromDb() ?? [];

    if (recentOccupationList != null && recentOccupationList.isNotEmpty) {
      String ugCode = recentOccupationList[0].occuID!.substring(0, 4);
      bool flag = false;
      for (int i = 0; i < unitGroupData.length; i++) {
        if (unitGroupData[i].ugCode == ugCode) {
          UnitGroupOccupationListModel unitGroupOccupationListModel = UnitGroupOccupationListModel(
              occupationCode: recentOccupationList[0].occuID,
              occupationName: recentOccupationList[0].occuName,
              occupationDataList: []);

          for (int j = 0; j < unitGroupData[i].occupation!.length; j++) {
            OccupationDataList occupationDataList = OccupationDataList(
                occCode: unitGroupData[i].occupation![j].occupationCode,
                occName: unitGroupData[i].occupation![j].occupationName,
                ugCode: unitGroupData[i].occupation![j].ugCode,
                skillLevel: unitGroupData[i].occupation![j].skillLevel);
            unitGroupOccupationListModel.occupationDataList!.add(occupationDataList);
          }
          flag = true;
          unitGroupOccupationListModel.isLoading = false;
          ugCodeOccupationModelSubject.sink.add(unitGroupOccupationListModel);
          break;
        }
      }
      if (!flag) {
        ugCodeOccupationModelSubject.sink.add(UnitGroupOccupationListModel.loading(false));
        ugCodeOccupationModelSubject.sink.add(null);
      }
    } else {
      ugCodeOccupationModelSubject.sink.add(UnitGroupOccupationListModel.loading(false));
      ugCodeOccupationModelSubject.sink.add(null);
    }
  }

  // Firebase realtime database for contact us dashboard for only --> Melbourne branch
  getDashboardContactBranchFromFirebaseRealtimeDB() async {
    isContactBranchLoading.sink.add(true);
    final response = await FirebaseDatabaseController.getRealtimeData(
        key: FirebaseRealtimeDatabaseConstants.dashboardContactBranchString);
    if (response != null) {
      AussizzBranches aussizzBranches;
      final contactUsData = jsonEncode(response);
      aussizzBranches = AussizzBranches.fromJson(jsonDecode(contactUsData));
      if (!contactBranchStream.isClosed) {
        contactBranchStream.sink.add(aussizzBranches);
      }
      isContactBranchLoading.sink.add(false);
    }
  }

  @override
  void dispose() {
    // bookmarkByTypeListStream.close();
    // _recentUpdateStream.close();
    // isRecentUpdateLoading.close();
    // _otherProductStream.close();
    // isOtherProductLoading.close();
    // _bookmarkOccupationStream.close();
  }
}

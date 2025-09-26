// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_se_visa_type_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_state_eligibility_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_state_eligibility_statewise_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/so_state_eligibility_repo.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SoStateEligibilityBloc extends RxBlocTypeBase {
  String errorMsg = "";
  BuildContext? _context;
  OccupationDetailBloc? searchOccupationBloc;
  bool tabLoader = false;
  bool loading = false;

  //from Details bloc
  SEDData? selectedRegionData;

  setBloc(BuildContext context) {
    setTabSelectedIndex = 0;
    _context = context;
    searchOccupationBloc = searchOccupationBloc ??
        RxBlocProvider.of<OccupationDetailBloc>(context);
  }

  //TAB SELECTED INDEX
  final tabSelectedIndex = BehaviorSubject<int>.seeded(0);

  set setTabSelectedIndex(index) => tabSelectedIndex.sink.add(index);

  get getTabSelectedIndex => tabSelectedIndex.stream.value;

// [State Eligibility Detail]

  //STATE LIST STREAM
  final soStateListStream =
      BehaviorSubject<List<StateEligibilityDetailRowData>>();

  set setSoStateList(List<StateEligibilityDetailRowData> list) {
    soStateListStream.add(list);
  }

  //VISA TYPE LIST STREAM
  final visaTypeListStream = BehaviorSubject<List<VisaTypeData>>();

  set setVisaTypeList(List<VisaTypeData> list) {
    list.sort((a, b) => (a.visaType as int).compareTo(b.visaType as int));

    visaTypeListStream.sink.add(list);
    getVisaTypeList[0].isTabSelected = true;
    callStateListApiFirstTime();
  }

  List<VisaTypeData> get getVisaTypeList => visaTypeListStream.stream.value;

  //State Eligibility
  List<StateEligibilityStateWiseModel> _stateEligibilityData = [];
  List<StateEligibilityStateWiseModel> _stateEligibilityDataList = [];

  int get getStateEligibilityDataLength =>
      _stateEligibilityData.isEmpty ? 0 : _stateEligibilityData.length;

  set setStateEligibilityData(List<StateEligibilityStateWiseModel> list) {
    _stateEligibilityData = list;
  }

  callStateListApiFirstTime() async {
    await callAPItoGetStateEligibilityStateWiseData(
        searchOccupationBloc?.selectedOccupationID ?? '',
        "${getVisaTypeList[0].visaType ?? 0}",
        "${getVisaTypeList[0].visaType ?? 0}");
    // getAllStateDetailsListFirstTime();
  }

  StateEligibilityStateWiseModel getStateEligibilityData() {
    if (_stateEligibilityData.isNotEmpty) {
      for (var stateListModel in _stateEligibilityData) {
        if (stateListModel.visaTypeCode ==
            "${getVisaTypeList[getTabSelectedIndex].visaType}") {
          return stateListModel;
        }
      }
    }

    return _stateEligibilityData.isNotEmpty
        ? _stateEligibilityData[0]
        : StateEligibilityStateWiseModel();
  }

  // [VISA LIST] API CALLING
  Future<void> callVisaList(String occupationID) async {
    // If data is null then call API else load from previously call api data...
    if (_stateEligibilityData.isNotEmpty) {
      return;
    }

    tabLoader = true;
    visaTypeListStream.sink.add([]);

    try {
      errorMsg = "";
      BaseResponseModel result =
          await SoStateEligibilityRepo.getStateEligibilityVisaListAPICall();

      tabLoader = false;
      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        SeVisaTypeModel vtModel = SeVisaTypeModel.fromJson(result.data);
        if (vtModel.flag == true &&
            vtModel.data != null &&
            vtModel.data!.isNotEmpty) {
          // VISA TYPE LIST
          setVisaTypeList = vtModel.data!;
        } else {
          setVisaTypeList = [];
          setStateEligibilityData = [];
        }
        errorMsg = vtModel.message.toString();
      } else {
        if (result.statusCode == NetworkAPIConstant.statusCodeNoInternet) {
          //toast removed as per bug given by QA, whole no internet screen added.
          errorMsg = StringHelper.internetConnection;
        } else {
          errorMsg = StringHelper.occupationFailToGetStateEligibilityDetail;
          Toast.show(_context!,
              message: errorMsg,
              gravity: Toast.toastTop,
              type: Toast.toastError);
        }
      }
    } catch (e) {
      tabLoader = false;
      errorMsg = e.toString();
      debugPrint(e.toString());
    }
  }

  // MANAGE VISA TYPE TAB [190, DAMA, 491]
  manageTabs(VisaTypeData visaTypeModel, occupationCode) async {
    for (int i = 0; i < getVisaTypeList.length; i++) {
      getVisaTypeList[i].isTabSelected = false;
    }

    setTabSelectedIndex = getVisaTypeList.indexOf(visaTypeModel);

    getVisaTypeList[getTabSelectedIndex].isTabSelected = true;

    visaTypeListStream.sink.add(getVisaTypeList);

    // Check if data available
    bool isDataAvailable = false;

    if (_stateEligibilityData.isEmpty) {
      await callAPItoGetStateEligibilityStateWiseData(occupationCode,
          "${visaTypeModel.visaType ?? 0}", "${visaTypeModel.visaType ?? 0}");
      isDataAvailable = true;
    } else {
      for (int i = 0; i < _stateEligibilityData.length; i++) {
        if (getVisaTypeList[getTabSelectedIndex].visaType.toString() ==
            _stateEligibilityData[i].visaTypeCode) {
          isDataAvailable = true;
          break;
        }
      }
    }

    if (!isDataAvailable) {
      if (_stateEligibilityData.isNotEmpty) {
        for (var visaModel in _stateEligibilityData) {
          if (visaModel.visaTypeCode != "${visaTypeModel.visaType}") {
            await callAPItoGetStateEligibilityStateWiseData(
                occupationCode,
                "${visaTypeModel.visaType ?? 0}",
                "${visaTypeModel.visaType ?? 0}");
          }
        }
      } else {
        await callAPItoGetStateEligibilityStateWiseData(occupationCode,
            "${visaTypeModel.visaType ?? 0}", "${visaTypeModel.visaType ?? 0}");
      }
    } else {
      setSoStateList = [];
      getAllStateDetailsListFirstTime();
    }
  }

  // [STATE ELIGIBILITY] CALL  API TO GET STATE ELIGIBILITY & REGION CONDITION DATA
  Future<void> callAPItoGetStateEligibilityStateWiseData(
      String occupationID, String visaType, String visaName) async {
    try {
      String param = "occupation_code=$occupationID&visa_type=$visaType";
      loading = true;
      setSoStateList = [];
      BaseResponseModel result =
          await SoStateEligibilityRepo.getStateEligibilityStateWiseAPICall(
              param);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        StateEligibilityStateWiseModel stateEligibilityStateWiseModel =
            StateEligibilityStateWiseModel.fromJson(result.data);

        if (stateEligibilityStateWiseModel.flag == true &&
            stateEligibilityStateWiseModel.data != null &&
            stateEligibilityStateWiseModel.data!.stateList != null &&
            stateEligibilityStateWiseModel.data!.stateList!.isNotEmpty) {
          stateEligibilityStateWiseModel.visaTypeTitle = visaName;
          stateEligibilityStateWiseModel.visaTypeCode = visaType;

          _stateEligibilityDataList.add(stateEligibilityStateWiseModel);
          List<StateEligibilityStateWiseModel> list = _stateEligibilityDataList;
          setStateEligibilityData = list;
          getAllStateDetailsListFirstTime();
        }
      }
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
    }
  }

  Future<StateEligibilityDetailModel?> callStateEligibilityDetailAPI(
      StateCondition? stateCondition) async {
    try {
      String param = "occupation_code=${stateCondition?.occupationCode ?? 0}"
          "&visa_type=${stateCondition?.visaType ?? ''}"
          "&condition_type=${stateCondition?.condition ?? ''}"
          "&state=${stateCondition?.state ?? ''}"
          "&region=${stateCondition?.region ?? ''}";

      BaseResponseModel result =
          await SoStateEligibilityRepo.getStateEligibilityDetail(param);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        StateEligibilityDetailModel model =
            StateEligibilityDetailModel.fromJson(result.data);
        if (model.flag == true && model.data != null) {
          // General Detail
          if (model.data!.staterequirementG != null &&
              model.data!.staterequirementG!.isNotEmpty) {
            List<SoStateEligibilityGeneralMode> gList = [];
            for (var data in model.data!.staterequirementG!) {
              gList.add(SoStateEligibilityGeneralMode(
                  label: data.condition ?? "", value: data.cvalue ?? ""));
            }
            model.data!.generalDetailList = gList;
          }

          // State Special Requirements
          if (model.data!.staterequirementSpe != null &&
              model.data!.staterequirementSpe!.isNotEmpty) {
            List<SoStateEligibilityGeneralMode> speList = [];
            for (var data in model.data!.staterequirementSpe!) {
              speList.add(SoStateEligibilityGeneralMode(
                  label: "", value: data.cvalue ?? ""));
            }
            model.data!.specialRequirementList = speList;
          }

          // ENS - English Requirement
          if (model.data!.engReq != null && model.data!.engReq!.isNotEmpty) {
            List<EngReq> englishRequirement = [];
            englishRequirement.add(EngReq(
                englishRequirementId: "",
                erCategoryId: "",
                examType: "Exam",
                listening: "Listening",
                reading: "Reading",
                writing: "Writing",
                speaking: "Speaking",
                overall: "Overall",
                overall2: "",
                createdDate: "",
                updatedDate: "",
                createdBy: "",
                updatedBy: ""));
            englishRequirement.addAll(model.data!.engReq!);
            model.data!.engReq = englishRequirement;
          }

          // TSS - English Requirement
          if (model.data!.engReqEns != null &&
              model.data!.engReqEns!.isNotEmpty) {
            List<EngReqENS> englishENSRequirement = [];
            englishENSRequirement.add(EngReqENS(
                englishRequirementId: "",
                erCategoryId: "",
                examType: "Exam",
                listening: "Listening",
                reading: "Reading",
                writing: "Writing",
                speaking: "Speaking",
                overall: "Overall",
                overall2: "",
                createdDate: "",
                updatedDate: "",
                createdBy: "",
                updatedBy: ""));
            englishENSRequirement.addAll(model.data!.engReqEns!);
            model.data!.engReqEns = englishENSRequirement;
          }
          StateEligibilityDetailModel stateDetail =
              StateEligibilityDetailModel();
          stateDetail.region = stateCondition?.region ?? '';
          stateDetail.data = model.data;
          return stateDetail;
        } else {
          Toast.show(message: model.message.toString(), _context!);
          return null;
        }
      } else {
        if (result.statusCode == NetworkAPIConstant.statusCodeNoInternet) {
          errorMsg = StringHelper.internetConnection;
        } else {
          errorMsg = StringHelper.occupationFailToGetStateEligibilityDetail;
        }
        Toast.show(
            message: errorMsg,
            _context!,
            gravity: Toast.toastTop,
            type: Toast.toastError);
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  int firstIndexToOpen = -1;

  getAllStateDetailsListFirstTime() async {
    if (getStateEligibilityDataLength != 0 &&
        getStateEligibilityDataLength >= getTabSelectedIndex) {
      StateEligibilityStateWiseModel stateWiseModel = getStateEligibilityData();
      List<StateEligibilityDetailRowData> soStateList =
          stateWiseModel.data?.stateList ?? [];

      /*for(StateEligibilityDetailRowData stateData in soStateList){
        List<StateCondition>? list = (stateData.stateCondition ?? []);
        if(list.isNotEmpty){
          for(StateCondition stateCondition in list){
            if(stateCondition.stateEligibilityDetailModel != null){
              setSoStateList = soStateList;
              return;
            }
          }
        }
      }*/

      // 291 = DAMA if STATE is DAMA than we have to skip "" & "ACT" state
      // as per the web team make fix condition on this...
      if (stateWiseModel.visaTypeCode == "291") {
        soStateList = [];
        for (var stateData in stateWiseModel.data?.stateList ?? []) {
          // if typecode == DAMA & state is 'tasmania' OR 'act' then skip this state
          if (stateData.state!.toLowerCase() != "tasmania" &&
              stateData.state!.toLowerCase() != "act") {
            soStateList.add(stateData);
          }
        }
        stateWiseModel.data?.stateList = soStateList;
        _stateEligibilityData[getTabSelectedIndex] = stateWiseModel;
      }

      int i = 0;
      for (StateEligibilityDetailRowData stateData in soStateList) {
        for (StateCondition stateCondition in stateData.stateCondition ?? []) {
          if (stateCondition.stateEligibilityDetailModel == null) {
            StateEligibilityDetailModel? stateEligibilityDetailModel =
                await callStateEligibilityDetailAPI(stateCondition);
            stateCondition.stateEligibilityDetailModel =
                stateEligibilityDetailModel;
          }
        }
        if (stateData.stateCondition != null &&
            stateData.stateCondition!.isNotEmpty &&
            firstIndexToOpen == -1) {
          firstIndexToOpen = i;
        }
        i++;
      }

      loading = false;
      setSoStateList = soStateList;
    }
  }

  clearAll() {
    _stateEligibilityDataList = [];
    setVisaTypeList = [];
    _stateEligibilityData = [];
    setTabSelectedIndex = 0;
  }

  @override
  void dispose() {
    tabSelectedIndex.close();
    soStateListStream.close();
    visaTypeListStream.close();
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_eoi_statistics_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'so_eoi_statistics_repo.dart';

class SoEOIStatisticsBloc extends RxBlocTypeBase {
  String errorMsg = "";
  BuildContext? _context;
  OccupationDetailBloc? searchOccupationBloc;
  List<String> infoMessage = [
    "An EOI that meets all the requirements for all selected visa subclasses and has all fields completed can be submitted. Once submitted, points are attributed to the EOI based on the information provided. Submitted EOIs are eligible for selection in an invitation round, by a State and Territory government agency or Austrade, depending on the visa subclass(es) selected.",
    "A visa application has been lodged using an invitation to apply for a visa.",
    "An intending migrant can suspend their EOI. Suspending an EOI means the EOI is not visible to State and Territory government agencies or Austrade and cannot be invited in an invitation round.",
    "An invitation to apply for a visa has been issued."
  ];
  String noteMsg = "";

  DateTime now = DateTime.now();
  DateTime? defaultSelectedMonthYear;

  /*  Loading status getter, setter  */
  final loading = BehaviorSubject<bool>.seeded(false);

  set setLoading(bool value) => loading.sink.add(value);

  bool get getLoadingValue => loading.stream.value;

  // Expanded page viewer position index
  final pageViewPositionIndex = BehaviorSubject<int>.seeded(0);

  int get getPageViewPositionIndex => pageViewPositionIndex.stream.value;

  set setPagePosition(int index) {
    pageViewPositionIndex.sink.add(index);
  }

  //EOI-STATISTICS DATA STREAM
  final eOIStatisticsDataStream = BehaviorSubject<List<EOIData>>();

  List<EOIData> get getEOIStatisticsData =>
      eOIStatisticsDataStream.stream.value;

  set setEOIStatisticsCountData(List<EOIData> data) {
    eOIStatisticsDataStream.sink.add(data);
  }

  // TRUE = Table view, FALSE = Chart view
  final viewMode = BehaviorSubject<bool>.seeded(false);

  bool get getViewMode => viewMode.stream.value;

  setViewMode() {
    viewMode.sink.add(!getViewMode);
    setPagePosition = 0;
  }

  // [MONTH]
  // Initial Selected Value for month
  String strMonthSelectedName = 'Jan';
  int strMonthSelectedValue = 0;

  // Initial Selected Value for month
  String strYearSelectedValue = '2018';

  List<String> monthList = [];

  List<String> get getMonthList => monthList;

  set setMonth(String strMonth) {
    strMonthSelectedName = strMonth;
    strMonthSelectedValue = monthList.indexOf(strMonth) + 1;

    // Calling API
    //callEOIStatisticsCountList();
  }

  String get getSelectedMonth => strMonthSelectedName;

  // Filter statistics data based on current PageViewer Index
  getCurrentStatisticsCountList(int index) {
    if (getEOIStatisticsData.length > index) {
      return getEOIStatisticsData[index].eoiCountData;
    } else {
      return [];
    }
  }

  getEOIVisaTitle(int index) {
    if (getEOIStatisticsData.length > index) {
      return getEOIStatisticsData[index].vType;
    } else {
      return "";
    }
  }

  //SET TYPE
  String strType = "SUBMITTED";

  String get getType => strType;

  setType(String type, int index) {
    if (getType == type) {
      return;
    }
    strType = type;
    noteMsg = infoMessage[index];

    // Calling API
    callEOIStatisticsCountList();
  }

  //YEAR
  List<String> yearList = [];

  List<String> get getYearList => yearList;

  set setYear(String strYear) {
    strYearSelectedValue = strYear;
    // Calling API
    //callEOIStatisticsCountList();
  }

  String get getSelectedYear => strYearSelectedValue;

  setMonthYearData() {
    noteMsg = infoMessage[0];
    // SET MONTH LIST
    monthList = Utility.getMonthNameList();
    // SET YEAR SELECTION LIST
    for (int i = 2018; i <= now.year; i++) {
      yearList.add("$i");
    }
    defaultSelectedMonthYear = DateTime(now.year, now.month - 5, 1);
    strYearSelectedValue = '${defaultSelectedMonthYear!.year}';
    strMonthSelectedName = monthList[defaultSelectedMonthYear!.month - 1];
    strMonthSelectedValue = monthList.indexOf(strMonthSelectedName) + 1;
  }

  // [EOI STATISTICS] API CALLING
  Future<void> callEOIStatisticsCountList() async {
    try {
      errorMsg = "";
      setLoading = true;
      String strSelectedMonth = strMonthSelectedValue < 9
          ? "0$strMonthSelectedValue"
          : "$strMonthSelectedValue";
      String status = getType == "HELD" ? 'HOLD' : getType;
      String param =
          "Occupation_Code=${searchOccupationBloc?.selectedOccupationID}&status=$status&month=$strSelectedMonth&year=$strYearSelectedValue";
      debugPrint(
          "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.searchOccupation!.getEOIStatisticsCountData}$param");
      BaseResponseModel result =
          await SoEOIStatisticsRepo.getEOIStatisticsAPICall(param);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        EOIStatisticsModel eoiStatisticsModel =
            EOIStatisticsModel.fromJson(result.data);
        if (eoiStatisticsModel.flag == true &&
            eoiStatisticsModel.data != null) {
          // Process on EOI Statistics Data
          setEOIStatisticsCountData = eoiStatisticsModel.data!.eOIData ?? [];
        } else {
          setEOIStatisticsCountData = [];
        }
        setLoading = false;
      } else {
        if (result.statusCode == NetworkAPIConstant.statusCodeNoInternet) {
          errorMsg = StringHelper.internetConnection;
        } else {
          errorMsg = StringHelper.occupationFailToGetEoiStatisticsDetail;
        }
        setLoading = false;
        Toast.show(_context!,
            message: errorMsg, gravity: Toast.toastTop, type: Toast.toastError);
      }
      setPagePosition = 0;
    } catch (e) {
      setLoading = false;
      debugPrint(e.toString());
    }
  }

  void clearAll() {
    errorMsg = "";
    now = DateTime.now();
    defaultSelectedMonthYear = null;

    // Initial Selected Value for month
    strMonthSelectedName = '';
    strMonthSelectedValue = 0;

    // Initial Selected Value for month
    strYearSelectedValue = '';

    yearList = [];
    monthList = [];

    setEOIStatisticsCountData = [];
    strType = "SUBMITTED";
    viewMode.sink.add(false);
  }

  void reInitialize() {
    now = DateTime.now();
    defaultSelectedMonthYear = null;
    yearList = [];
    monthList = [];
    viewMode.sink.add(false);
  }

  setBloc(setSearchOccupationBloc) {
    searchOccupationBloc = setSearchOccupationBloc;
  }

  @override
  void dispose() {}
}

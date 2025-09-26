// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/app/global_repository.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';
import 'package:occusearch/features/dashboard/recent_updates/model/recent_update_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class GlobalBloc extends RxBlocTypeBase {
  // VARIABLE
  BuildContext? context;
  bool needToShowAdsDialog = false;
  bool checkUserIsFromSplash =
      false; //if true = user came from splash screen else false

  final _countryStream = BehaviorSubject<List<CountryModel>>();
  final _deviceCountryShortcode = BehaviorSubject<String>(); // 'IN', 'US' etc.,
  final _deviceCountryDialCode = BehaviorSubject<String>(); // '+91', '+1' etc.,
  final userInfoStream = BehaviorSubject<UserInfoData>(); // '+91', '+1' etc.,
  var subscriptionType = AppType.FREE_TRIAL; // "FREE","PAID","EXPIRED"
  var isShowDialogSubscription =
      false; // subscription enable dialog when existing user login first time

  List<CountryModel> _countryDataList = [];

  //for dashboard
  List<Recordset> recentUpdateList = [];

  //store 10 data of Course List
  final cache10CourseListRecords = BehaviorSubject<List<CourseList>>();

  // GET
  Stream<List<CountryModel>> get getCountryList => _countryStream.stream;

  List<CountryModel> get getCountryListValue =>
      _countryStream.valueOrNull ?? [];

  String? get getCurrentDeviceCountryValue =>
      _deviceCountryDialCode.valueOrNull;

  Stream<String> get getDeviceCountryShortcodeStream =>
      _deviceCountryShortcode.stream;

  String get getDeviceCountryShortcodeValue =>
      _deviceCountryShortcode.valueOrNull ?? '';

  Stream<UserInfoData> get getUserInfoStream => userInfoStream.stream;

  set clearUserInfo(info) => userInfoStream.sink.add(info);

  Future<UserInfoData> getUserInfo(BuildContext context) async {
    if (userInfoStream.valueOrNull == null) {
      UserInfoData info = await SharedPreferenceController.getUserData();
      userInfoStream.sink.add(info);
      return info;
    } else {
      return userInfoStream.value;
    }
  }

  // [COUNTRY DATA] Firebase Remote Config
  Future<List<CountryModel>> getCountryListFromRemoteConfig() async {
    if (_countryDataList.isNotEmpty) return _countryDataList;
    String firebaseCountryData = await FirebaseRemoteConfigController.shared
        .Data(key: FirebaseRemoteConfigConstants.keyCountry);
    var jsonData = json.decode(firebaseCountryData);

    _countryDataList = (jsonData as List)
        .map<CountryModel>((json) => CountryModel.fromJson(json))
        .toList();
    _countryStream.sink.add(_countryDataList);
    return _countryDataList;
  }

  // [DEVICE NETWORK INFORMATION]
  getDeviceCountryInfo() async {
    if (getCurrentDeviceCountryValue != null &&
        getCurrentDeviceCountryValue != "") {
      return;
    }

    /*{
          "status": "success","country": "India","countryCode": "IN","region": "GJ","regionName": "Gujarat","city": "Ahmedabad","zip": "380001",......
    }*/
    BaseResponseModel response = await GlobalRepository.getDeviceCountryInfo();

    if (response.flag == true &&
        response.data != null &&
        response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
      Map countryData = response.data.cast<String, dynamic>();
      String countryCode = countryData['countryCode'];
      _deviceCountryShortcode.sink.add(countryCode);

      // By passing country short code(like 'IN', 'US' etc) and return +91, +1 etc
      if (getCountryListValue.isNotEmpty) {
        CountryModel data = getCountryListValue.firstWhere((countryModel) =>
            (countryModel.code ?? '').toUpperCase() ==
            countryCode.toUpperCase());
        _deviceCountryDialCode.sink.add(data.dialCode ?? '');
      }
    } else {
      printLog("#GlobalBloc# Device country data not found.");
    }
  }

  // [LOGIN USER INFO]
  setUserInfoData(BuildContext context) async {
    UserInfoData info = await SharedPreferenceController.getUserData();
    if (info.leadCode != null && info.leadCode != "") {
      userInfoStream.sink.add(info);
    } else {
      // USER LOGIN DATA NOT FOUND IN SharedPreference
      Toast.show(context,
          message: StringHelper.userSessionExpireErrorMsg,
          type: Toast.toastError,
          duration: 2);
      GoRoutesPage.go(mode: NavigatorMode.remove, moveTo: RouteName.onboarding);
    }
  }

  // GET Occupation Visit List count
  final mostVisitedCountOccupationStream =
      BehaviorSubject<List<OccupationRowData>>();

  set occupationsVisitedCountSort(List<OccupationRowData>? list) {
    if (list != null && list.isNotEmpty) {
      list.sort((a, b) => b.visitCount!.compareTo(a.visitCount!));
      list.length = 5;
      mostVisitedCountOccupationStream.sink.add(list);
    }
  }

  Future<void> getOccupationVisitedCountData() async {
    List<OccupationRowData>? occupationData =
        await GlobalRepository.getAllOccupationFromDb() ?? [];
    if (occupationData.isNotEmpty) {
      occupationsVisitedCountSort = occupationData;
    }
  }

  @override
  void dispose() {
    _countryStream.close();
    _deviceCountryShortcode.close();
    _deviceCountryDialCode.close();
    userInfoStream.close();
  }
}

import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/common_widgets/loading_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/push_notification/push_notification.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/authentication/authentication_repository.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/get_my_policy/gmp_repository.dart';
import 'package:occusearch/features/get_my_policy/model/gmp_model.dart';
import 'package:occusearch/features/get_my_policy/model/oshc_provider_data_model.dart';
import 'package:occusearch/features/get_my_policy/model/ovhc_data_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

@RxBloc()
class GetMyPolicyBloc extends RxBlocTypeBase {
  final _loading = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get getLoadingSubject => _loading.stream;

  bool get isLoading => _loading.value;

  set setLoading(flag) => _loading.sink.add(flag);

  final _loadingMessage = BehaviorSubject<List<String>?>();

  Stream<List<String>?> get getLoadingMessage => _loadingMessage.stream;

  set setLoadingMessage(messages) => _loadingMessage.sink.add(messages);

  final visaTypeStream = BehaviorSubject<List<PolicyData>>();

  Stream<List<PolicyData>> get getVisaTypeListStream => visaTypeStream.stream;

  final selectedVisaTypeStream = BehaviorSubject<PolicyData>();

  Stream<PolicyData> get getSelectedVisaTypeListStream =>
      selectedVisaTypeStream.stream;

  final coverTypeStream = BehaviorSubject<List<PolicyData>>();

  Stream<List<PolicyData>> get getCoverTypeListStream => coverTypeStream.stream;

  final selectedCoverTypeStream = BehaviorSubject<PolicyData>();

  Stream<PolicyData> get getSelectedCoverTypeListStream =>
      selectedCoverTypeStream.stream;

  final _startingDateValue = BehaviorSubject<String>();

  Function(String) get onChangeStartingDate => _startingDateValue.sink.add;

  final _oshcStartDateValue = BehaviorSubject<String>();

  Function(String) get onChangeOshcStartingDate => _oshcStartDateValue.sink.add;

  final _oshcEndDateValue = BehaviorSubject<String>();

  Function(String) get onChangeOshcEndDate => _oshcEndDateValue.sink.add;

  TextEditingController ovhcDateEditingController = TextEditingController();

  TextEditingController startDateEditingController = TextEditingController(
      text: DateFormat('dd-MMM-yyyy').format(DateTime.now()));

  DateTime currentDate = DateTime.now();
  TextEditingController endDateEditingController = TextEditingController(
    text: DateFormat('dd-MMM-yyyy').format(DateTime(
        DateTime.now().year + 1, DateTime.now().month, DateTime.now().day + 1)),
  );

  final durationBetweenDates = BehaviorSubject<String>();

  final oSHCCoverTypeStream = BehaviorSubject<List<PolicyData>>();

  final oVHCListStream = BehaviorSubject<List<DataModel>>();

  Stream<List<DataModel>> get getOVHCListStream => oVHCListStream.stream;

  final providerStream = BehaviorSubject<List<PolicyData>>();

  Stream<List<PolicyData>> get getProviderListStream => providerStream.stream;

  final selectedProviderStream = BehaviorSubject<PolicyData>();

  Stream<PolicyData> get getSelectedProviderStream =>
      selectedProviderStream.stream;

  final selectedSortingStream = BehaviorSubject<String>();

  Stream<String> get getSelectedSortingStream => selectedSortingStream.stream;

  GetMyPolicyModel? getMyPolicyModel;

  //For email picker dialog
  final loadingEmail = BehaviorSubject<bool>.seeded(false);

  final _loadingSubject = BehaviorSubject<Map<int, bool>>.seeded({});

  Stream<Map<int, bool>> get loadingStream => _loadingSubject.stream;

  void setLoadingData(int index, bool isLoading) {
    final currentMap = _loadingSubject.value;
    currentMap[index] = isLoading;
    _loadingSubject.add(currentMap);
  }

  initData() async {
    var getMyPolicy =
        await FirebaseRemoteConfigController.shared.Data(key: FirebaseRemoteConfigConstants.keyGetMyPolicy);
    getMyPolicyModel = GetMyPolicyModel.fromJson(json.decode(getMyPolicy));
    visaTypeStream.add(getMyPolicyModel!.oVHCVisaType!);
    coverTypeStream.add(getMyPolicyModel!.oVHCCoverType!);
    oSHCCoverTypeStream.add(getMyPolicyModel!.oSHCCoverType!);
    providerStream.add(getMyPolicyModel!.oVHCProviders!);
  }

  Future<void> getOHSCDetails(
      BuildContext context, GetMyPolicyBloc getMyPolicyBloc) async {
    var requestJSON = {
      /*RequestParameterKey.serverKey: FirebaseRemoteConfigController
              .shared.dynamicEndUrl!.general!.gmpServerKey ??
          "",*/
      RequestParameterKey.coverValue: selectedCoverTypeStream.value.id.toString(),
      RequestParameterKey.type: "default",
      RequestParameterKey.startDate: startDateEditingController.text,
      RequestParameterKey.endDate: endDateEditingController.text
    };

    setLoadingMessage = ["Fetching data...", "Please wait..."];
    setLoading = true;

    BaseResponseModel result =
        await GetMyPolicyRepository.getOSHCDetails(requestJSON: requestJSON);
    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        result.flag == true) {
      setLoadingMessage = null;
      setLoading = false;
      OSHCProviderDataModel model = OSHCProviderDataModel.fromJson(result.data);

      if (model.data != null && model.data!.isNotEmpty) {
        var param = {
          "gmpBloc": getMyPolicyBloc,
          "model": model,
        };
        GoRoutesPage.go(
            mode: NavigatorMode.push,
            moveTo: RouteName.gmpOSHCCompareScreen,
            param: param);
      } else {
        Toast.show(context,
            message: "No data found for the selected criteria.",
            type: Toast.toastError);
      }
      printLog(model);
    } else {
      // [Error Handling]
      Toast.show(context,
          message: "No data found for the selected criteria.",
          type: Toast.toastError);
      setLoadingMessage = null;
      setLoading = false;
      return;
    }
  }

  Future<OVHCDataModel> getOVHCDetails(
      BuildContext context, bool isPassProvider) async {
    var requestJSON = {
      // RequestParameterKey.serverKey: FirebaseRemoteConfigController
      //         .shared.dynamicEndUrl!.general!.gmpServerKey ??
      //     "",
      RequestParameterKey.visaType: selectedVisaTypeStream.value.id.toString(),
      RequestParameterKey.coverValue: selectedCoverTypeStream.value.id.toString(),
      RequestParameterKey.startDate: ovhcDateEditingController.text,
      RequestParameterKey.type: "change_filter",
      RequestParameterKey.providerId: selectedProviderStream.hasValue && isPassProvider
          ? selectedProviderStream.value.id.toString()
          : "0",
    };

    setLoadingMessage = ["Fetching data...", "Please wait..."];
    setLoading = true;

    BaseResponseModel result =
        await GetMyPolicyRepository.getOVHCDetails(requestJSON: requestJSON);
    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        result.flag == true &&
        result.data != null) {
      setLoadingMessage = null;
      setLoading = false;
      OVHCDataModel model = OVHCDataModel.fromJson(result.data);
      if (model.data != null && model.data!.isNotEmpty) {
        return model;
      } else {
        Toast.show(context,
            message: "No data found for the selected criteria.",
            type: Toast.toastError);
        return OVHCDataModel();
      }
    } else {
      setLoadingMessage = null;
      setLoading = false;
      Utility.showToastErrorMessage(context, result.statusCode);
      return OVHCDataModel();
      // [Error Handling]
    }
  }

  buyOVHCGmpQuote(BuildContext context, DataModel model, GlobalBloc? globalBloc,
      int index) async {
    // This is for get country dial code from country list
    UserInfoData? userInfoData = await SharedPreferenceController.getUserData();
    CountryModel? countryModel;

    if (userInfoData.countryCode != null && userInfoData.countryCode != "") {
      countryModel = globalBloc?.getCountryListValue
          .firstWhere((element) => element.code == userInfoData.countryCode);
    } else {
      await globalBloc?.getDeviceCountryInfo();
      countryModel = globalBloc?.getCountryListValue.firstWhere((element) =>
      element.code == globalBloc.getDeviceCountryShortcodeValue);
    }

    var requestJSON = {
      RequestParameterKey.emailAddress: userInfoData.email ?? "",
      RequestParameterKey.fullName: userInfoData.name ?? "",
      RequestParameterKey.fullMobileNumber: '${countryModel?.dialCode}${userInfoData.phone ?? ""}',
      RequestParameterKey.providerId: model.providerid ?? "",
      RequestParameterKey.coverType: model.covertypename ?? "",
      RequestParameterKey.providerName: model.name ?? "",
      RequestParameterKey.providerUrl: model.providerurl ?? "",
      RequestParameterKey.filterDate: ovhcDateEditingController.text,
      RequestParameterKey.providerLogo: model.logourl ?? "",
      RequestParameterKey.price: model.price ?? "",
      RequestParameterKey.planName: model.planname ?? "",
      RequestParameterKey.subClass: selectedVisaTypeStream.value.subClass.toString(),
    };

    setLoadingMessage = ["Please wait..."];
    setLoadingData(index, true);

    BaseResponseModel result =
        await GetMyPolicyRepository.buyOVHCQuote(requestJSON: requestJSON);
    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        result.flag == true &&
        result.data != null) {
      if (result.data['code'] == 200 && result.data['status'] == true) {
        setLoadingMessage = null;
        setLoadingData(index, false);
        Utility.launchURL(result.data['data'] ?? model.providerurl ?? "");
      } else {
        setLoadingMessage = null;
        setLoadingData(index, false);
        Toast.show(context,
            message: result.message ?? "", type: Toast.toastError);
      }
    } else {
      setLoadingMessage = null;
      setLoadingData(index, false);
      Utility.showToastErrorMessage(context, result.statusCode);
      // [Error Handling]
    }
  }

  buyOSHCGmpQuote(BuildContext context, OSHCProviderDataModelList model,
      GlobalBloc? globalBloc, int index) async {
    // This is for get country dial code from country list
    UserInfoData? userInfoData = await SharedPreferenceController.getUserData();
    CountryModel? countryModel;

    if (userInfoData.countryCode != null && userInfoData.countryCode != "") {
      countryModel = globalBloc?.getCountryListValue
          .firstWhere((element) => element.code == userInfoData.countryCode);
    } else {
      await globalBloc?.getDeviceCountryInfo();
      countryModel = globalBloc?.getCountryListValue.firstWhere((element) =>
      element.code == globalBloc.getDeviceCountryShortcodeValue);
    }

    var requestJSON = {
      RequestParameterKey.secretKey: {
        RequestParameterKey.sKey: FirebaseRemoteConfigController.shared.dynamicEndUrl!.general!.gmpServerKey,
      },
      RequestParameterKey.purchasePolicy: {
        RequestParameterKey.companyId: 2584,
        RequestParameterKey.branchId: 0,
        RequestParameterKey.leadFirstName: userInfoData.name ?? "",
        RequestParameterKey.leadLastName: "",
        RequestParameterKey.countrycode: countryModel?.dialCode ?? "",
        RequestParameterKey.phoneNo: userInfoData.phone ?? "",
        RequestParameterKey.emailAddress: userInfoData.email ?? "",
        RequestParameterKey.leadSource: "OccuSearch Mobile App",
        RequestParameterKey.insuranceProviderId: model.providerid ?? "",
        RequestParameterKey.insuranceType: "OSHC",
        RequestParameterKey.insuranceStartDate: startDateEditingController.text,
        RequestParameterKey.insuranceEndDate: endDateEditingController.text,
        RequestParameterKey.isLiveInAustralia: false,
        RequestParameterKey.insuranceAmount: model.price?.replaceAll("\$", "") ?? "",
        RequestParameterKey.insuranceAudAmount: model.price?.replaceAll("\$", "") ?? "",
        RequestParameterKey.coverType: selectedCoverTypeStream.value.name,
        RequestParameterKey.isActive: true,
        RequestParameterKey.leadFrom: "Web",
        RequestParameterKey.leadType: "Inquiry",
        RequestParameterKey.createdBy: 0,
        RequestParameterKey.isEmailQuote: false,
        RequestParameterKey.isPhoneQuote: true,
        RequestParameterKey.isMailNotSendKonDesk: false,
      }
    };

    setLoadingData(index, true);

    BaseResponseModel result =
        await GetMyPolicyRepository.buyOSHCQuote(requestJSON: requestJSON);
    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        result.flag == true &&
        result.data != null) {
      if (result.data['data'] != null) {
        setLoadingData(index, false);
        // Utility.launchURL(model.getqouteurl ?? "");
        Utility.launchURL(result.data['data']);
      } else {
        setLoadingData(index, false);
        Toast.show(context,
            message: result.message ?? "", type: Toast.toastError);
      }
    } else {
      setLoadingData(index, false);
      Utility.showToastErrorMessage(context, result.statusCode);
      // [Error Handling]
    }
  }

  // Hide AIA provider if selected visa type is 2, 14, 15
  filterProvider(int selectedVisaType) {
    bool filter = false;
    List<PolicyData> filteredProviderList =
        providerStream.value.where((provider) {
      // Filter out options based on selected Visa Type
      if (selectedVisaType == 2 ||
          selectedVisaType == 14 ||
          selectedVisaType == 15) {
        selectedProviderStream.add(providerStream.value.first);
        filter = true;
        return provider.id == 0 ||
            provider.id == 1 ||
            provider.id == 2 ||
            provider.id == 3 ||
            provider.id == 5;
      }
      return true;
    }).toList();

    providerStream
        .add(filter ? filteredProviderList : getMyPolicyModel!.oVHCProviders!);
  }

  @override
  void dispose() {
    ovhcDateEditingController.clear();
    startDateEditingController.clear();
    endDateEditingController.clear();
  }

  selectDate(
    BuildContext context, {
    bool ovscStartingDate = false,
    bool ohscStartDate = false,
    bool ohscEndDate = false,
    String initDate = "",
  }) async {
    DateTime currentDate = DateTime.now();
    DateTime selectedDate = DateTime.now();
    late final dateFormat = DateFormat('dd-MMM-yyyy');

    if (initDate.isNotEmpty) {
      selectedDate = dateFormat.parse(initDate);
      DateTime dateTime = dateFormat.parse(initDate);
      selectedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate:
          DateTime(currentDate.year + 100, currentDate.month, currentDate.day),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColorStyle.primary(context),
              onPrimary: Colors.white,
              surface: AppColorStyle.background(context),
              onSurface: AppColorStyle.text(context),
            ),
            // cardTheme: CardTheme(color: AppColorStyle.background(context)),
            dialogBackgroundColor: AppColorStyle.background(context),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      if (ovscStartingDate) {
        ovhcDateEditingController.text = dateFormat.format(pickedDate);
      } else if (ohscStartDate) {
        startDateEditingController.text = dateFormat.format(pickedDate);
        DateTime nextYear =
            DateTime(pickedDate.year + 1, pickedDate.month, pickedDate.day + 1);
        endDateEditingController.text = dateFormat.format(nextYear);
        durationBetweenDates.add(setDuration(pickedDate, nextYear));
      } else if (ohscEndDate) {
        endDateEditingController.text = dateFormat.format(pickedDate);
        DateTime startDate = dateFormat.parse(startDateEditingController.text);
        durationBetweenDates.add(setDuration(startDate, pickedDate));
      } else
        ovhcDateEditingController.text = dateFormat.format(pickedDate);
    }
  }

  void filterOVHCList(String filter) {
    if (filter == StringHelper.lowToHigh) {
      oVHCListStream.add([...oVHCListStream.value]
        ..sort((a, b) => (a.price)!.compareTo(b.price!)));
    } else {
      oVHCListStream.add([...oVHCListStream.value]
        ..sort((a, b) => (b.price)!.compareTo(a.price!)));
    }
  }

  String setDuration(DateTime startDate, DateTime endDate) {
    /*final differenceInDays = endDate.difference(startDate).inDays;
    print('$differenceInDays');

    final differenceInMonths = endDate.difference(startDate);
    print('$differenceInMonths');*/

    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;
    int days = endDate.day - startDate.day;

    if (days < 0) {
      final previousMonth =
          DateTime(endDate.year, endDate.month - 1, startDate.day);
      days = endDate.difference(previousMonth).inDays;
      months -= 1;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    return DateDifference(years, months, days).toString();
  }

  void googleSignIn(BuildContext context, Object data, GlobalBloc? globalBLoc,
      int index, bool isFromOVHC) async {
    // PROCESS TO ADD MAIL ACCOUNT IN [EDIT PROFILE SCREEN]
    // JUST VERIFY EMAIL AND CHECK ANY USER FOUND BASED ON EMAIL
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return;
    }
    String emailAddress = signInAccount.email;
    // CHECK USER ACCOUNT DETAILS BASED ON EMAIL ADDRESS
    if (emailAddress.isNotEmpty) {
      verifyEmailAddressUserAccount(
          context, emailAddress, data, globalBLoc, index, isFromOVHC);
    }
  }

  // TO CHECK USER ACCOUNT FOUND OR NOT BY PASSING EMAIL ADDRESS
  verifyEmailAddressUserAccount(BuildContext context, String emailAddress,
      Object data, GlobalBloc? globalBLoc, int index, bool isFromOVHC) async {
    LoadingWidget.show();
    // Get Account details by Email address
    Map<String, dynamic> param = {
      RequestParameterKey.session: "",
      RequestParameterKey.contact: "",
      RequestParameterKey.email: emailAddress,
      RequestParameterKey.fcmToken: FirebasePushNotification.shared.token,
      RequestParameterKey.deviceId: ''
    };
    BaseResponseModel response =
        await AuthenticationRepository.getUserProfileData(param);
    printLog("#EditProfileBloc# User profile response:: ${response.data}");
    if (response.flag == true &&
        response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
      UserDataModel userModel = UserDataModel.fromJson(response.data);
      LoadingWidget.hide();
      if (userModel.flag == true && userModel.data != null) {
        Toast.show(context,
            message: "$emailAddress ${StringHelper.profileEmailAlreadyExists}",
            type: Toast.toastError,
            duration: 5,
            gravity: Toast.toastTop);
      } else {
        Toast.show(context,
            message: "$emailAddress ${StringHelper.profileEmailVerified}",
            type: Toast.toastNormal,
            duration: 3,
            gravity: Toast.toastTop);
        updateUserProfile(
            context, data, globalBLoc, emailAddress, index, "", isFromOVHC);
      }
    } else {
      LoadingWidget.hide();
      Utility.showToastErrorMessage(context, response.statusCode);
    }
  }

  updateUserProfile(
      BuildContext context,
      Object modelData,
      GlobalBloc? globalBLoc,
      String emailAddress,
      int index,
      String mobileNumber,
      bool isFromOVHC) async {
    UserInfoData? userInfo = await globalBLoc!.getUserInfo(context);
    int userID = userInfo.userId ?? 0;
    String name = userInfo.name!.trim();
    String countryCode = userInfo.countryCode!;
    String deviceID = await Utility.getDeviceId();
    String phone = mobileNumber.isNotEmpty ? mobileNumber : userInfo.phone!;
    String email = emailAddress.isNotEmpty ? emailAddress : userInfo.email!;

    Map<String, dynamic> param = {
      RequestParameterKey.userid: userID,
      RequestParameterKey.name: name,
      RequestParameterKey.dateOfBirth: '',
      RequestParameterKey.countrycode: countryCode,
      RequestParameterKey.email: email,
      RequestParameterKey.deviceId: deviceID,
      RequestParameterKey.phone: phone,
      RequestParameterKey.fcmToken: FirebasePushNotification.shared.token,
    };

    printLog("#EditProfileBloc# @UpdateUserProfile@ param :: $param");
    // LoadingWidget.show();
    BaseResponseModel response =
        await AuthenticationRepository.updateUserProfile(param);
    // LoadingWidget.hide();
    if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        response.flag == true) {
      UserDataModel model = UserDataModel.fromJson(response.data);
      globalBLoc.clearUserInfo = UserInfoData(
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null);
      await SharedPreferenceController.setUserData(model.data!);
      Toast.show(context,
          message: StringHelper.profileUpdateSuccessfully,
          type: Toast.toastSuccess);
      await globalBLoc.getUserInfo(context);
      //setLoading = false;

      if (isFromOVHC == true) {
        buyOVHCGmpQuote(context, modelData as DataModel, globalBLoc, index);
      } else {
        buyOSHCGmpQuote(
            context, modelData as OSHCProviderDataModelList, globalBLoc, index);
      }
      Navigator.of(context).pop();
    } else {
      setLoading = false;
      Utility.showToastErrorMessage(context, response.statusCode);
    }
  }

  //to check changes in number for save changes button
  final isPhoneNumberChange = BehaviorSubject<bool>.seeded(false);

  set isPhoneNumberChangeValue(bool value) {
    isPhoneNumberChange.sink.add(value);
  }

  get mobileStream => _phoneStream.stream;
  final _phoneStream = BehaviorSubject<String>();

  Function(String) get onChangePhone => _phoneStream.sink.add;

  String? get getPhoneNumberValue => _phoneStream.valueOrNull;

  bool validationForPhoneNumber(BuildContext context) {
    if (getPhoneNumberValue == null || getPhoneNumberValue == "") {
      Toast.show(context,
          message: StringHelper.loginTitle,
          type: Toast.toastError,
          gravity: Toast.toastTop);
      return false;
    } else if (getPhoneNumberValue != null && getPhoneNumberValue!.length < 8) {
      Toast.show(context,
          message: StringHelper.profileEnterValidPhoneNumber,
          type: Toast.toastError,
          gravity: Toast.toastTop);
      return false;
    }
    return true;
  }

  verifyPhoneNumber(var result, BuildContext context, Object data,
      GlobalBloc? globalBLoc, int index, bool isFromOVHC) {
    if (result != null && result is Map) {
      Map<String, dynamic> param = result as Map<String, dynamic>;
      // ['verified'] is TRUE then mobile no. is unique
      // else mobile no. already register
      if (param['verified'] == true) {
        if (param['mobile'] != null && param['mobile'] != "") {
          //phoneNumberVerified = true;
          isPhoneNumberChangeValue = true;
          //setPhoneNumber = param['mobile'];
          //isUserDataChanged = true;
          Toast.show(context,
              message: StringHelper.authMessagePhoneVerifiedMsg,
              type: Toast.toastSuccess,
              gravity: Toast.toastTop);
          updateUserProfile(context, data, globalBLoc, "", index,
              param['mobile'], isFromOVHC);
        }
        printLog("#EditProfileScreen# type_1:: $result");
      } else if (param['mobile'] != null && param['mobile'] != "") {
        // Phone Number not verified
        //phoneNumberVerified = false;
        isPhoneNumberChangeValue = false;
      }
    } else {
      printLog("#EditProfileScreen# type_2 :: ${result.runtimeType} = $result");
    }
  }
}

class DateDifference {
  int years;
  int months;
  int days;

  DateDifference(this.years, this.months, this.days);

  @override
  String toString() {
    return '$years years, $months months, $days days';
  }
}

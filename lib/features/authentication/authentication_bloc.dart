// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:occusearch/app_style/theme/theme_bloc.dart';
import 'package:occusearch/common_widgets/loading_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/push_notification/push_notification.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/my_occupation_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_occupation_table.dart';
import 'package:occusearch/features/authentication/authentication_repository.dart';
import 'package:occusearch/features/authentication/model/firebase_token_model.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/authentication/otp/otp_parameter_model.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/more_menu/edit_profile/model/email_otp_response_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

@RxBloc()
class AuthenticationBloc extends RxBlocTypeBase {
  // VARIABLE
  final _mobileStream = BehaviorSubject<String>();
  final _countryStream = BehaviorSubject<CountryModel>();

  // OTP
  final _resendOTPStream = BehaviorSubject<bool>.seeded(false);
  final _firebaseOTPVerificationIDStream = BehaviorSubject<String>();

  // CREATE ACCOUNT
  final _fullNameStream = BehaviorSubject<String>();
  final _conditionAgree = BehaviorSubject<bool>();

  //Text Editing Controller
  TextEditingController fullNameTextEditingController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController teOtpDigitOne = TextEditingController();
  final TextEditingController teOtpDigitTwo = TextEditingController();
  final TextEditingController teOtpDigitThree = TextEditingController();
  final TextEditingController teOtpDigitFour = TextEditingController();
  final TextEditingController teOtpDigitFive = TextEditingController();
  final TextEditingController teOtpDigitSix = TextEditingController();

  final _loading = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get getLoadingSubject => _loading.stream;

  bool get isLoading => _loading.value;

  set setLoading(flag) => _loading.sink.add(flag);

  final _loadingMessage = BehaviorSubject<List<String>?>();

  Stream<List<String>?> get getLoadingMessage => _loadingMessage.stream;

  set setLoadingMessage(messages) => _loadingMessage.sink.add(messages);

  // GET
  Stream<String> get getMobileNumber => _mobileStream.stream;

  Stream<bool> get getResendOTP => _resendOTPStream.stream;

  Stream<String> get getFullName => _fullNameStream.stream;

  Stream<bool> get getConditionAgree => _conditionAgree.stream;

  String get getMobileNumberValue => _mobileStream.valueOrNull ?? '';

  set setMobileNumber(no) => _mobileStream.sink.add(no);

  Stream<CountryModel> get getSelectedCountryModel => _countryStream.stream;

  CountryModel? get getSelectedCountryModelValue => _countryStream.valueOrNull;

  // SET
  set setSelectedCountryModel(model) => _countryStream.sink.add(model);

  // OTP
  Function(String) get onChangeMobile => _mobileStream.sink.add;

  Function(String) get onChangeFullname => _fullNameStream.sink.add;

  Function(bool) get onClickConditionCheckbox => _conditionAgree.sink.add;

  // OTP
  Function(bool) get onResendClick => _resendOTPStream.sink.add;

  set setFirebaseVerificationID(id) =>
      _firebaseOTPVerificationIDStream.sink.add(id);

  // [LOGIN BUTTON CLICK] - LOGIN SCREEN
  submitLogin(BuildContext context, String routeName) {
    if (_mobileStream.valueOrNull == null || _mobileStream.valueOrNull == "") {
      Toast.show(context,
          message: StringHelper.otpMobileValidation,
          type: Toast.toastError,
          gravity: Toast.toastTop,
          duration: 2);
    } else if (_mobileStream.valueOrNull != null &&
        (_mobileStream.valueOrNull ?? "").length < 8) {
      Toast.show(context,
          message: StringHelper.otpMobileInvalid,
          type: Toast.toastError,
          gravity: Toast.toastTop,
          duration: 2);
    } else {
      // SEND OTP USING FIREBASE TO USER MOBILE NUMBER
      sendOTP(routeName, context);
    }
  }

  // [VERIFY OTP BUTTON CLICK] - OTP SCREEN
  verifyOTP(
      BuildContext context,
      String mobileNumber,
      String dialCode,
      String shortName,
      String routeName,
      bool isDeleteAccount,
      GlobalBloc? globalBloc,
      {String? userName}) async {
    if (teOtpDigitOne.text != "" &&
        teOtpDigitOne.text.isNotEmpty &&
        teOtpDigitTwo.text != "" &&
        teOtpDigitTwo.text.isNotEmpty &&
        teOtpDigitThree.text != "" &&
        teOtpDigitThree.text.isNotEmpty &&
        teOtpDigitFour.text != "" &&
        teOtpDigitFour.text.isNotEmpty &&
        teOtpDigitFive.text != "" &&
        teOtpDigitFive.text.isNotEmpty &&
        teOtpDigitSix.text != "" &&
        teOtpDigitSix.text.isNotEmpty) {
      // Toast.show(context,
      //     message: "Valid", type: Toast.SUCCESS, gravity: Toast.TOP);
      printLog(
          "#AuthenticationBloc# firebase verification id = ${_firebaseOTPVerificationIDStream.valueOrNull}");
      String strOTP =
          "${teOtpDigitOne.text}${teOtpDigitTwo.text}${teOtpDigitThree.text}${teOtpDigitFour.text}${teOtpDigitFive.text}${teOtpDigitSix.text}";
      //LoadingWidget.show();
      setLoadingMessage = ["Please wait...", "Verifying OTP..."];
      setLoading = true;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _firebaseOTPVerificationIDStream.valueOrNull ?? "",
          smsCode: strOTP);
      try {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          //LoadingWidget.hide();
          if (routeName != RouteName.editProfile) {}
          if (isDeleteAccount) {
            deleteUserAccount(context);
          } else {
            printLog(
                "#Authentication# Verified number is ${FirebaseAuth.instance.currentUser!.phoneNumber}");
            callUserProfileAPI(
                context: context,
                mobile: mobileNumber,
                email: '',
                dialCode: dialCode,
                countryShortName: shortName,
                routeName: routeName,
                userName: userName,
                globalBloc: globalBloc);
          }
        } else {
          //LoadingWidget.hide();
          setLoadingMessage = null;
          setLoading = false;
        }
      } catch (e) {
        //LoadingWidget.hide();
        setLoadingMessage = null;
        setLoading = false;
        if (e.toString().contains('invalid-verification-code')) {
          printLog('#AuthenticationBloc# Please enter correct OTP');
          Toast.show(context,
              message: StringHelper.otpInvalid,
              type: Toast.toastError,
              gravity: Toast.toastTop,
              duration: 2);
        } else if (e.toString().contains('session-expired')) {
          printLog(
              '#AuthenticationBloc# The SMS code has expired. Please re-send the verification code to try again.');
          Toast.show(context,
              message: StringHelper.otpResend,
              type: Toast.toastError,
              gravity: Toast.toastTop,
              duration: 2);
        } else {
          printLog("#AuthenticationBloc# ${e.toString()}");
        }
        printLog(e);
      }
    } else {
      setLoadingMessage = null;
      setLoading = false;
      Toast.show(context,
          message: StringHelper.otpValidation,
          type: Toast.toastError,
          gravity: Toast.toastTop,
          duration: 2);
    }
  }

  // [CREATE ACCOUNT BUTTON CLICK] - CREATE ACCOUNT SCREEN
  createAccount(BuildContext context,
      {required String? mobileNumber,
      required String? emailAddress,
      String? fullName,
      required String? dialCode,
      required String? countryShortcode}) async {
    if (fullName == null ||
        fullName == "" ||
        fullName.trim().toString().isEmpty) {
      Toast.show(context,
          message: StringHelper.createAccountFullNameValidation,
          gravity: Toast.toastTop,
          type: Toast.toastError);
    } else if (fullName.isNotEmpty && fullName.length <= 3) {
      Toast.show(context,
          message: StringHelper.createAccountNameValidation,
          gravity: Toast.toastTop,
          type: Toast.toastError,
          duration: 3);
    } else if (_conditionAgree.valueOrNull == null ||
        _conditionAgree.valueOrNull == false) {
      Toast.show(context,
          message: StringHelper.createAccountTermsCondition,
          gravity: Toast.toastTop,
          type: Toast.toastError);
    } else {
      printLog(
          'Create Account: $fullName, $mobileNumber, $emailAddress, $dialCode, $countryShortcode');
      try {
        String deviceID = await Utility.getDeviceId();
        var param = {
          "name": fullName,
          "countrycode": countryShortcode ?? '',
          "email": emailAddress ?? '',
          "dateOfBirth": "",
          "deviceid": deviceID,
          "phone": mobileNumber ?? '',
          "fcmtoken": FirebasePushNotification.shared.token,
        };

        printLog("#AuthenticationBloc# Create Account API param :: $param");

        // LoadingWidget.show();
        setLoadingMessage = ["Please wait...", "Creating your account..."];
        setLoading = true;
        BaseResponseModel response =
            await AuthenticationRepository.createAccountAPI(param);

        if (response.flag == true &&
            response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
          UserDataModel userModel = UserDataModel.fromJson(response.data);
          if (userModel.flag == true && userModel.data != null) {
            UserInfoData? userInfo = userModel.data;
            bool isFirebaseTokenFound = await getFirebaseCustomToken(
                name: userInfo?.name ?? '',
                phone: userInfo?.phone ?? '',
                email: userInfo?.email ?? '',
                dailCode: userInfo?.phone == null || userInfo?.phone == ''
                    ? ''
                    : dialCode);
            printLog("#AuthenticationBloc# New Account Create Successfully.");
            if (isFirebaseTokenFound) {
              // Store user profile data in sharedPreference
              await SharedPreferenceController.setUserData(userModel.data!);
              await SharedPreferenceController.setIsWelcomeOpen(true);

              if (userInfo != null &&
                  userInfo.phone != null &&
                  userInfo.phone != "") {
                /// SEND WHATSAPP WELCOME MESSAGE
                try {
                  String whatsAppConfig =
                      await FirebaseRemoteConfigController.shared.Data(
                          key: FirebaseRemoteConfigConstants.keyWhatsappConfig);
                  var jsonData = json.decode(whatsAppConfig);

                  String whatsappMobileNo =
                      (dialCode ?? "").replaceAll("+", "");
                  whatsappMobileNo += userInfo.phone ?? "";

                  if (jsonData["need_to_send"] == true &&
                      jsonData["galla_box_url"] != "") {
                    Map<String, dynamic> header = {
                      "apiKey": jsonData["apiKey"] ?? "",
                      "apiSecret": jsonData["apiSecret"] ?? "",
                      "Content-Type": "application/json",
                    };
                    Map<String, dynamic> param = {
                      "channelId": jsonData["channelId"] ?? "",
                      "channelType": jsonData["channelType"] ?? "",
                      "recipient": {
                        "name":
                            Utility.capitaliseName(userInfo.name.toString()),
                        "phone": whatsappMobileNo,
                        "tags": jsonData["tags"] ?? [],
                      },
                      "whatsapp": {
                        "type": jsonData["type"] ?? "",
                        "template": {
                          "templateName": jsonData["templateName"] ?? "",
                          "bodyValues": {
                            "name": Utility.capitaliseName(
                                userInfo.name.toString()),
                          }
                        }
                      }
                    };
                    printLog("whatsapp url   : ${jsonData["galla_box_url"]}");
                    printLog("whatsapp param : $param");
                    BaseResponseModel response = await AuthenticationRepository
                        .sendWhatsAppWelcomeMessage(
                            jsonData["galla_box_url"], header, param);
                    if (response.flag == true) {
                      printLog(
                          "#AuthenticationBloc# send whatsapp welcome message success ${response.data}");
                      FirebaseAnalyticLog.shared.eventLog(
                          title: FBActionEvent.fbWhatsappWelcomeMsg,
                          message:
                              "WhatsApp No. $whatsappMobileNo, RESPONSE: ${response.data}");
                    } else {
                      printLog(
                          "#AuthenticationBloc# send whatsapp welcome message error :: ${response.data}");
                      FirebaseAnalyticLog.shared.eventLog(
                          title: FBActionEvent.fbWhatsappWelcomeMsg,
                          message:
                              "WhatsApp No. $whatsappMobileNo, RESPONSE: ${response.data}");
                    }
                  }
                } catch (e) {
                  setLoadingMessage = null;
                  setLoading = false;
                  printLog(
                      "#AuthenticationBloc# send whatsapp welcome message error :: $e");
                  FirebaseAnalyticLog.shared.eventLog(
                      title: FBActionEvent.fbWhatsappWelcomeMsg,
                      message:
                          "WhatsApp No. ${userInfo.phone}, ERROR-CATCH: ${e.toString()}");
                }
              }
              // LoadingWidget.hide();
              setLoadingMessage = null;
              setLoading = false;
              GoRoutesPage.go(
                  mode: NavigatorMode.remove, moveTo: RouteName.congratulation);
            } else {
              // LoadingWidget.hide();
              setLoadingMessage = null;
              setLoading = false;
              Toast.show(context,
                  message:
                      "${NetworkAPIConstant.somethingWentWrong}, Please try again",
                  gravity: Toast.toastTop,
                  type: Toast.toastError,
                  duration: 2);
            }
          } else {
            // LoadingWidget.hide();
            setLoadingMessage = null;
            setLoading = false;
            Toast.show(context,
                message: response.message ??
                    "${NetworkAPIConstant.somethingWentWrong}, while creating new account",
                gravity: Toast.toastTop,
                type: Toast.toastError,
                duration: 2);
          }
        } else {
          // LoadingWidget.hide();
          setLoadingMessage = null;
          setLoading = false;
          Utility.showToastErrorMessage(context, response.statusCode);
        }
      } catch (e) {
        // LoadingWidget.hide();
        setLoadingMessage = null;
        setLoading = false;
        printLog(
            "#AuthenticationBloc# create new account error :: ${e.toString()}");
      }
    }
  }

  // [SEND OTP ON MOBILE NUMBER]
  sendOTP(String routeName, BuildContext context,
      {bool isDeleteAccount = false}) async {
    final completer = Completer<dynamic>();
    String mobileNumberWithDialCode =
        "${_countryStream.value.dialCode} ${_mobileStream.valueOrNull}";
    // LoadingWidget.show();
    setLoadingMessage = ["Please wait...", "Sending OTP..."];
    setLoading = true;
    printLog("#AuthenticationBloc# OTP sent on $mobileNumberWithDialCode");
    await FirebaseAuth.instance.setSettings(forceRecaptchaFlow: false);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: mobileNumberWithDialCode,
      verificationCompleted: verificationCompleted,
      verificationFailed: (exception) => verificationFailed(exception, context),
      codeSent: (verification, a) async {
        var result = await codeSent(
            verification, routeName, isDeleteAccount, context, a);
        if (result != null) {
          printLog("#sendOTP# Result of OTP screen :: $result");
        } else {
          printLog("#sendOTP# Result of OTP screen :: null");
        }
        completer.complete(result);
      },
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      timeout: const Duration(seconds: 30),
    );
    return completer.future;
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    // LoadingWidget.hide();
    setLoadingMessage = null;
    setLoading = false;
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.uid;
    } else {
      printLog("#AuthenticationBloc# Failed to sign in");
    }
  }

  void verificationFailed(
      FirebaseAuthException exception, BuildContext context) {
    // LoadingWidget.hide();
    setLoadingMessage = null;
    setLoading = false;
    Toast.show(context,
        message: exception.code == "too-many-requests"
            ? exception.message ?? StringHelper.otpMobileInvalid
            : StringHelper.otpMobileInvalid,
        gravity: Toast.toastTop,
        type: Toast.toastError,
        duration: 5);
    printLog(
        "#AuthenticationBloc# Firebase OTP Failed :: ${exception.message}");
  }

  codeSent(String verificationId, String routeName, bool isDeleteAccount,
      BuildContext context,
      [int? a]) async {
    // LoadingWidget.hide();
    setFirebaseVerificationID = verificationId;
    Toast.show(context,
        message: StringHelper.otpSent,
        gravity: Toast.toastTop,
        type: Toast.toastSuccess);
    // IF USER IS IN LOGIN SCREEN THEN AFTER OTP SENT NAVIGATE USER TO OTP SCREEN
    /*Map<String, dynamic> param = {
      "mobile_number": _mobileStream.valueOrNull ?? "",
      "country_model": _countryStream.valueOrNull,
      "firebase_verification_id": verificationId,
      "navigation": routeName,
      "type": "MOBILE",
      "OTP": ""
    };*/
    setLoadingMessage = null;
    setLoading = false;
    Map<String, dynamic> param = OtpParameterModel.parameter(
        mobileNumber: _mobileStream.valueOrNull,
        countryModel: _countryStream.valueOrNull,
        firebaseVerificationID: verificationId,
        routeName: routeName,
        isDeleteAccount: isDeleteAccount,
        type: OTPtype.MOBILE,
        fullName: _fullNameStream.valueOrNull ?? fullNameTextEditingController.text);
    if (RouteName.login == routeName || RouteName.createAccount == routeName) {
      GoRoutesPage.go(
          mode: NavigatorMode.push, moveTo: RouteName.otp, param: param);
      return Future(() => null);
    } else if (RouteName.editProfile == routeName ||
        RouteName.gmpOVHCDetailsScreen == routeName) {
      var result = await context.push<dynamic>(RouteName.root + RouteName.otp,
          extra: param);
      if (result != null) {
        printLog("#codeSent# Result of OTP screen :: $result");
      } else {
        printLog("#codeSent# Result of OTP screen :: null");
      }
      return result;
    }
  }

  void codeAutoRetrievalTimeout(String verificationId) async {
    // LoadingWidget.hide();
    setLoadingMessage = [
      "OTP timeout, Please try again...",
      "Please try again..."
    ];
    setLoading = true;
    await Future.delayed(const Duration(seconds: 5));
    setLoading = false;
    setFirebaseVerificationID = verificationId;
  }

  // GET USER ACCOUNT DETAILS
  Future<bool> callUserProfileAPI(
      {required BuildContext context,
      required String mobile,
      required String email,
      required String? dialCode,
      String? userName,
      required String? countryShortName,
      required String routeName,
      GlobalBloc? globalBloc}) async {
    final completer = Completer<bool>();
    if (false == await NetworkController.isConnected()) {
      Toast.show(context,
          message: StringHelper.internetConnection, type: Toast.toastError);
      completer.complete(false);
      return completer.future;
    }

    //LoadingWidget.show();
    setLoadingMessage = ["Verifying account...", "Please wait..."];
    setLoading = true;

    String deviceID = await Utility.getDeviceId();
    // Check Device ID match with any User account
    Map<String, dynamic> param = {
      RequestParameterKey.session: "",
      RequestParameterKey.contact: mobile,
      RequestParameterKey.email: email,
      RequestParameterKey.fcmToken: FirebasePushNotification.shared.token,
      RequestParameterKey.deviceId:
          mobile.isEmpty && email.isEmpty ? deviceID : ""
    };
    BaseResponseModel response =
        await AuthenticationRepository.getUserProfileData(param);
    printLog("#AuthenticationBloc# User profile response:: ${response.data}");
    if (response.flag == true &&
        response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
      UserDataModel userModel = UserDataModel.fromJson(response.data);
      if (userModel.flag == true && userModel.data != null) {
        // Edit PROFILE VERIFICATION CONDITION,
        // IF USER DATA COMES THEN USER ALREADY EXISTS
        if (routeName == RouteName.editProfile ||
            routeName == RouteName.gmpOVHCDetailsScreen) {
          //LoadingWidget.hide();
          setLoadingMessage = null;
          setLoading = false;
          printLog(
              "#AuthenticationBloc# @$routeName@ NOT VERIFIED $email$mobile, user already exists.");
          if (email.trim().isEmpty) {
            Toast.show(context,
                message: "$mobile ${StringHelper.profileMobileAlreadyExists}",
                type: Toast.toastError,
                duration: 5,
                gravity: Toast.toastTop);
            Map<String, dynamic> param = {
              "mobile": mobile,
              "email": '',
              "verified": false
            };
            context.pop(param);
            completer.complete(true);
            return completer.future;
          } else if (mobile.trim().isEmpty) {
            Toast.show(context,
                message: "$email ${StringHelper.profileEmailAlreadyExists}",
                type: Toast.toastError,
                duration: 5,
                gravity: Toast.toastTop);
            completer.complete(true);
            return completer.future;
          }
        }

        setLoadingMessage = ["Fetching token...", "Please wait..."];
        setLoading = true;

        // TO GET FIREBASE AUTH TOKEN
        UserInfoData? userInfo = userModel.data;
        bool isFirebaseTokenFound = await getFirebaseCustomToken(
          name: userInfo?.name ?? '',
          phone: userInfo?.phone ?? '',
          email: userInfo?.email ?? '',
          dailCode: dialCode, // '+91', '+1' etc.,
        );
        completer.complete(true);
        if (isFirebaseTokenFound) {
          if (userModel.data!.deviceId == deviceID) {
            // STORE USER PROFILE DATA IN [SharedPreference]
            await SharedPreferenceController.setUserData(userModel.data!);
            //LoadingWidget.hide();
            setLoadingMessage = null;
            setLoading = false;
            globalBloc!.isShowDialogSubscription = true;
            GoRoutesPage.go(mode: NavigatorMode.remove, moveTo: RouteName.home);
          } else if (userModel.data!.deviceId == null ||
              userModel.data!.deviceId == "") {
            //LoadingWidget.hide();
            // UPDATE USER DEVICE ID
            bool flag = await callUpdateDeviceIdAPI(context,
                email: userModel.data!.email ?? '',
                phone: userModel.data!.phone ?? '',
                isDialogLoading: false);
            setLoadingMessage = ["Let's Go...", "Let's Go..."];
            setLoading = true;
            await Future.delayed(const Duration(milliseconds: 1500));
            if (flag) {
              // STORE USER PROFILE DATA IN [SharedPreference]
              globalBloc!.isShowDialogSubscription = true;
              await SharedPreferenceController.setUserData(userModel.data!);
              GoRoutesPage.go(
                  mode: NavigatorMode.remove, moveTo: RouteName.home);
            }
          } else {
            // LoadingWidget.hide();
            setLoadingMessage = null;
            setLoading = false;
            // SHOW ALERT DIALOG IF CURRENT DEVICE ID AND USER
            // ACCOUNT DEVICE ID IS MISMATCH
            WidgetHelper.alertDialogWidget(
              context: context,
              title: StringHelper.loginMultipleAccountUserTitle,
              message: StringHelper.loginMultipleAccountUserMessage,
              positiveButtonTitle: "Logout",
              negativeButtonTitle: "Cancel",
              onPositiveButtonClick: () async {
                // FIREBASE EVENT LOG
                FirebaseAnalyticLog.shared.eventTracking(
                    screenName: GoRouterConfig.router.location,
                    actionEvent: FBActionEvent.fbActionUserLimitAlert,
                    sectionName: FBSectionEvent.fbSectionUserLimitLogout,
                    message:
                        "Your account is in use on another device, logout to continue.");
                // UPDATE DEVICE ID BY PASSING CURRENT DEVICE ID
                bool flag = await callUpdateDeviceIdAPI(context,
                    email: userModel.data!.email ?? '',
                    phone: userModel.data!.phone ?? '');
                if (flag) {
                  globalBloc!.isShowDialogSubscription = true;
                  // STORE USER PROFILE DATA IN [SharedPreference]
                  await SharedPreferenceController.setUserData(userModel.data!);
                  GoRoutesPage.go(
                      mode: NavigatorMode.remove, moveTo: RouteName.home);
                }
              },
            );
          }
        } else {
          setLoadingMessage = null;
          setLoading = false;
          // Firebase authentication token not found, user must have to login again
          GoRoutesPage.go(
              mode: NavigatorMode.remove, moveTo: RouteName.onboarding);
        }
      } else {
        completer.complete(false);
        //LoadingWidget.hide();
        setLoadingMessage = null;
        setLoading = false;
        if (routeName == RouteName.editProfile||routeName == RouteName.gmpOVHCDetailsScreen) {
          printLog("#AuthenticationBloc# @$routeName@ VERIFIED $email$mobile");
          Map<String, dynamic> param = {
            "mobile": mobile,
            "email": email,
            "verified": true
          };
          context.pop(param);
          return completer.future;
        }
        // If coming from Create Account flow and user does not exist, auto-create
        // Also auto-create for social login from Login route (email present)
        if (((routeName == RouteName.createAccount) ||
                (routeName == RouteName.login && email.isNotEmpty)) &&
            (mobile.isNotEmpty || email.isNotEmpty)) {
          try {
            String deviceID = await Utility.getDeviceId();
            var createParam = {
              "name": (userName ?? '').trim(),
              "countrycode": countryShortName ?? '',
              "email": email,
              "dateOfBirth": "",
              "deviceid": deviceID,
              "phone": mobile,
              "fcmtoken": FirebasePushNotification.shared.token,
            };
            setLoadingMessage = ["Please wait...", "Creating your account..."];
            setLoading = true;
            BaseResponseModel createResp = await AuthenticationRepository.createAccountAPI(createParam);
            if (createResp.flag == true && createResp.statusCode == NetworkAPIConstant.statusCodeSuccess) {
              UserDataModel userModel = UserDataModel.fromJson(createResp.data);
              if (userModel.flag == true && userModel.data != null) {
                UserInfoData? userInfo = userModel.data;
                bool tokenOk = await getFirebaseCustomToken(
                    name: userInfo?.name ?? (userName ?? ''),
                    phone: userInfo?.phone ?? mobile,
                    email: userInfo?.email ?? email,
                    dailCode: (mobile.isEmpty ? '' : dialCode));
                if (tokenOk) {
                  await SharedPreferenceController.setUserData(userModel.data!);
                  await SharedPreferenceController.setIsWelcomeOpen(true);
                  setLoadingMessage = null;
                  setLoading = false;
                  GoRoutesPage.go(mode: NavigatorMode.remove, moveTo: RouteName.congratulation);
                  return completer.future;
                }
              }
            }
            // Fallback to CreateAccount screen if auto-create failed for any reason
          } catch (e) {
            printLog("#AuthenticationBloc# auto create account error :: ${e.toString()}");
          }
        }
        Map<String, dynamic> param = {
          "mobile_number": mobile,
          "email_address": email,
          "dial_code": dialCode ?? '', // '+91', '+1', '+43'
          "country_shortcode": countryShortName ?? '', // 'IN', 'PK', 'US'
          "full_name": userName
        };
        // If coming from Login with phone (no email), open Create Account in phone_verified mode (only Full Name)
        if (routeName == RouteName.login && email.isEmpty && mobile.isNotEmpty) {
          param["mode"] = "phone_verified";
        }
        GoRoutesPage.go(
            mode: NavigatorMode.remove,
            moveTo: RouteName.createAccount,
            param: param);
      }
    } else {
      //LoadingWidget.hide();
      setLoadingMessage = null;
      setLoading = false;
      Utility.showToastErrorMessage(context, response.statusCode);
      completer.complete(false);
    }
    return completer.future;
  }

  // [GOOGLE SIGN-IN]
  Future<void> googleSignIn(
      BuildContext context, String routeName, GlobalBloc? globalBloc) async {
    String emailAddress = "";
    String userName = "";
    // ONBOARDING OR LOGIN SCREEN USER
    // Logout from firebase authentication account
    await FirebaseAuth.instance.signOut();
    final googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return;
    }
    // LoadingWidget.show();
    final googleAccountAuth = await signInAccount.authentication;
    // To get available accounts in device
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAccountAuth.accessToken,
        idToken: googleAccountAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
    // Selected account details
    emailAddress = FirebaseAuth.instance.currentUser!.email ?? '';
    userName = FirebaseAuth.instance.currentUser!.displayName ?? '';
    printLog("${FirebaseAuth.instance.currentUser!.email}");
    printLog("${FirebaseAuth.instance.currentUser!.displayName}");
    // CHECK USER ACCOUNT DETAILS BASED ON EMAIL ADDRESS
    if (emailAddress.isNotEmpty) {
      // Get Account details by Email address
      await callUserProfileAPI(
          context: context,
          mobile: "",
          email: emailAddress,
          userName: userName,
          dialCode: "",
          countryShortName: "",
          routeName: routeName,
          globalBloc: globalBloc);
    }
    // LoadingWidget.hide();
  }

  // [APPLE SIGN-IN]
  Future<void> appleSignIn(
      BuildContext context, String routeName, GlobalBloc? globalBloc) async {
    String? name, email;

    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    // LoadingWidget.show();
    switch (result.status) {
      case AuthorizationStatus.authorized:
        if ((result.credential?.fullName?.givenName?.length ?? 0) > 0 ||
            (result.credential?.fullName?.familyName?.length ?? 0) > 0) {
          name =
              '${result.credential?.fullName?.givenName} ${result.credential?.fullName?.familyName}';
          email = result.credential?.email;

          await const FlutterSecureStorage()
              .write(key: "userId", value: result.credential?.user);
          await const FlutterSecureStorage()
              .write(key: "fullName", value: name);
          await const FlutterSecureStorage().write(key: "email", value: email);
        }
        name = await const FlutterSecureStorage().read(key: 'fullName');
        email = await const FlutterSecureStorage().read(key: 'email');

        await callUserProfileAPI(
            context: context,
            mobile: "",
            email: email ?? '',
            userName: name ?? '',
            dialCode: "",
            countryShortName: "",
            routeName: routeName,
            globalBloc: globalBloc!);
        //LoadingWidget.hide();
        break;
      case AuthorizationStatus.error:
        //LoadingWidget.hide();
        setLoadingMessage = [];
        setLoading = false;
        break;
      case AuthorizationStatus.cancelled:
        debugPrint('User cancelled');
        //LoadingWidget.hide();
        setLoadingMessage = [];
        setLoading = false;
        break;
      default:
        //LoadingWidget.hide();
        setLoadingMessage = [];
        setLoading = false;
        break;
    }
  }

  // UPDATE DEVICE ID
  Future<bool> callUpdateDeviceIdAPI(BuildContext context,
      {String email = "",
      String phone = "",
      bool isDialogLoading = true}) async {
    if (isDialogLoading) LoadingWidget.show();
    String deviceID = await Utility.getDeviceId();
    Map<String, dynamic> param = {
      RequestParameterKey.email: email,
      RequestParameterKey.deviceId: deviceID,
      RequestParameterKey.phone: email.isEmpty ? phone : "",
    };
    BaseResponseModel response =
        await AuthenticationRepository.updateUserDeviceID(param);
    printLog("update device id response:: ${response.data}");
    if (isDialogLoading) LoadingWidget.hide();
    if (response.flag == true &&
        response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
      return Future.value(true);
    } else {
      Utility.showToastErrorMessage(context, response.statusCode);
      return Future.value(false);
    }
  }

  // Firebase Function: call to get custom token
  Future<bool> getFirebaseCustomToken(
      {required String? email,
      required String? phone,
      required String? dailCode,
      required String? name}) async {
    final completer = Completer<bool>();
    try {
      // Check user auth data found or not
      bool flag = await Utility.checkFirebaseAuthUserFound();
      if (flag) {
        printLog("Firebase auth user already registered.");
        completer.complete(true);
      } else {
        Map<String, String?> param = {
          "uid": "",
          "email": email,
          "phone": (email == null || email == "") ? "$dailCode$phone" : "",
          "name": name
        };
        final params = jsonEncode(param);
        printLog("Firebase Auth Param:: $params");
        BaseResponseModel response =
            await AuthenticationRepository.getFirebaseAuthToken(param);

        if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
            response.flag == true) {
          FirebaseTokenModel firebaseModel =
              FirebaseTokenModel.fromJson(response.data);

          if (firebaseModel.flag != null && firebaseModel.data != null) {
            printLog("Firebase Token response :: ${firebaseModel.data}");
            try {
              final userCredential = await FirebaseAuth.instance
                  .signInWithCustomToken(firebaseModel.data!);
              if (userCredential.user != null) {
                debugPrint("Sign-in successful.");
                completer.complete(true);
              } else {
                completer.complete(false);
              }
            } on FirebaseAuthException catch (e) {
              switch (e.code) {
                case "invalid-custom-token":
                  debugPrint(
                      "The supplied token is not a Firebase custom auth token.");
                  break;
                case "custom-token-mismatch":
                  debugPrint(
                      "The supplied token is for a different Firebase project.");
                  break;
                default:
                  debugPrint("Unknown error.");
              }
              completer.complete(false);
            }
          } else {
            completer.complete(false);
          }
        } else {
          completer.complete(false);
        }
      }
    } catch (e) {
      printLog(e);
      completer.complete(false);
    }
    return completer.future;
  }

  // [DELETE ACCOUNT]
  Future<String?> deleteAccount(BuildContext context,
      {required String? emailAddress,
      required String? phoneNumber,
      required String? countryCode,
      required String routeName,
      bool isResend = false}) async {
    final completer = Completer<String?>();
    if (emailAddress != null && emailAddress != "") {
      // EMAIL ADDRESS
      LoadingWidget.show();
      Map<String, dynamic> param = {"email": emailAddress};
      BaseResponseModel response =
          await AuthenticationRepository.sendOTPEmail(param);
      if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          response.flag == true) {
        LoadingWidget.hide();
        EmailOTPResponse emailResponse =
            EmailOTPResponse.fromJson(response.data);
        if (emailResponse.flag == true && emailResponse.data != "") {
          completer.complete(emailResponse.data);
          Toast.show(context,
              message: emailResponse.message ?? '',
              type: Toast.toastSuccess,
              gravity: Toast.toastTop,
              duration: 3);
          if (!isResend) {
            Map<String, dynamic> param = OtpParameterModel.parameter(
                emailAddress: emailAddress,
                routeName: routeName,
                otp: emailResponse.data,
                isDeleteAccount: true,
                type: OTPtype.EMAIL);
            GoRoutesPage.go(
                mode: NavigatorMode.push, moveTo: RouteName.otp, param: param);
          }
        } else {
          completer.complete(null);
          Toast.show(context,
              message: emailResponse.message ??
                  StringHelper.profileDeleteEmailOTPErrorMsg,
              type: Toast.toastError,
              gravity: Toast.toastTop);
        }
      } else {
        completer.complete(null);
        LoadingWidget.hide();
        Toast.show(context,
            message: StringHelper.profileDeleteEmailOTPErrorMsg,
            type: Toast.toastError,
            gravity: Toast.toastTop);
      }
    } else if (phoneNumber != null && phoneNumber != "") {
      // PHONE NUMBER
      _countryStream.sink.add(CountryModel(dialCode: countryCode));
      _mobileStream.sink.add(phoneNumber);
      sendOTP(RouteName.editProfile, context, isDeleteAccount: true);
      completer.complete(null);
    } else {
      printLog(
          "#AuthenticationBloc# @deleteAccount@ Email address and Mobile number are blank for delete account.");
      completer.complete(null);
    }
    return completer.future;
  }

  Future<void> emailOtpMatchForDeleteAccount(
      BuildContext context, String emailOTP) async {
    if (teOtpDigitOne.text != "" &&
        teOtpDigitOne.text.isNotEmpty &&
        teOtpDigitTwo.text != "" &&
        teOtpDigitTwo.text.isNotEmpty &&
        teOtpDigitThree.text != "" &&
        teOtpDigitThree.text.isNotEmpty &&
        teOtpDigitFour.text != "" &&
        teOtpDigitFour.text.isNotEmpty &&
        teOtpDigitFive.text != "" &&
        teOtpDigitFive.text.isNotEmpty &&
        teOtpDigitSix.text != "" &&
        teOtpDigitSix.text.isNotEmpty) {
      printLog(
          "#AuthenticationBloc# @emailOtpMatchForDeleteAccount@ Email OTP : $emailOTP");

      String strOTP =
          "${teOtpDigitOne.text}${teOtpDigitTwo.text}${teOtpDigitThree.text}${teOtpDigitFour.text}${teOtpDigitFive.text}${teOtpDigitSix.text}";
      if (emailOTP == strOTP) {
        deleteUserAccount(context);
      } else {
        Toast.show(context,
            message: StringHelper.profileDeleteAccountOTPNotMatchError,
            type: Toast.toastError,
            duration: 3,
            gravity: Toast.toastTop);
      }
    } else {
      Toast.show(context,
          message: StringHelper.otpValidation,
          type: Toast.toastError,
          gravity: Toast.toastTop,
          duration: 3);
    }
  }

  // DELETE ACCOUNT API CALLED
  deleteUserAccount(BuildContext context) async {
    UserInfoData info = await SharedPreferenceController.getUserData();
    if (info.leadCode == null || info.leadCode == "") {
      Toast.show(context,
          message: StringHelper.profileDeleteAccountError,
          type: Toast.toastError,
          duration: 3,
          gravity: Toast.toastTop);
      return;
    }
    LoadingWidget.show();
    Map<String, dynamic> param = {
      "leadid": info.userId ?? 0,
      "branchid": info.branchId ?? 0,
      "companyid": info.companyId ?? 0
    };
    printLog(
        "#AuthenticationBloc# @emailOtpMatchForDeleteAccount@ Delete Account Param : $param");
    BaseResponseModel response =
        await AuthenticationRepository.deleteAccount(param);
    printLog(
        "#AuthenticationBloc# @emailOtpMatchForDeleteAccount@ Delete Account Response : ${response.flag}");
    LoadingWidget.hide();
    if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        response.flag == true) {
      Toast.show(context,
          message: StringHelper.profileDeleteAccountSuccessMsg,
          duration: 3,
          gravity: Toast.toastTop);

      //DELETE RECENT OCCUPATION DATA TABLE
      await RecentOccupationTable.deleteTable();
      clearUserDataAndLogout(context, isRequiredToNavigate: true);
    } else {
      Toast.show(context,
          message: StringHelper.profileDeleteAccountError,
          type: Toast.toastError,
          duration: 3,
          gravity: Toast.toastTop);
    }
  }

  /// TODO PENDING TO CLEAR ALL LOGGING USER DETAILS
  clearUserDataAndLogout(BuildContext context,
      {bool isRequiredToNavigate = true}) async {
    ThemeBloc themeBloc = RxBlocProvider.of<ThemeBloc>(context);
    try {
      await SharedPreferenceController.setAdsBannerClickStatus(false);
      await SharedPreferenceController.clearPreference();
      //DELETE TABLE
      await MyOccupationTable.deleteTable();
      await ConfigTable.deleteTable();
      await MyBookmarkTable.deleteTable();

      if (isRequiredToNavigate) {
        // SignOut from firebase
        await FirebaseAuth.instance.signOut();
        GoRoutesPage.go(
            mode: NavigatorMode.remove, moveTo: RouteName.onboarding);
        themeBloc.setTheme(false);
      }
    } catch (e) {
      printLog(e);
    }
  }

  // LOGOUT API
  Future<void> userLogout(
      {required BuildContext context,
      required int userID,
      bool showMessage = true}) async {
    LoadingWidget.show();
    String deviceID = await Utility.getDeviceId();
    Map<String, dynamic> param = {
      "userid": userID,
      "deviceid": deviceID,
    };
    BaseResponseModel response =
        await AuthenticationRepository.userLogout(param);
    if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        response.flag == true) {
      //firebase event tracking
      FirebaseAnalyticLog.shared.eventTracking(
          screenName: RouteName.moreMenu,
          actionEvent: FBActionEvent.fbActionLogout,
          sectionName: FBSectionEvent.fbSectionLogout,
          message: response.message.toString());

      LoadingWidget.hide();
      // CLEAR USER DATA
      if (showMessage) {
        Toast.show(context,
            message: StringHelper.profileULogoutSuccessfully,
            type: Toast.toastSuccess);
      }
      clearUserDataAndLogout(context, isRequiredToNavigate: true);
    } else {
      LoadingWidget.hide();
      Utility.showToastErrorMessage(context, response.statusCode);
    }
  }

  @override
  void dispose() {
    _countryStream.close();
    _mobileStream.close();
    _resendOTPStream.close();
    _conditionAgree.close();
    _fullNameStream.close();
    _firebaseOTPVerificationIDStream.close();

    otpController.clear();
    teOtpDigitOne.clear();
    teOtpDigitTwo.clear();
    teOtpDigitThree.clear();
    teOtpDigitFour.clear();
    teOtpDigitFive.clear();
    teOtpDigitSix.clear();
  }
}

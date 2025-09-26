// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:occusearch/common_widgets/loading_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/push_notification/push_notification.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/authentication_repository.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

@RxBloc()
class EditProfileBloc extends RxBlocTypeBase {
  // VARIABLE
  final _userInfoStream = BehaviorSubject<UserInfoData>();
  final _fullNameStream = BehaviorSubject<String>();
  final _phoneStream = BehaviorSubject<String>();
  final _emailStream = BehaviorSubject<String>();
  final _isPhoneVerifiedStream = BehaviorSubject<bool>.seeded(false);
  final _isEmailVerifiedStream = BehaviorSubject<bool>.seeded(false);
  final _conditionAgree = BehaviorSubject<bool>.seeded(false);

  final _loading = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get getLoadingSubject => _loading.stream;

  bool get isLoading => _loading.value;

  set setLoading(flag) => _loading.sink.add(flag);

  Stream<bool> get getConditionAgree => _conditionAgree.stream;

  bool get getConditionAgreeOrNot => _conditionAgree.valueOrNull ?? false;

  Function(bool) get onClickConditionCheckbox => _conditionAgree.sink.add;

  //to check changes in name for save changes button
  final isNameChange = BehaviorSubject<bool>.seeded(false);

  //to check changes in number for save changes button
  final isPhoneNumberChange = BehaviorSubject<bool>.seeded(false);

  set isPhoneNumberChangeValue(bool value) {
    isPhoneNumberChange.sink.add(value);
  }

  //To  show enable/ disable button(save changes) - to submit profile (to combine  three different stream variable)
  Stream<bool> get isUserDataChanged =>
      Rx.combineLatest3(isNameChange, _emailStream, _phoneStream, (
        isNameChange,
        emailStream,
        phoneStream,
      ) {
        return ((isNameChange == true) ||
                (emailStream.isNotEmpty &&
                    isEmailVerified.value == true &&
                    _userInfoStream.value.email != emailStream) ||
                (phoneStream.isNotEmpty &&
                    isPhoneNumberChange.value == true &&
                    isPhoneVerified.value == true))
            ? true
            : false;
      });

  // [USER INFO]
  get userInfoStream => _userInfoStream.stream;

  set setUserInfo(info) => _userInfoStream.sink.add(info);

  // [FULL NAME]
  get fullNameStream => _fullNameStream.stream;

  Function(String) get onChangeFullName => _fullNameStream.sink.add;

  set setFullName(text) => _fullNameStream.sink.add(text);

  // [MOBILE NUMBER]
  get mobileStream => _phoneStream.stream;

  Function(String) get onChangePhone => _phoneStream.sink.add;

  set setPhoneNumber(text) {
    _phoneStream.sink.add(text);
    if (text.toString().trim().isNotEmpty) {
      _isPhoneVerifiedStream.sink.add(true);
    }
  }

  String? get getPhoneNumberValue => _phoneStream.valueOrNull;

  get isPhoneVerified => _isPhoneVerifiedStream.stream;

  set phoneNumberVerified(flag) => _isPhoneVerifiedStream.sink.add(flag);

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

  verifyPhoneNumber(var result, BuildContext context) {
    if (result != null && result is Map) {
      Map<String, dynamic> param = result as Map<String, dynamic>;
      // ['verified'] is TRUE then mobile no. is unique
      // else mobile no. already register
      if (param['verified'] == true) {
        if (param['mobile'] != null && param['mobile'] != "") {
          phoneNumberVerified = true;
          isPhoneNumberChangeValue = true;
          setPhoneNumber = param['mobile'];
          //isUserDataChanged = true;
          Toast.show(context,
              message: StringHelper.authMessagePhoneVerifiedMsg,
              type: Toast.toastSuccess,
              gravity: Toast.toastTop);
        }
        printLog("#EditProfileScreen# type_1:: $result");
      } else if (param['mobile'] != null && param['mobile'] != "") {
        // Phone Number not verified
        phoneNumberVerified = false;
        isPhoneNumberChangeValue = false;
      }
    } else {
      printLog("#EditProfileScreen# type_2 :: ${result.runtimeType} = $result");
    }
  }

  // [EMAIL ADDRESS]
  get emailStream => _emailStream.stream;

  Function(String) get onChangeEmail => _emailStream.sink.add;

  set setEmailAddress(text) {
    _emailStream.sink.add(text);
    if (text.toString().trim().isNotEmpty) {
      _isEmailVerifiedStream.sink.add(true);
    }
  }

  get isEmailVerified => _isEmailVerifiedStream.stream;

  set emailVerified(flag) => _isEmailVerifiedStream.sink.add(flag);

  String? get getEmailAddressValue => _emailStream.valueOrNull;

  // [GOOGLE ACCOUNT]
  void googleSignIn(BuildContext context) async {
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
      verifyEmailAddressUserAccount(context, emailAddress);
    }
  }

  // [APPLE ACCOUNT]
  Future<void> appleSignIn(BuildContext context) async {
    String? name, email;

    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

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

        break;
      case AuthorizationStatus.error:
        Error? error = result.error as Error?;
        printLog(
            '#EditProfileBloc# @appleSignIn()@ Apple Email Login Error: ${error.toString()}');
        break;
      case AuthorizationStatus.cancelled:
        printLog(
            '#EditProfileBloc# @appleSignIn()@ Apple Email Login: User cancelled');
        break;
    }

    if (email != null && email != "") {
      verifyEmailAddressUserAccount(context, email);
    }
  }

  // TO CHECK USER ACCOUNT FOUND OR NOT BY PASSING EMAIL ADDRESS
  verifyEmailAddressUserAccount(
      BuildContext context, String emailAddress) async {
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
        emailVerified = false;
      } else {
        Toast.show(context,
            message: "$emailAddress ${StringHelper.profileEmailVerified}",
            type: Toast.toastNormal,
            duration: 3,
            gravity: Toast.toastTop);
        emailVerified = true;
        setEmailAddress = emailAddress;
      }
    } else {
      LoadingWidget.hide();
      Utility.showToastErrorMessage(context, response.statusCode);
      emailVerified = false;
    }
  }

  submitUserProfile(BuildContext context, CountryModel? countryModel,
      GlobalBloc globalBloc) async {
    if (_fullNameStream.valueOrNull == null ||
        _fullNameStream.value.toString().trim().isEmpty) {
      Toast.show(context,
          message: StringHelper.profileEnterFullName,
          type: Toast.toastError,
          duration: 3,
          gravity: Toast.toastTop);
      return;
    }
    if (_fullNameStream.valueOrNull != null &&
        _fullNameStream.value.isNotEmpty &&
        _fullNameStream.value.length <= 3) {
      Toast.show(context,
          message: StringHelper.createAccountNameValidation,
          gravity: Toast.toastTop,
          type: Toast.toastError,
          duration: 3);
      return;
    }

    if ((_emailStream.valueOrNull == null ||
            _emailStream.value.toString().trim().isEmpty) &&
        (_phoneStream.valueOrNull == null ||
            _phoneStream.value.toString().trim().isEmpty)) {
      Toast.show(context,
          message: StringHelper.profileEmailPhoneValidation,
          type: Toast.toastError,
          duration: 5,
          gravity: Toast.toastTop);
      return;
    }

    setLoading = true;

    String deviceID = await Utility.getDeviceId();
    int userID = 0;
    String name = '';
    String email = "";
    String phone = "";
    String countryCode = "";
    if (_userInfoStream.valueOrNull != null) {
      UserInfoData userInfo = _userInfoStream.value;

      userID = userInfo.userId ?? 0;
      name = _fullNameStream.value.toString().trim();

      // [EMAIL]
      if (_isEmailVerifiedStream.value == true &&
          _emailStream.valueOrNull != null &&
          _emailStream.valueOrNull != "") {
        email = _emailStream.valueOrNull ?? userInfo.email ?? '';
      } else {
        email = userInfo.email ?? '';
      }
      // [PHONE & COUNTRY CODE]
      if (userInfo.phone != null && userInfo.phone != "") {
        phone = userInfo.phone ?? '';
        countryCode = userInfo.countryCode ?? '';
      } else if (_isPhoneVerifiedStream.value == true &&
          _phoneStream.valueOrNull != null &&
          _phoneStream.valueOrNull != "") {
        phone = _phoneStream.value;
        if (countryModel != null &&
            countryModel.code != null &&
            countryModel.code != "") {
          countryCode = countryModel.code ?? userInfo.countryCode ?? ''; // 'AU'
        } else {
          countryCode = '';
        }
      }
    }

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
      globalBloc.clearUserInfo = UserInfoData(
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
      await globalBloc.getUserInfo(context);
      setLoading = false;
      context.pop(true);
    } else {
      setLoading = false;
      Utility.showToastErrorMessage(context, response.statusCode);
    }
  }

  Future<void> userLogout(
      BuildContext context, AuthenticationBloc authBloc) async {
    UserInfoData userInfo = _userInfoStream.value;
    authBloc.userLogout(
        context: context, userID: userInfo.userId ?? 0, showMessage: false);
  }

  @override
  void dispose() {
    _userInfoStream.close();
    _fullNameStream.close();
    _phoneStream.close();
    _emailStream.close();
    _isPhoneVerifiedStream.close();
    _isEmailVerifiedStream.close();
    isNameChange.close();
    isPhoneNumberChange.close();
  }
}

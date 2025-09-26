// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:occusearch/common_widgets/loading_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/push_notification/push_notification.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/authentication/authentication_repository.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/user_migration/model/update_gmail_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

@RxBloc()
class UserMigrationBloc extends RxBlocTypeBase {
  //VARIABLE
  final _userInfoStream = BehaviorSubject<UserInfoData>();

  // [USER INFO]
  get userInfoStream => _userInfoStream.stream;

  set setUserInfo(UserInfoData userInfoData) =>
      _userInfoStream.sink.add(userInfoData);

  // [APPLE ACCOUNT]
  Future<void> appleSignIn(BuildContext context, GlobalBloc globalBloc) async {
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

        if (email != null && email != "" && email.isNotEmpty) {
          verifyEmailAddressUserAccount(context, email, globalBloc);
        }

        break;
      case AuthorizationStatus.error:
        Error? error = result.error as Error?;
        printLog(
            '#UserMigrationBloc# @appleSignIn()@ Apple Email Login Error: ${error.toString()}');
        break;
      case AuthorizationStatus.cancelled:
        printLog(
            '#UserMigrationBloc# @appleSignIn()@ Apple Email Login: User cancelled');
        break;
    }
  }

  // [GOOGLE ACCOUNT]
  void googleSignIn(BuildContext context, GlobalBloc globalBloc) async {
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
    if (emailAddress != "" && emailAddress.isNotEmpty) {
      verifyEmailAddressUserAccount(context, emailAddress, globalBloc);
    }
  }

  // TO CHECK USER ACCOUNT FOUND OR NOT BY PASSING EMAIL ADDRESS
  verifyEmailAddressUserAccount(
      BuildContext context, String emailAddress, GlobalBloc globalBloc) async {
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
    printLog("#UserMigrationBloc# User profile response:: ${response.data}");
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

        //Update old and new email address
        Map<String, dynamic> param = {
          RequestParameterKey.leadId: _userInfoStream.value.userId,
          RequestParameterKey.companyId: _userInfoStream.value.companyId,
          RequestParameterKey.branchId: _userInfoStream.value.branchId,
          RequestParameterKey.oldEmailAddress: _userInfoStream.value.email,
          RequestParameterKey.newEmailAddress: emailAddress
        };

        printLog("#UserMigrationBloc# @UpdateGmailAddress @param :: $param");
        LoadingWidget.show();
        BaseResponseModel response =
            await AuthenticationRepository.updateGmailAddress(param);
        LoadingWidget.hide();
        if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
            response.flag == true) {
          UpdateGmailAddressModel updateGmailAddressModel =
              UpdateGmailAddressModel.fromJson(response.data);
          if (updateGmailAddressModel.flag == true) {
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
            _userInfoStream.value.email = emailAddress;
            SharedPreferenceController.setUserData(_userInfoStream.value);

            Toast.show(context,
                message: StringHelper.emailUpdateSuccessfully,
                type: Toast.toastSuccess);
            await globalBloc.getUserInfo(context);
            globalBloc.isShowDialogSubscription = true;
            GoRoutesPage.go(mode: NavigatorMode.remove, moveTo: RouteName.home);
          } else {
            Utility.showToastErrorMessage(context, response.statusCode);
          }
        }
      }
    } else {
      LoadingWidget.hide();
      Utility.showToastErrorMessage(context, response.statusCode);
    }
  }

  @override
  void dispose() {
    _userInfoStream.close();
  }
}

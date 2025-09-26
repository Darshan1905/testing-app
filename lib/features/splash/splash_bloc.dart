// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/push_notification/push_notification.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/authentication_repository.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:rx_bloc/rx_bloc.dart';

class SplashBloc extends RxBlocTypeBase {
  Future<void> callUserProfileAPI(BuildContext context) async {
    final AuthenticationBloc authBloc = AuthenticationBloc();
    final GlobalBloc globalBloc = GlobalBloc();

    if (false == await NetworkController.isConnected()) {
      Toast.show(context,
          message: StringHelper.internetConnection,
          type: Toast.toastError,
          gravity: Toast.toastTop,
          duration: 3);
      return;
    }

    String deviceID = await Utility.getDeviceId();
    // Check Device ID match with any User account
    Map<String, dynamic> param = {
      RequestParameterKey.session: "",
      RequestParameterKey.contact: "",
      RequestParameterKey.email: "",
      RequestParameterKey.fcmToken: FirebasePushNotification.shared.token,
      RequestParameterKey.deviceId: deviceID
    };
    BaseResponseModel response =
        await AuthenticationRepository.getUserProfileData(param);
    printLog(response.data);
    if (response.flag == true &&
        response.statusCode == NetworkAPIConstant.statusCodeSuccess) {
      UserDataModel userModel = UserDataModel.fromJson(response.data);
      if (userModel.flag == true && userModel.data != null) {
        UserInfoData? userInfo = userModel.data;
        // TO CONVERT COUNTRY CODE(IN,AU.PK) INTO DIALCODE(+91,+1,+92)
        String dialCode = '';
        if (globalBloc.getCountryListValue.isNotEmpty &&
            userInfo?.countryCode != null &&
            userInfo?.countryCode != "") {
          dialCode = globalBloc.getCountryListValue
                  .firstWhere((countryModel) =>
                      countryModel.code == userInfo?.countryCode)
                  .dialCode ??
              '';
        } else if (userInfo?.countryCode != null &&
            userInfo?.countryCode != "") {
          await globalBloc.getCountryListFromRemoteConfig();
          if (globalBloc.getCountryListValue.isNotEmpty) {
            dialCode = globalBloc.getCountryListValue
                    .firstWhere((countryModel) =>
                        countryModel.code == userInfo?.countryCode)
                    .dialCode ??
                '';
          }
        }
        if ((userModel.data?.phone == null ||
                userModel.data?.phone == "" ||
                userModel.data!.phone!.isEmpty) &&
            userModel.data?.email != null &&
            userModel.data?.email != "" &&
            userModel.data!.email!.isNotEmpty &&
            !userModel.data!.email!.contains("@gmail.com") &&
            !userModel.data!.email!.contains("@privaterelay.appleid.com")) {
          printLog("email:: ${userModel.data?.email}");
          GoRoutesPage.go(
              mode: NavigatorMode.remove,
              moveTo: RouteName.userMigration,
              param: userInfo);
        } else {
          // TO GET FIREBASE AUTH TOKEN
          bool isFirebaseTokenFound = await authBloc.getFirebaseCustomToken(
              name: userInfo?.name ?? '',
              phone: userInfo?.phone ?? '',
              email: userInfo?.email ?? '',
              dailCode: dialCode);
          if (isFirebaseTokenFound) {
            // Store user profile data in sharedPreference
            await SharedPreferenceController.setUserData(userModel.data!);
            bool isSecondTime =
                await SharedPreferenceController.getIsWelcomeOpen();
            if (isSecondTime) {
              GoRoutesPage.go(
                  mode: NavigatorMode.remove, moveTo: RouteName.home);
            } else {
              GoRoutesPage.go(
                  mode: NavigatorMode.remove,
                  moveTo: RouteName.welcomeBack,
                  param: {
                    "user_name": userInfo?.name,
                    "user_id": userInfo?.userId
                  });
            }
          } else {
            await SharedPreferenceController.clearPreference();
            // Not able to get Firebase authentication token
            printLog("#SplashBloc# Firebase authentication token not found");
            GoRoutesPage.go(
                mode: NavigatorMode.remove, moveTo: RouteName.onboarding);
          }
        }
      } else {
        await SharedPreferenceController.clearPreference();
        // Device id not found against any user account
        GoRoutesPage.go(
            mode: NavigatorMode.remove, moveTo: RouteName.onboarding);
      }
    } else {
      Utility.showToastErrorMessage(context, response.statusCode);
    }
  }

  @override
  void dispose() {}
}

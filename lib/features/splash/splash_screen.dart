// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/app_style/text_style/app_text_style_controller.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/splash/splash_bloc.dart';
import 'package:rive/rive.dart';

class SplashScreen extends BaseApp {
  const SplashScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _SplashState();
}

class _SplashState extends BaseState {
  final SplashBloc _splashBloc = SplashBloc();
  GlobalBloc? _globalBloc;

  @override
  init() {
    initData();
  }

  initData() async {
    // FETCH API URL FROM FIREBASE REMOTE CONFIG
    if (FirebaseRemoteConfigController.shared.dynamicEndUrl == null) {
      FirebaseRemoteConfigController.shared.firebaseRemoteConfigObject();
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _globalBloc?.needToShowAdsDialog = true;
        _globalBloc?.checkUserIsFromSplash = true;
        Timer(
          const Duration(seconds: 1),
          () {
            Future.delayed(Duration.zero, () async {
              if (false == await NetworkController.isConnected()) {
                /*Toast.show(context,
                    message: StringHelper.internetConnection,
                    type: Toast.ERROR,
                    duration: 2);
                return;*/

                UserInfoData? info = await _globalBloc?.getUserInfo(context);
                if (info != null &&
                    info.leadCode != null &&
                    info.leadCode != "") {
                  // INTERNET NOT FOUND, BUT USER DATA HAVE THEN REDIRECT TO HOME SCREEN
                  globalBloc!.isShowDialogSubscription = true;
                  GoRoutesPage.go(
                      mode: NavigatorMode.remove, moveTo: RouteName.home);
                } else {
                  // INTERNET NOT FOUND, BUT USER DATA NOT FOUND THEN REDIRECT TO ONBOARDING SCREEN
                  GoRoutesPage.go(
                      mode: NavigatorMode.remove, moveTo: RouteName.onboarding);
                }
              } else {
                await _globalBloc?.getCountryListFromRemoteConfig();
                // await _globalBloc?.getDeviceCountryInfo();
                await _splashBloc.callUserProfileAPI(context);
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    AppTextStyleConfigController.shared.deviceScreenType ??=
        AppTextStyle.getScreenRatio(context);
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => _splashBloc,
      child: Container(
        color: AppColorStyle.background(context),
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              children: [
                const Expanded(
                  child: Center(
                    child: SizedBox(
                      height: 256,
                      width: 256,
                      child: RiveAnimation.asset(RiveAssets.splash),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  IconsSVG.aussizzGrey,
                  width: MediaQuery.of(context).size.width / 2.75,
                ),
                const SizedBox(
                  height: 20.0,
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: (MediaQuery.of(context).size.width / 8)),
              child: SvgPicture.asset(
                IconsSVG.splashBackground,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  onResume() {}
}

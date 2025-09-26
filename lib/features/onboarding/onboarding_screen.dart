// ignore_for_file: overridden_fields
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/google_apple_singin_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:rive/rive.dart';

class OnBoardingScreen extends BaseApp {
  const OnBoardingScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends BaseState {
  final AuthenticationBloc _authBloc = AuthenticationBloc();

  bool clickOnGoogleLogin = true; // Google, false = iOS

  @override
  Widget body(BuildContext context) {
    globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => _authBloc,
      child: Container(
        color: AppColorStyle.background(context),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .width,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: const RiveAnimation.asset(
                RiveAssets.onboardingAnimation,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text.rich(
                      textAlign: TextAlign.start,
                      TextSpan(
                          text: StringHelper.discoverOnBoarding,
                          style: AppTextStyle.titleBold(
                              context, AppColorStyle.text(context)),
                          children: [
                            TextSpan(
                                text: StringHelper.occupationsAndCourses,
                                style: AppTextStyle.titleBold(
                                    context, AppColorStyle.primary(context))),
                            TextSpan(
                                text: StringHelper.forYourInspiration,
                                style: AppTextStyle.titleBold(
                                    context, AppColorStyle.text(context))),
                            /*TextSpan(
                              text: StringHelper.occupation,
                              style: AppTextStyle.headlineBold(
                                  context, AppColorStyle.primary(context))),*/
                          ]),
                    ),
                    Text(StringHelper.inAustralia,
                        style: AppTextStyle.titleLight(
                            context, AppColorStyle.text(context))),
                    SizedBox(height: Platform.isIOS ? 30 : 80),
                    ButtonWidget(
                        title: StringHelper.continueWithPhone,
                        onTap: () {
                          if (_authBloc.isLoading) {
                            return;
                          }
                          GoRoutesPage.go(
                              mode: NavigatorMode.push,
                              moveTo: RouteName.login);
                        },
                        logActionEvent: FBActionEvent.fbActionLoginWithNumber),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Visibility(
                      visible: Platform.isIOS,
                      child: StreamBuilder<bool>(
                        stream: _authBloc.getLoadingSubject,
                        builder: (context, snapshot) {
                          if (snapshot.data == false || !clickOnGoogleLogin) {
                            return GoogleAppleSignInWidget(
                                isGoogle: false,
                                onTap: () {
                                  if (_authBloc.isLoading) {
                                    return;
                                  }
                                  if (NetworkController.isInternetConnected ==
                                      false) {
                                    Toast.show(context,
                                        message:
                                        StringHelper.internetConnection,
                                        type: Toast.toastError,
                                        gravity: Toast.toastTop,
                                        duration: 3);
                                    return;
                                  }
                                  clickOnGoogleLogin = true;
                                  _authBloc.appleSignIn(context,
                                      RouteName.onboarding, globalBloc);
                                });
                          } else {
                            return Material(
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColorStyle.backgroundVariant(
                                        context),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: SizedBox(
                                  height: 45.0,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                    child: StreamBuilder<List<String>?>(
                                      stream: _authBloc.getLoadingMessage,
                                      builder: (context, snapshot) {
                                        List<RotateAnimatedText> messages = [
                                          RotateAnimatedText(
                                            "Please wait...",
                                            textStyle:
                                            AppTextStyle.subTitleMedium(
                                              context,
                                              AppColorStyle.primary(context),
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ];
                                        if (snapshot.hasData &&
                                            snapshot.data != null &&
                                            snapshot.data!.isNotEmpty) {
                                          messages = List.generate(
                                            snapshot.data!.length,
                                                (index) =>
                                                RotateAnimatedText(
                                                  snapshot.data![index],
                                                  textStyle:
                                                  AppTextStyle.subTitleMedium(
                                                    context,
                                                    AppColorStyle.primary(
                                                        context),
                                                  ),
                                                  alignment: Alignment
                                                      .centerLeft,
                                                ),
                                          );
                                        }
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            AnimatedTextKit(
                                              animatedTexts: messages,
                                              repeatForever: true,
                                              pause: const Duration(
                                                  milliseconds: 0),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                                color: AppColorStyle.primary(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: Platform.isIOS ? 20.0 : 0.0,
                    ),
                    StreamBuilder<bool>(
                      stream: _authBloc.getLoadingSubject,
                      builder: (_, snapshot) {
                        if (snapshot.data == false || clickOnGoogleLogin) {
                          return GoogleAppleSignInWidget(
                            isGoogle: true,
                            onTap: () {
                              if (_authBloc.isLoading) {
                                return;
                              }
                              if (NetworkController.isInternetConnected ==
                                  false) {
                                Toast.show(context,
                                    message: StringHelper.internetConnection,
                                    type: Toast.toastError,
                                    duration: 2);
                                return;
                              }
                              clickOnGoogleLogin = false;
                              _authBloc.googleSignIn(
                                  context, RouteName.onboarding, globalBloc);
                            },
                          );
                        } else {
                          return Material(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                  AppColorStyle.backgroundVariant(context),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: SizedBox(
                                height: 45.0,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: StreamBuilder<List<String>?>(
                                    stream: _authBloc.getLoadingMessage,
                                    builder: (context, snapshot) {
                                      List<RotateAnimatedText> messages = [
                                        RotateAnimatedText(
                                          "Please wait...",
                                          textStyle:
                                          AppTextStyle.subTitleMedium(
                                            context,
                                            AppColorStyle.primary(context),
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ];
                                      if (snapshot.hasData &&
                                          snapshot.data != null &&
                                          snapshot.data!.isNotEmpty) {
                                        messages = List.generate(
                                          snapshot.data!.length,
                                              (index) =>
                                              RotateAnimatedText(
                                                snapshot.data![index],
                                                textStyle:
                                                AppTextStyle.subTitleMedium(
                                                  context,
                                                  AppColorStyle.primary(
                                                      context),
                                                ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                        );
                                      }
                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          AnimatedTextKit(
                                            animatedTexts: messages,
                                            repeatForever: true,
                                            pause:
                                            const Duration(milliseconds: 0),
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              color: AppColorStyle.primary(
                                                  context),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: Platform.isIOS ? 40 : 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  init() {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
        await globalBloc?.getDeviceCountryInfo();
        printLog(
            "Device country ${globalBloc?.getDeviceCountryShortcodeValue}");
        printLog("Country length ${globalBloc?.getCountryListValue.length}");
      },
    );
  }

  @override
  onResume() {}
}

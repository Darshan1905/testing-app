import 'dart:io';

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/more_menu/about_and_legal/widget/about_and_legal_widget.dart';
import 'package:occusearch/features/more_menu/more_menu_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAndLegalScreen extends BaseApp {
  const AboutAndLegalScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _AboutAndLegalScreenState();
}

class _AboutAndLegalScreenState extends BaseState {
  final MoreMenuBloc _moreMenuBloc = MoreMenuBloc();
  PackageInfo? packageInfo;

  var year = "2024";

  @override
  init() {
    //package info
    getPackageInfo();
    var date = DateTime.now();
    year = date.year.toString();

    Future.delayed(Duration.zero, () {
      if (Platform.isAndroid) {
        _moreMenuBloc.checkForUpdate(context);
      } else {
        _moreMenuBloc.checkAppUpdate(
            context,
            FirebaseRemoteConfigController.shared.severity,
            FirebaseRemoteConfigController.shared.iosVersion,
            FirebaseRemoteConfigController.shared.description);
      }
    });
  }

  Future<void> getPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider(
        create: (_) => _moreMenuBloc,
        child: Container(
          color: AppColorStyle.background(context),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWellWidget(
                        onTap: () {
                          context.pop();
                        },
                        child: SvgPicture.asset(
                          IconsSVG.arrowBack,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.text(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        StringHelper.aboutAndLegal,
                        style: AppTextStyle.subHeadlineSemiBold(
                            context, AppColorStyle.text(context)),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  color: AppColorStyle.backgroundVariant(context),
                ),
                Column(
                  children: [
                    newUpdateAvailableWidget(context),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.commonPadding,
                            vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            StreamBuilder(
                              stream:
                                  _moreMenuBloc.isNewVersionAvailable.stream,
                              builder: (_, snapshot) {
                                return (snapshot.hasData &&
                                        snapshot.data == true)
                                    ? InkWellWidget(
                                        onTap: () {
                                          if (Platform.isIOS) {
                                            Utility.launchURL(
                                                Constants.appStoreLink);
                                          } else if (Platform.isAndroid) {
                                            Utility.launchURL(
                                                Constants.playStoreLink);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              StringHelper.newUpdateAvailable,
                                              style:
                                                  AppTextStyle.subTitleSemiBold(
                                                      context,
                                                      AppColorStyle.primary(
                                                          context)),
                                            ),
                                            const SizedBox(width: 10),
                                            SvgPicture.asset(
                                              IconsSVG.arrowRight,
                                              colorFilter: ColorFilter.mode(
                                                AppColorStyle.primary(context),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container();
                              },
                            ),
                            const Spacer(),
                            Text(
                              (packageInfo != null)
                                  ? 'V ${packageInfo!.version}'
                                  : "",
                              style: AppTextStyle.detailsSemiBold(
                                  context, AppColorStyle.text(context)),
                            ),
                          ],
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: 10,
                    color: AppColorStyle.backgroundVariant(context),
                  ),
                ),
                const SizedBox(height: 20),
                const Expanded(child: AboutAndLegalWidget()),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Constants.commonPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWellWidget(
                        onTap: () {
                          Utility.launchURL(Constants.aussizzWebsiteUrl);
                        },
                        child: Image.asset(
                          IconsPNG.icAussizzLogo,
                          fit: BoxFit.contain,
                          scale: 1,
                          height: 44,
                          width: 44,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Copyright © $year AUSSIZZGROUP. All Rights Reserved.",
                        style: AppTextStyle.captionRegular(
                            context, AppColorStyle.textDetail(context)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  onResume() {}

  static newUpdateAvailableWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 10),
          child: Center(
            child: Image.asset(
              IconsWEBP.occusearchLogo,
              width: 60.0,
              height: 60.0,
            ),
          ),
        ),
        SvgPicture.asset(
          IconsSVG.occusearchSvgLogo,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            StringHelper.aboutAndLegalDescription,
            textAlign: TextAlign.center,
            style: AppTextStyle.captionRegular(
                context, AppColorStyle.textDetail(context)),
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Divider(
            thickness: 0.5,
            color: AppColorStyle.disableVariant(context),
          ),
        ),
      ],
    );
  }
}

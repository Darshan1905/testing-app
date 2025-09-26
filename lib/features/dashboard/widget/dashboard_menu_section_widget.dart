// ignore_for_file: must_be_immutable

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/dashboard/dashboard_bloc.dart';
import 'package:rive/rive.dart';

class DashboardMenuSectionWidget extends StatelessWidget {
  DashboardMenuSectionWidget({Key? key}) : super(key: key);

  DashboardBloc? dashboardBloc;

  @override
  Widget build(BuildContext context) {
    dashboardBloc ??= RxBlocProvider.of<DashboardBloc>(context);
    double iconHeight = 34;
    double iconWidth = 34;
    final ScreenType deviceSize = AppTextStyle.getScreenRatio(context);
    if (deviceSize == ScreenType.maximum ||
        deviceSize == ScreenType.xHigh ||
        deviceSize == ScreenType.high) {
      iconHeight = 34;
      iconWidth = 34;
    } else if (deviceSize == ScreenType.medium) {
      iconHeight = 30;
      iconWidth = 30;
    } else if (deviceSize == ScreenType.low ||
        deviceSize == ScreenType.minimum) {
      iconHeight = 26;
      iconWidth = 26;
    }
    return Container(
      padding:
          const EdgeInsets.only(top: 30.0, left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // POINT CALCULATOR
              Expanded(
                child: InkWellWidget(
                  onTap: () async {
                    if (dashboardBloc!.dashboardDetailStream.stream.hasValue &&
                        dashboardBloc!
                                .dashboardDetailStream.stream.valueOrNull !=
                            null) {
                      await Future.delayed(const Duration(milliseconds: 500),
                          () async {
                        if (dashboardBloc!.dashboardDetailStream.valueOrNull !=
                                null &&
                            dashboardBloc!
                                .dashboardDetailStream.value.isNotEmpty &&
                            dashboardBloc!.dashboardDetailStream.value[0]
                                    .pointscore !=
                                null &&
                            dashboardBloc!.dashboardDetailStream.value[0]
                                .pointscore!.isNotEmpty) {
                          GoRoutesPage.go(
                              mode: NavigatorMode.push,
                              moveTo: RouteName.pointTestReviewScreen,
                              param: PointTestReviewType.DASHBOARD);
                        } else {
                          GoRoutesPage.go(
                              mode: NavigatorMode.push,
                              moveTo: RouteName.pointTestWelcomeScreen);
                        }
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColorStyle.cyanText(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0))),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                              IconsSVG.dashboardPointCalcSection,
                              fit: BoxFit.fill),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: SizedBox(
                                    height: iconHeight,
                                    width: iconWidth,
                                    child: const RiveAnimation.asset(
                                        RiveAssets.pointCalculator),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  child: Text(
                                    StringHelper.dashboardMenuPointCalcTitle,
                                    style: AppTextStyle.subTitleBold(
                                        context, AppColorStyle.text(context)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  StringHelper.dashboardMenuPointCalcSubTitle,
                                  style: AppTextStyle.detailsRegular(context,
                                      AppColorStyle.cyanVariant1(context)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // VISA FEES
                  InkWellWidget(
                    onTap: () => GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.visaFeesScreen),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColorStyle.purpleText(context),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0))),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                              IconsSVG.dashboardVisaFeesSection,
                              fit: BoxFit.fill),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: iconHeight,
                                  width: iconWidth,
                                  child: const RiveAnimation.asset(
                                      RiveAssets.visaFees),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: Text(
                                    StringHelper.dashboardMenuVisaFeesTitle,
                                    style: AppTextStyle.subTitleBold(
                                        context, AppColorStyle.text(context)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // FUND CALCULATOR
                  InkWellWidget(
                    onTap: () {
                      GoRoutesPage.go(
                          mode: NavigatorMode.push,
                          moveTo: RouteName.fundCalculatorOnBoarding);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColorStyle.tealText(context),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0))),
                      height: 87,
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: SvgPicture.asset(
                                IconsSVG.dashboardFundCalcSection,
                                fit: BoxFit.fill),
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: iconHeight,
                                    width: iconWidth,
                                    child: const RiveAnimation.asset(
                                        RiveAssets.fundCalculator),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      StringHelper.dashboardMenuFundCalcTitle,
                                      style: AppTextStyle.subTitleBold(
                                          context, AppColorStyle.text(context)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          // [VEVO CHECK + BANK ACCOUNT]
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWellWidget(
                  onTap: () async {
                    //database
                    var configTable = await ConfigTable.read(
                        strField: ConfigFields.vevoCheckResponse);

                    // if already data exists in db table
                    if (configTable != null) {
                      GoRoutesPage.go(
                          mode: NavigatorMode.push,
                          moveTo: RouteName.vevoCheckDetail);
                    } else {
                      GoRoutesPage.go(
                          mode: NavigatorMode.push,
                          moveTo: RouteName.vevoCheck);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColorStyle.redText(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0))),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(IconsSVG.dashboardVevoSection,
                              fit: BoxFit.fill),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14, top: 14, bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      StringHelper.dashboardMenuVevoTitle,
                                      style: AppTextStyle.subTitleBold(
                                          context, AppColorStyle.text(context)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: iconHeight + 14,
                                    width: iconWidth + 14,
                                    child: const RiveAnimation.asset(
                                      RiveAssets.vevoCheck,
                                    ),
                                  ),
                                ],
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  StringHelper.dashboardMenuVevoSubTitle,
                                  style: AppTextStyle.detailsRegular(context,
                                      AppColorStyle.redVariant1(context)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: InkWellWidget(
                  onTap: () async {
                    Utility.launchURL(Constants.commonWealthBankUrl);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColorStyle.yellowText(context),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0))),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                              IconsSVG.dashboardCommonWealthBankSection,
                              width: 50.0,
                              fit: BoxFit.fill),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      StringHelper.dashboardMenuBankAccTitle,
                                      style: AppTextStyle.subTitleBold(
                                          context, AppColorStyle.text(context)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: iconHeight,
                                    width: iconWidth,
                                    child: Image.asset(
                                      IconsPNG.commonwealthBank,
                                      width: iconHeight,
                                      height: iconWidth,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  StringHelper.dashboardMenuBankAccSubTitle,
                                  style: AppTextStyle.detailsRegular(context,
                                      AppColorStyle.yellowVariant1(context)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          // [GET MY POLICY]
          InkWellWidget(
            onTap: () async {
              GoRoutesPage.go(
                  mode: NavigatorMode.push, moveTo: RouteName.getMyPolicy);
              /*if (FirebaseRemoteConfigController.shared.dynamicEndUrl != null &&
                  FirebaseRemoteConfigController
                          .shared.dynamicEndUrl!.general !=
                      null &&
                  FirebaseRemoteConfigController
                          .shared.dynamicEndUrl!.general!.getMyPolicy !=
                      "") {
                Utility.launchURL(FirebaseRemoteConfigController
                        .shared.dynamicEndUrl!.general!.getMyPolicy ??
                    Constants.getMyPolicyUrl);
              } else {
                Utility.launchURL(Constants.getMyPolicyUrl);
              }*/
            },
            child: Container(
              decoration: BoxDecoration(
                  color: AppColorStyle.purpleVariant3(context),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(IconsSVG.dashboardPolicySection,
                        fit: BoxFit.fill),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 20.0, right: 35.0, left: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: iconHeight + 14,
                          width: iconWidth + 14,
                          child: SvgPicture.asset(
                            IconsSVG.getMyPolicyLogo,
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringHelper.dashboardHealthInsuranceTitle,
                                style: AppTextStyle.subTitleBold(
                                    context, AppColorStyle.text(context)),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                StringHelper.dashboardHealthInsuranceSubTitle,
                                style: AppTextStyle.captionMedium(
                                    context, ThemeConstant.redTextVariant),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(IconsSVG.icSocialWhatsappV2,
                          fit: BoxFit.fill),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

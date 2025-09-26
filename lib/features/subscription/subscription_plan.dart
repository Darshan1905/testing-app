import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/subscription/subscription_bloc.dart';
import 'package:occusearch/features/subscription/widget/buy_now_widget.dart';

class SubscriptionPlan extends BaseApp {
  const SubscriptionPlan({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => SubscriptionPlanState();
}

class SubscriptionPlanState extends BaseState with SingleTickerProviderStateMixin {
  SubscriptionBloc subscriptionBloc = SubscriptionBloc();
  bool isShowBackIcon = true;
  bool showBasicDetails = false;
  bool showPremiumDetails = false;
  String nextBillingDate = "";

  @override
  init() {
    if (widget.arguments != null) {
      var args = widget.arguments;
      isShowBackIcon = args as bool;
    }

    var date = DateTime.now();
    DateTime nextMonthDate = DateTime(date.year, date.month + 1, date.day);
    // Format this date to MMMM dd, yyyy
    var formatter = DateFormat('MMMM dd, yyyy');

    nextBillingDate = formatter.format(nextMonthDate);

    //To Check firebase promo codes
    subscriptionBloc.getPromoCodeListFromFirebase();

    //For personalized promo code List
    subscriptionBloc.getPromoCodeListDataApi(context);
    subscriptionBloc.initStoreInfo(context, globalBloc!);

    /*all the subscription plan data*/
    subscriptionBloc.getSubscriptionPlanData(context);

    /*current purchased plan data*/
    subscriptionBloc.getMyOccuSubscriptionPlan(context);
  }

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider(
      create: (_) => subscriptionBloc,
      child: Container(
        color: AppColorStyle.background(context),
        child: SafeArea(
          child: Container(
            color: AppColorStyle.backgroundVariant(context),
            child: Column(
              children: [
                Container(
                  color: AppColorStyle.background(context),
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWellWidget(
                        onTap: () {
                          context.pop();
                        },
                        child: isShowBackIcon
                            ? SvgPicture.asset(
                                IconsSVG.arrowBack,
                                colorFilter: ColorFilter.mode(
                                  AppColorStyle.text(context),
                                  BlendMode.srcIn,
                                ),
                              )
                            : Container(),
                      ),
                      SizedBox(width: isShowBackIcon ? 15 : 0.0),
                      Text(
                        StringHelper.subscriptionPlan,
                        style:
                            AppTextStyle.subHeadlineSemiBold(context, AppColorStyle.text(context)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: AppColorStyle.backgroundVariant(context),
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
                            color: AppColorStyle.background(context),
                            child: Stack(
                              fit: StackFit.passthrough,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: AppColorStyle.primary(context),
                                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              StringHelper.currentPlan,
                                              style: AppTextStyle.titleMedium(
                                                  context, AppColorStyle.textWhite(context)),
                                            ),
                                            const SizedBox(height: 10),
                                            StreamBuilder<UserInfoData>(
                                                stream: globalBloc?.getUserInfoStream,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData && snapshot.data != null) {
                                                    UserInfoData data = snapshot.data!;
                                                    return Text.rich(
                                                      TextSpan(
                                                          text: data.subName!.isNotEmpty
                                                              ? data.subName
                                                              : StringHelper.freePlan,
                                                          style: AppTextStyle.titleBold(context,
                                                              AppColorStyle.textWhite(context)),
                                                          children: [
                                                            TextSpan(
                                                                text: "/",
                                                                style: AppTextStyle.subTitleMedium(
                                                                    context,
                                                                    AppColorStyle.textWhite(
                                                                        context))),
                                                            TextSpan(
                                                                text: data.subName!.isNotEmpty
                                                                    ? data.subName ==
                                                                            StringHelper.freePlan
                                                                        ? StringHelper.freePlanDays
                                                                        : data.subName ==
                                                                                StringHelper
                                                                                    .miniPlan
                                                                            ? StringHelper
                                                                                .miniPlanDays
                                                                            : StringHelper
                                                                                .premiumPlanDays
                                                                    : StringHelper.freePlanDays,
                                                                style: AppTextStyle.detailsRegular(
                                                                    context,
                                                                    AppColorStyle.textWhite(
                                                                        context))),
                                                          ]),
                                                    );
                                                  } else {
                                                    return Text(
                                                      "${StringHelper.freePlan} / 0 Days",
                                                      style: AppTextStyle.captionMedium(
                                                          context, AppColorStyle.red(context)),
                                                    );
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 90.0,
                                    alignment: Alignment.center,
                                    height: 30.0,
                                    margin: const EdgeInsets.only(right: 20.0, top: 20.0),
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                                    decoration: BoxDecoration(
                                        color: AppColorStyle.redText(context),
                                        borderRadius: BorderRadius.circular(100.0)),
                                    child: StreamBuilder<UserInfoData>(
                                        stream: globalBloc?.getUserInfoStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData && snapshot.data != null) {
                                            UserInfoData data = snapshot.data!;
                                            return Text(
                                              "${data.subRemainingDays} Days Left",
                                              style: AppTextStyle.captionMedium(
                                                  context, AppColorStyle.red(context)),
                                            );
                                          } else {
                                            return Text(
                                              "0 Days Left",
                                              style: AppTextStyle.captionMedium(
                                                  context, AppColorStyle.red(context)),
                                            );
                                          }
                                        }),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child:
                                      SvgPicture.asset(IconsSVG.bgTopHeaderGray, fit: BoxFit.fill),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder(
                              stream: subscriptionBloc.getProductListStream,
                              builder: (context, snapshot) {
                                return Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                                  color: AppColorStyle.background(context),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SvgPicture.asset(IconsSVG.icBasicPlan,
                                              fit: BoxFit.fill, height: 45, width: 45),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                subscriptionBloc.products.isNotEmpty
                                                    ? subscriptionBloc.products[0].title
                                                        .split("(")
                                                        .first
                                                    : StringHelper.miniPlan,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyle.titleBold(
                                                    context, AppColorStyle.primary(context)),
                                              ),
                                              const SizedBox(height: 10),
                                              Text.rich(
                                                TextSpan(
                                                    text: subscriptionBloc.products.isNotEmpty
                                                        ? subscriptionBloc.products[0].price
                                                        : "AU\$0.00",
                                                    style: AppTextStyle.titleBold(
                                                        context, AppColorStyle.text(context)),
                                                    children: [
                                                      TextSpan(
                                                          text: "/",
                                                          style: AppTextStyle.titleRegular(context,
                                                              AppColorStyle.text(context))),
                                                      TextSpan(
                                                          text: StringHelper.miniPlanDays,
                                                          style: AppTextStyle.subTitleRegular(
                                                              context,
                                                              AppColorStyle.text(context))),
                                                    ]),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                StringHelper.miniPlanType,
                                                style: AppTextStyle.subTitleRegular(
                                                    context, AppColorStyle.text(context)),
                                              ),
                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              InkWellWidget(
                                                onTap: () {
                                                  showBasicDetails = !showBasicDetails;
                                                  setState(() {});
                                                },
                                                child: RotatedBox(
                                                  quarterTurns: showBasicDetails ? 2 : 1,
                                                  child: SvgPicture.asset(IconsSVG.arrowUpIcon,
                                                      height: 24,
                                                      width: 24,
                                                      fit: BoxFit.fill,
                                                      colorFilter: ColorFilter.mode(
                                                        AppColorStyle.text(context),
                                                        BlendMode.srcIn,
                                                      )),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              InkWellWidget(
                                                onTap: () {
                                                  if (NetworkController.isInternetConnected) {
                                                    Utility.writeFacebookEventsLog(
                                                        eventName: Platform.isAndroid
                                                            ? EventsKey.ANDROID_BASIC_PLAN_BUY_NOW
                                                            : EventsKey.IPHONE_BASIC_PLAN_BUY_NOW,
                                                        screenName: EventsKey.SCREEN_SUBSCRIPTION,
                                                        sectionName: EventsKey.SECTION_BASIC_PLAN);
                                                    if (subscriptionBloc.showCheckout) {
                                                      subscriptionBloc
                                                          .promoCodeTextController.text = "";
                                                      subscriptionBloc.isPromoApplied = false;
                                                      ShowBuyDialog.showBuyNowDialog(
                                                          context, subscriptionBloc, 0);
                                                    } else {
                                                      subscriptionBloc
                                                          .buyProduct(subscriptionBloc.products[0]);
                                                    }
                                                  } else {
                                                    Toast.show(context,
                                                        message: StringHelper.internetConnection,
                                                        type: Toast.toastError);
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10.0, vertical: 6.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      color: AppColorStyle.primary(context)),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        StringHelper.buyNow,
                                                        style: AppTextStyle.detailsRegular(context,
                                                            AppColorStyle.textWhite(context)),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      SvgPicture.asset(
                                                        IconsSVG.arrowRight,
                                                        height: 14.0,
                                                        width: 14.0,
                                                        colorFilter: ColorFilter.mode(
                                                          AppColorStyle.textWhite(context),
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Visibility(
                                        visible: showBasicDetails,
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 70),
                                          child: Text(
                                            softWrap: true,
                                            StringHelper.miniPlanDetails,
                                            style: AppTextStyle.detailsRegular(
                                                context, AppColorStyle.text(context)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      StreamBuilder(
                                          stream: subscriptionBloc.getProductListStream,
                                          builder: (context, snapshot) {
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SvgPicture.asset(IconsSVG.icPremiumPlan,
                                                    fit: BoxFit.fill, height: 45, width: 45),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      subscriptionBloc.products.isNotEmpty
                                                          ? subscriptionBloc.products[1].title
                                                              .split("(")
                                                              .first
                                                          : StringHelper.premiumPlan,
                                                      style: AppTextStyle.titleBold(
                                                          context, AppColorStyle.primary(context)),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text.rich(
                                                      TextSpan(
                                                          text: subscriptionBloc.products.isNotEmpty
                                                              ? subscriptionBloc.products[1].price
                                                              : "AU\$0.00",
                                                          style: AppTextStyle.titleBold(
                                                              context, AppColorStyle.text(context)),
                                                          children: [
                                                            TextSpan(
                                                                text: "/",
                                                                style: AppTextStyle.titleRegular(
                                                                    context,
                                                                    AppColorStyle.text(context))),
                                                            TextSpan(
                                                                text: "Month",
                                                                style: AppTextStyle.subTitleRegular(
                                                                    context,
                                                                    AppColorStyle.text(context))),
                                                          ]),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      StringHelper.subscription,
                                                      style: AppTextStyle.subTitleRegular(
                                                          context, AppColorStyle.text(context)),
                                                    ),
                                                    const SizedBox(height: 5),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    InkWellWidget(
                                                      onTap: () {
                                                        showPremiumDetails = !showPremiumDetails;
                                                        setState(() {});
                                                      },
                                                      child: RotatedBox(
                                                        quarterTurns: showPremiumDetails ? 2 : 1,
                                                        child:
                                                            SvgPicture.asset(IconsSVG.arrowUpIcon,
                                                                height: 24,
                                                                width: 24,
                                                                colorFilter: ColorFilter.mode(
                                                                  AppColorStyle.text(context),
                                                                  BlendMode.srcIn,
                                                                )),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    InkWellWidget(
                                                      onTap: () {
                                                        if (NetworkController.isInternetConnected) {
                                                          Utility.writeFacebookEventsLog(
                                                              eventName: Platform.isAndroid
                                                                  ? EventsKey
                                                                      .ANDROID_PREMIUM_PLAN_BUY_NOW
                                                                  : EventsKey
                                                                      .IPHONE_PREMIUM_PLAN_BUY_NOW,
                                                              screenName:
                                                                  EventsKey.SCREEN_SUBSCRIPTION,
                                                              sectionName:
                                                                  EventsKey.SECTION_PREMIUM_PLAN);
                                                          if (subscriptionBloc
                                                              .showPremiumCheckout) {
                                                            subscriptionBloc
                                                                .promoCodeTextController.text = "";
                                                            subscriptionBloc.isPromoApplied = false;
                                                            ShowBuyDialog.showBuyNowDialog(
                                                                context, subscriptionBloc, 1);
                                                          } else {
                                                            subscriptionBloc.buyProduct(
                                                                subscriptionBloc.products[1]);
                                                          }
                                                        } else {
                                                          Toast.show(context,
                                                              message:
                                                                  StringHelper.internetConnection,
                                                              type: Toast.toastError);
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 10.0, vertical: 6.0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(5.0),
                                                            color: AppColorStyle.primary(context)),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              StringHelper.buyNow,
                                                              style: AppTextStyle.detailsRegular(
                                                                  context,
                                                                  AppColorStyle.textWhite(context)),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            SvgPicture.asset(
                                                              IconsSVG.arrowRight,
                                                              height: 14.0,
                                                              width: 14.0,
                                                              colorFilter: ColorFilter.mode(
                                                                AppColorStyle.textWhite(context),
                                                                BlendMode.srcIn,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          }),
                                      Visibility(
                                        visible: showPremiumDetails,
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(left: 15),
                                              child: Text(
                                                softWrap: true,
                                                StringHelper.premiumPlanDetails,
                                                style: AppTextStyle.detailsRegular(
                                                    context, AppColorStyle.text(context)),
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Container(
                                              padding: const EdgeInsets.all(10.0),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: AppColorStyle.yellowVariant(context),
                                                  borderRadius: BorderRadius.circular(5.0)),
                                              child: Text(
                                                softWrap: true,
                                                StringHelper.premiumPlanNote
                                                    .replaceAll("June 25, 2024", nextBillingDate),
                                                style: AppTextStyle.detailsRegular(
                                                    context, AppColorStyle.text(context)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            color: AppColorStyle.background(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  StringHelper.whyJoinPremium,
                                  style:
                                      AppTextStyle.titleBold(context, AppColorStyle.text(context)),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  StringHelper.whyJoinPremiumDesc,
                                  style: AppTextStyle.subTitleRegular(
                                      context, AppColorStyle.text(context)),
                                ),
                                const SizedBox(height: 15),
                                InkWellWidget(
                                  onTap: () {
                                    var param = {
                                      "subscriptionBloc": subscriptionBloc,
                                    };
                                    Utility.writeFacebookEventsLog(
                                        eventName: Platform.isAndroid
                                            ? EventsKey.ANDROID_COMPARE_PLAN
                                            : EventsKey.IPHONE_COMPARE_PLAN,
                                        screenName: EventsKey.SCREEN_SUBSCRIPTION,
                                        sectionName: EventsKey.SECTION_COMPARE_PLAN);
                                    GoRoutesPage.go(
                                        mode: NavigatorMode.push,
                                        moveTo: RouteName.planCompareListScreen,
                                        param: param);
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: AppColorStyle.primary(context)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          StringHelper.comparePlanTitle,
                                          style: AppTextStyle.detailsRegular(
                                              context, AppColorStyle.textWhite(context)),
                                        ),
                                        const SizedBox(width: 10),
                                        SvgPicture.asset(
                                          IconsSVG.arrowRight,
                                          height: 14.0,
                                          width: 14.0,
                                          colorFilter: ColorFilter.mode(
                                            AppColorStyle.textWhite(context),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              children: [
                                Text.rich(
                                  TextSpan(
                                      text: StringHelper.planTermsCondition,
                                      style: AppTextStyle.subTitleRegular(
                                          context, AppColorStyle.text(context)),
                                      children: [
                                        TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Utility.launchURL(Constants.termsURL);
                                              },
                                            text: StringHelper.planTermsConditions,
                                            style: AppTextStyle.subTitleRegular(
                                                context, AppColorStyle.primary(context))),
                                        TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Utility.launchURL(Constants.policyURL);
                                              },
                                            text: StringHelper.planPrivacyPolicy,
                                            style: AppTextStyle.subTitleRegular(
                                                context, AppColorStyle.primary(context))),
                                      ]),
                                ),
                                const SizedBox(height: 15),
                                InkWellWidget(
                                  onTap: () {
                                    GoRoutesPage.go(
                                        mode: NavigatorMode.push,
                                        moveTo: RouteName.transactionHistoryScreen);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 45.0,
                                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: AppColorStyle.primary(context)),
                                    child: Text(
                                      StringHelper.planSetting,
                                      style: AppTextStyle.detailsRegular(
                                          context, AppColorStyle.textWhite(context)),
                                    ),
                                  ),
                                )
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
          ),
        ),
      ),
    );
  }

  @override
  onResume() {}
}

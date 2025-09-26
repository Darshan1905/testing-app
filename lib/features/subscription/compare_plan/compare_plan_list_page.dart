import 'dart:io';

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/firebase/remote_config/model/plan_compare_list_model.dart';
import 'package:occusearch/features/subscription/subscription_bloc.dart';
import 'package:occusearch/features/subscription/widget/buy_now_widget.dart';

class ComparePlanScreen extends BaseApp {
  const ComparePlanScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _ComparePlanScreenState();
}

class _ComparePlanScreenState extends BaseState with SingleTickerProviderStateMixin {
  List<PlanCompareModel> planCompareList = [];
  SubscriptionBloc? subscriptionBloc;

  @override
  init() {
    dynamic argumentValue = widget.arguments;
    if (widget.arguments != null) {
      subscriptionBloc = argumentValue['subscriptionBloc'];
    }

    /* if (widget.arguments != null) {
      var args = subscriptionBloc?.comparePlanListStream.valueOrNull;
      if (args is List<PlanCompareModel>) {
        planCompareList = args;
      }
    }*/
  }

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider(
        create: (_) => subscriptionBloc!,
        child: Container(
          color: AppColorStyle.primary(context),
          child: SafeArea(
            bottom: false,
            child: Container(
              color: AppColorStyle.background(context),
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        expandedHeight: 250,
                        backgroundColor: AppColorStyle.primary(context),
                        floating: true,
                        elevation: 0,
                        toolbarHeight: innerBoxIsScrolled ? 115 : 50,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        title: innerBoxIsScrolled
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: AppColorStyle.textWhite(context),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 3.0),
                                          SvgPicture.asset(IconsSVG.icFreePlan,
                                              height: 24.0, width: 24.0),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            StringHelper.freePlanDays,
                                            style: AppTextStyle.captionMedium(
                                                context, AppColorStyle.primary(context)),
                                          ),
                                          const SizedBox(height: 3.0),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 3.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(StringHelper.freePlan,
                                                    style: AppTextStyle.detailsBold(
                                                        context, AppColorStyle.primary(context))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: AppColorStyle.textWhite(context),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 3.0),
                                          SvgPicture.asset(IconsSVG.icBasicPlan,
                                              height: 24.0, width: 24.0),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            StringHelper.miniPlanDays,
                                            style: AppTextStyle.captionMedium(
                                                context, AppColorStyle.primary(context)),
                                          ),
                                          const SizedBox(height: 3.0),
                                          InkWellWidget(
                                            onTap: () {
                                              if (NetworkController.isInternetConnected) {
                                                Utility.writeFacebookEventsLog(
                                                    eventName: Platform
                                                            .isAndroid
                                                        ? EventsKey
                                                            .ANDROID_BASIC_PLAN_BUY_NOW
                                                        : EventsKey
                                                            .IPHONE_BASIC_PLAN_BUY_NOW,
                                                    screenName: EventsKey
                                                        .SECTION_COMPARE_PLAN,
                                                    sectionName: EventsKey
                                                        .SECTION_BASIC_PLAN);
                                                if (subscriptionBloc
                                                        ?.showCheckout ??
                                                    false) {
                                                  subscriptionBloc
                                                      ?.promoCodeTextController
                                                      .text = "";
                                                  subscriptionBloc
                                                      ?.isPromoApplied = false;
                                                  Utility.writeFacebookEventsLog(
                                                      eventName:
                                                          "Basic_Plan_buy_now",
                                                      screenName:
                                                          'Compare Plan Screen',
                                                      sectionName:
                                                          "Basic Plan");
                                                  ShowBuyDialog
                                                      .showBuyNowDialog(context,
                                                          subscriptionBloc!, 0);
                                                } else {
                                                  subscriptionBloc
                                                      ?.buyProduct(subscriptionBloc!.products[0]);
                                                }
                                              } else {
                                                Toast.show(context,
                                                    message: StringHelper.internetConnection,
                                                    type: Toast.toastError);
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10.0, vertical: 4.0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  color: AppColorStyle.primary(context)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    StringHelper.buyNow,
                                                    style: AppTextStyle.detailsRegular(
                                                        context, AppColorStyle.textWhite(context)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: AlignmentDirectional.topCenter,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: AppColorStyle.textWhite(context),
                                          ),
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 3.0),
                                              SvgPicture.asset(IconsSVG.icPremiumPlan,
                                                  height: 24.0, width: 24.0),
                                              const SizedBox(height: 5.0),
                                              Text(
                                                StringHelper.premiumPlanDays,
                                                style: AppTextStyle.captionMedium(
                                                    context, AppColorStyle.primary(context)),
                                              ),
                                              const SizedBox(height: 3.0),
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
                                                        EventsKey.SECTION_COMPARE_PLAN,
                                                        sectionName:
                                                        EventsKey.SECTION_PREMIUM_PLAN);
                                                    if (subscriptionBloc?.showPremiumCheckout ??
                                                        false) {
                                                      subscriptionBloc
                                                          ?.promoCodeTextController
                                                          .text = "";
                                                      subscriptionBloc
                                                              ?.isPromoApplied =
                                                          false;
                                                      Utility.writeFacebookEventsLog(
                                                          eventName:
                                                              "Premium_Plan_buy_now",
                                                          screenName:
                                                              'Compare Plan Screen',
                                                          sectionName:
                                                              "Premium Plan");
                                                      ShowBuyDialog
                                                          .showBuyNowDialog(
                                                              context,
                                                              subscriptionBloc!,
                                                              1);
                                                    } else {
                                                      subscriptionBloc?.buyProduct(
                                                          subscriptionBloc!.products[1]);
                                                    }
                                                  } else {
                                                    Toast.show(context,
                                                        message: StringHelper.internetConnection,
                                                        type: Toast.toastError);
                                                  }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10.0, vertical: 4.0),
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: -7,
                                          child: Container(
                                            height: 18,
                                            width: 50,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.0),
                                              color: AppColorStyle.lightBlueVariant(context)
                                                  .withOpacity(1.0),
                                            ),
                                            child: Text(
                                              StringHelper.popularTag,
                                              style: AppTextStyle.smallSemiBold(
                                                  context, AppColorStyle.textWhite(context)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  InkWellWidget(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: SvgPicture.asset(
                                        IconsSVG.arrowBack,
                                        colorFilter: ColorFilter.mode(
                                          AppColorStyle.textWhite(context),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    StringHelper.comparePlanTitle,
                                    style: AppTextStyle.titleBold(
                                        context, AppColorStyle.textWhite(context)),
                                  ),
                                ],
                              ),
                        centerTitle: false,
                        flexibleSpace: flexibleTitleBar(
                          context,
                          title: "",
                          isShowAlternateTitle: false,
                          innerBoxIsScrolled: innerBoxIsScrolled,
                          subscriptionBloc: subscriptionBloc,
                        )),
                  ];
                },
                body: StreamBuilder(
                    stream: subscriptionBloc?.comparePlanListStream.stream,
                    builder: (context, snapshot) {
                      (snapshot.data != null && snapshot.data is List<PlanCompareModel>)
                          ? planCompareList = snapshot.data!
                          : planCompareList = [];
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: planCompareList.length,
                          itemBuilder: (context, index) {
                            final coursesData = planCompareList[index];
                            return planListRowView(coursesData, planCompareList, index);
                          });
                    }),
              ),
            ),
          ),
        ));
  }

  @override
  onResume() {}

  Widget planListRowView(
      PlanCompareModel coursesData, List<PlanCompareModel> planCompareList, int index) {
    if (coursesData.freePlan.toString().toLowerCase() == "true" ||
        coursesData.freePlan.toString().toLowerCase() == "false") {
      coursesData.freePlan = coursesData.freePlan.toString().toLowerCase() == "true" ? true : false;
    }
    if (coursesData.basicPlan.toString().toLowerCase() == "true" ||
        coursesData.basicPlan.toString().toLowerCase() == "false") {
      coursesData.basicPlan =
          coursesData.basicPlan.toString().toLowerCase() == "true" ? true : false;
    }
    if (coursesData.premiumPlan.toString().toLowerCase() == "true" ||
        coursesData.premiumPlan == "false") {
      coursesData.premiumPlan =
          coursesData.premiumPlan.toString().toLowerCase() == "true" ? true : false;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            alignment: Alignment.center,
            color: AppColorStyle.blueVariant(context),
            child: Column(
              children: [
                Text(
                  coursesData.featureName!,
                  style: AppTextStyle.detailsSemiBold(context, AppColorStyle.text(context)),
                ),
                SizedBox(
                    height: (coursesData.featureDesc != null &&
                            coursesData.featureDesc.toString().isNotEmpty)
                        ? 10.0
                        : 0),
                (coursesData.featureDesc != null && coursesData.featureDesc.toString().isNotEmpty)
                    ? Text(
                        coursesData.featureDesc ?? "",
                        style:
                            AppTextStyle.captionMedium(context, AppColorStyle.textDetail(context)),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                    child: coursesData.freePlan is bool
                        ? SvgPicture.asset(
                            coursesData.freePlan == true
                                ? IconsSVG.icCheckGreen
                                : IconsSVG.redCrossIcon,
                            height: 20.0,
                            width: 20.0)
                        : Text(
                            coursesData.freePlan!.toString(),
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyle.detailsRegular(context, AppColorStyle.text(context)),
                          )),
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 0.3, color: AppColorStyle.primarySurface1(context)),
                          left: BorderSide(
                              width: 0.3, color: AppColorStyle.primarySurface1(context))),
                    ),
                    child: coursesData.basicPlan is bool
                        ? SvgPicture.asset(
                            coursesData.basicPlan == true
                                ? IconsSVG.icCheckGreen
                                : IconsSVG.redCrossIcon,
                            height: 20.0,
                            width: 20.0)
                        : Text(
                            coursesData.basicPlan!.toString(),
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyle.detailsRegular(context, AppColorStyle.text(context)),
                          )),
              ),
              Expanded(
                  child: coursesData.premiumPlan is bool
                      ? SvgPicture.asset(
                          coursesData.premiumPlan == true
                              ? IconsSVG.icCheckGreen
                              : IconsSVG.redCrossIcon,
                          height: 20.0,
                          width: 20.0,
                        )
                      : Text(
                          coursesData.premiumPlan!.toString(),
                          textAlign: TextAlign.center,
                          style: AppTextStyle.detailsRegular(context, AppColorStyle.text(context)),
                        )),
            ],
          ),
        )
      ],
    );
  }
}

Widget flexibleTitleBar(BuildContext context,
    {String? title,
    bool? isShowAlternateTitle,
    bool? innerBoxIsScrolled,
    SubscriptionBloc? subscriptionBloc}) {
  double maxHeight = 80 + MediaQuery.of(context).padding.top;
  double minHeight = kToolbarHeight + MediaQuery.of(context).padding.top;

  double calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio = (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;
    return expandRatio;
  }

  Widget buildTitle(Animation<double> animation) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        innerBoxIsScrolled == true
            ? const SizedBox()
            : Align(
                alignment: AlignmentDirectional.centerEnd,
                child: SvgPicture.asset(
                  IconsSVG.headerBg,
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.5),
                    BlendMode.srcIn,
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(
              left: Constants.commonPadding, right: Constants.commonPadding, top: 60),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  innerBoxIsScrolled == true
                      ? ""
                      : "Go premium and view all updates with notification and explore multiple occupation",
                  style: AppTextStyle.captionRegular(context, AppColorStyle.textWhite(context)),
                ),
                const SizedBox(height: 15.0),
                Text(
                  innerBoxIsScrolled == true ? "" : StringHelper.experienceTheDifference,
                  style: AppTextStyle.titleBold(context, AppColorStyle.textWhite(context)),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 97,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: AppColorStyle.textWhite(context),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(IconsSVG.icFreePlan, height: 24.0, width: 24.0),
                            const SizedBox(height: 5.0),
                            Text(
                              StringHelper.freePlanDays,
                              style: AppTextStyle.captionMedium(
                                  context, AppColorStyle.primary(context)),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(StringHelper.freePlan,
                                      style: AppTextStyle.detailsBold(
                                          context, AppColorStyle.primary(context))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        height: 97,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: AppColorStyle.textWhite(context),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 3.0),
                            SvgPicture.asset(IconsSVG.icBasicPlan, height: 24.0, width: 24.0),
                            const SizedBox(height: 4.0),
                            Text(
                              StringHelper.miniPlanDays,
                              style: AppTextStyle.captionMedium(
                                  context, AppColorStyle.primary(context)),
                            ),
                            const SizedBox(height: 3.0),
                            InkWellWidget(
                              onTap: () {
                                if (NetworkController.isInternetConnected) {
                                  if (subscriptionBloc?.showCheckout ?? false) {
                                    subscriptionBloc?.promoCodeTextController.text = "";
                                    subscriptionBloc?.isPromoApplied = false;
                                    Utility.writeFacebookEventsLog(
                                        eventName:
                                        "Basic_Plan_buy_now",
                                        screenName:
                                        'Compare Plan Screen',
                                        sectionName:
                                        "Basic Plan");
                                    ShowBuyDialog.showBuyNowDialog(context, subscriptionBloc!, 0);
                                  } else {
                                    subscriptionBloc?.buyProduct(subscriptionBloc.products[0]);
                                  }
                                } else {
                                  Toast.show(context,
                                      message: StringHelper.internetConnection,
                                      type: Toast.toastError);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: AppColorStyle.primary(context)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      StringHelper.buyNow,
                                      style: AppTextStyle.detailsRegular(
                                          context, AppColorStyle.textWhite(context)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Container(
                            height: 97,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: AppColorStyle.textWhite(context),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 3.0),
                                SvgPicture.asset(IconsSVG.icPremiumPlan, height: 24.0, width: 24.0),
                                const SizedBox(height: 4.0),
                                Text(
                                  StringHelper.premiumPlanDays,
                                  style: AppTextStyle.captionMedium(
                                      context, AppColorStyle.primary(context)),
                                ),
                                const SizedBox(height: 3.0),
                                InkWellWidget(
                                  onTap: () {
                                    if (NetworkController.isInternetConnected) {
                                      if (subscriptionBloc?.showPremiumCheckout ?? false) {
                                        subscriptionBloc?.promoCodeTextController.text = "";
                                        subscriptionBloc?.isPromoApplied = false;
                                        Utility.writeFacebookEventsLog(
                                            eventName:
                                            "Premium_Plan_buy_now",
                                            screenName:
                                            'Compare Plan Screen',
                                            sectionName:
                                            "Premium Plan");
                                        ShowBuyDialog.showBuyNowDialog(
                                            context, subscriptionBloc!, 1);
                                      } else {
                                        subscriptionBloc?.buyProduct(subscriptionBloc.products[1]);
                                      }
                                    } else {
                                      Toast.show(context,
                                          message: StringHelper.internetConnection,
                                          type: Toast.toastError);
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: AppColorStyle.primary(context)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          StringHelper.buyNow,
                                          style: AppTextStyle.detailsRegular(
                                              context, AppColorStyle.textWhite(context)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -10,
                            child: Container(
                              height: 20,
                              width: 50,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColorStyle.lightBlueVariant(context).withOpacity(1.0),
                              ),
                              child: Text(
                                StringHelper.popularTag,
                                style: AppTextStyle.smallSemiBold(
                                    context, AppColorStyle.textWhite(context)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final expandRatio = calculateExpandRatio(constraints);
      final animation = AlwaysStoppedAnimation(expandRatio);
      return buildTitle(animation);
    },
  );
}

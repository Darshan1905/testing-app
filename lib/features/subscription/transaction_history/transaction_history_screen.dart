import 'dart:io';

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/subscription/model/my_sub_plan_trans_history_model.dart';
import 'package:occusearch/features/subscription/subscription_bloc.dart';
import 'package:occusearch/features/subscription/transaction_history/transaction_history_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class TransactionHistoryScreen extends BaseApp {
  const TransactionHistoryScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends BaseState {
  SubscriptionBloc subscriptionBloc = SubscriptionBloc();

  @override
  init() {
    subscriptionBloc.initStoreInfo(context, globalBloc!);

    //Api call for current plan and transaction history
    subscriptionBloc.getMyOccuSubTransactionHistory(context);

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColorStyle.background(context),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          InkWellWidget(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              IconsSVG.arrowBack,
                              colorFilter: ColorFilter.mode(
                                AppColorStyle.text(context),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            StringHelper.manageSubscriptionTitle,
                            style: AppTextStyle.titleBold(context, AppColorStyle.text(context)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        color: AppColorStyle.background(context),
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                              padding: const EdgeInsets.all(20.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: AppColorStyle.primary(context),
                              ),
                              child: StreamBuilder(
                                  stream: subscriptionBloc.getMySubscriptionPlanList,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && snapshot.data != null) {
                                      DateTime inputDate =
                                          DateTime.parse(snapshot.data?[0].endDate ?? "");
                                      DateFormat outputFormat = DateFormat('d MMMM yyyy', 'en_US');
                                      String formattedDate = outputFormat.format(inputDate);
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(StringHelper.currentPlan,
                                                  style: AppTextStyle.detailsRegular(
                                                      context, AppColorStyle.textWhite(context))),
                                              snapshot.data?[0].name == StringHelper.freePlan ? InkWellWidget(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      color: AppColorStyle.textWhite(context)),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        StringHelper.buyNow,
                                                        style: AppTextStyle.detailsRegular(
                                                            context, AppColorStyle.primary(context)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ) : const SizedBox(),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Text(snapshot.data?[0].name ?? "",
                                              style: AppTextStyle.subTitleSemiBold(
                                                  context, AppColorStyle.textWhite(context))),
                                          const SizedBox(height: 3.0),
                                          Text(
                                              "Billing Cycle: ${capitalizeFirstLetter(snapshot.data?[0].billingCycle ?? "")}",
                                              style: AppTextStyle.detailsRegular(
                                                  context, AppColorStyle.textWhite(context))),
                                          const SizedBox(height: 15.0),
                                          Text("Subscription Ending: $formattedDate",
                                              style: AppTextStyle.detailsRegular(
                                                  context, AppColorStyle.textWhite(context))),
                                          /*const SizedBox(height: 3.0),
                                          Text("Next Billing: 14 June, 2024",
                                              style: AppTextStyle.detailsRegular(
                                                  context, AppColorStyle.textWhite(context))),*/
                                        ],
                                      );
                                    } else {
                                      return Shimmer.fromColors(
                                        baseColor: AppColorStyle.shimmerPrimary(context),
                                        highlightColor: AppColorStyle.shimmerSecondary(context),
                                        period: const Duration(milliseconds: 1500),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(StringHelper.currentPlan,
                                                  style: AppTextStyle.detailsRegular(
                                                      context, AppColorStyle.textWhite(context))),
                                              const SizedBox(height: 20.0),
                                              Container(
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(context),
                                                  borderRadius:
                                                      const BorderRadius.all(Radius.circular(5)),
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Container(
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(context),
                                                  borderRadius:
                                                      const BorderRadius.all(Radius.circular(5)),
                                                ),
                                              ),
                                              const SizedBox(height: 15.0),
                                              Container(
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.surface(context),
                                                  borderRadius:
                                                      const BorderRadius.all(Radius.circular(5)),
                                                ),
                                              ),
                                              const SizedBox(height: 15.0),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                            const SizedBox(height: 10.0),
                            Divider(
                                color: AppColorStyle.backgroundVariant1(context),
                                height: 20.0,
                                thickness: 10.0),
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(StringHelper.transactionHistory,
                                  style:
                                      AppTextStyle.titleBold(context, AppColorStyle.text(context))),
                            ),
                            /*Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: AppColorStyle.yellowVariant(context),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text(StringHelper.clickHereForViewInvoice,
                                  style: AppTextStyle.detailsRegular(
                                      context, AppColorStyle.text(context))),
                            ),*/
                            StreamBuilder(
                                stream: subscriptionBloc.getSubPlanTransHistoryList,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data!.length > 1) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(left: 25.0),
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: snapshot.data?.length,
                                        itemBuilder: (context, index) {
                                          if (snapshot.data![index].name!.contains("Free")) {
                                            return const SizedBox();
                                          }
                                          return transactionHistoryView(
                                              index, snapshot.data![index]);
                                        });
                                  } else if (snapshot.data != null &&
                                      snapshot.data!.length == 1 &&
                                      subscriptionBloc.loading == false) {
                                    return Center(
                                      child: Container(
                                        height: MediaQuery.of(context).size.height / 2,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 25.0, vertical: 20.0),
                                        padding: const EdgeInsets.all(10.0),
                                        color: AppColorStyle.background(context),
                                        child: Text("No transaction history found",
                                            style: AppTextStyle.detailsRegular(
                                                context, AppColorStyle.text(context))),
                                      ),
                                    );
                                  } else {
                                    return TransactionHistoryListShimmer(5);
                                  }
                                }),
                            const SizedBox(height: 15.0),
                            StreamBuilder(
                                stream: subscriptionBloc.getMySubscriptionPlanList,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && snapshot.data != null) {
                                    if (snapshot.data![0].name!.contains("Premium")) {
                                      return InkWellWidget(
                                        onTap: () {
                                          if (Platform.isIOS) {
                                            Utility.launchURL(
                                                'https://apps.apple.com/account/subscriptions');
                                          } else {
                                            Utility.launchURL(
                                                "https://play.google.com/store/account/subscriptions?package=com.aussizzgroup.occusearch'");
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 90,
                                          color: AppColorStyle.backgroundVariant1(context),
                                          child: Center(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 25.0, vertical: 10.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColorStyle.primary(context)),
                                                  borderRadius: const BorderRadius.all(
                                                      Radius.circular(10.0))),
                                              child: Text(StringHelper.cancelSubscription,
                                                  style: AppTextStyle.detailsMedium(
                                                      context, AppColorStyle.primary(context))),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  String capitalizeFirstLetter(String str) {
    if (str.isEmpty) {
      return str; // Return empty string if input is empty
    }
    return str[0].toUpperCase() + str.substring(1);
  }

  @override
  onResume() {}

  Widget transactionHistoryView(int index, SubPlanTransHistoryData data) {
    DateTime inputDate = DateTime.parse(data.startDate ?? "");
    DateFormat outputFormat = DateFormat('d MMMM yyyy', 'en_US');
    String formattedDate = outputFormat.format(inputDate);

    return StreamBuilder(
        stream: subscriptionBloc.productListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            List<ProductDetails> products = snapshot.data!;
            ProductDetails productDetails = products.firstWhere((element) =>
                element.id == data.productID || element.id == StringHelper.iphonePremiumPlanId);
            return Column(
              children: [
                Divider(color: AppColorStyle.disableVariant(context)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formattedDate,
                              style: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.primary(context))),
                          const SizedBox(height: 5.0),
                          Text('${data.name} (${capitalizeFirstLetter(data.billingCycle ?? "")})',
                              style: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.text(context))),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 25.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: AppColorStyle.primarySurface1(context),
                        ),
                        child: Text('${productDetails.currencySymbol} ${productDetails.rawPrice}',
                            style:
                                AppTextStyle.captionSemiBold(context, AppColorStyle.text(context))),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        });
  }
}

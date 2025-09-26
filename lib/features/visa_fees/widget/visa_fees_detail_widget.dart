// ignore_for_file: must_be_immutable

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/search_field_widget.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/country_with_currency.dart';
import 'package:occusearch/features/visa_fees/model/visa_payment_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';

class VisaFeesCountryCurrencyWidget extends StatelessWidget {
  TextEditingController countrySearchController;
  AnimationController animationController;
  CountryWithCurrencyModel? selectedCurrency;

  VisaFeesCountryCurrencyWidget(
      {Key? key,
      required this.countrySearchController,
      required this.animationController,
      required this.selectedCurrency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visaFeesBloc = RxBlocProvider.of<VisaFeesBloc>(context);

    visaFeesBloc.setDefaultSelectedCountry = selectedCurrency;

    return InkWellWidget(
      onTap: () {
        countrySearchController.removeListener(() {});
        countrySearchController.clear();
        visaFeesBloc.clearCountrySearch();
        VisaFeesCountryBottomSheetWidget.countryBottomSheet(
            context: context,
            searchController: countrySearchController,
            visaFeesBloc: visaFeesBloc,
            animationController: animationController);
      },
      child: StreamWidget(
        stream: visaFeesBloc.selectedCountryStream,
        onBuild: (_, snapshot) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: AppColorStyle.purpleText(context)),
            child: Row(
              children: [
                if (selectedCurrency != null)
                  SvgPicture.network(
                    Constants.cdnFlagURL +
                        (visaFeesBloc.getSelectedCountry?.flag ?? ''),
                    width: 24.0,
                    height: 24.0,
                    fit: BoxFit.fill,
                    placeholderBuilder: (context) => Icon(
                      Icons.flag,
                      size: 24.0,
                      color: AppColorStyle.surfaceVariant(context),
                    ),
                  )
                else
                  const SizedBox(
                    width: 20.0,
                  ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  visaFeesBloc.getSelectedCountry?.symbolCode.toString() ?? "",
                  style: AppTextStyle.detailsSemiBold(
                    context,
                    AppColorStyle.text(context),
                  ),
                ),
                const SizedBox(width: 5.0),
                SvgPicture.asset(
                  IconsSVG.arrowDownIcon,
                  colorFilter: ColorFilter.mode(
                    AppColorStyle.purple(context),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

//Country with currency bottom sheet
class VisaFeesCountryBottomSheetWidget {
  static Future countryBottomSheet(
      {required BuildContext context,
      required VisaFeesBloc visaFeesBloc,
      required AnimationController animationController,
      required TextEditingController searchController}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        useSafeArea: true,
        barrierColor: AppColorStyle.background(context),
        builder: (context) {
          return Container(
            color: AppColorStyle.background(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                visaFeesBloc.countryWithCurrencyList.value.isNotEmpty
                    ? StreamWidget(
                        stream: visaFeesBloc.getCountryListStream,
                        onBuild: (_, snapshot) {
                          List<CountryWithCurrencyModel>? countryModelList =
                              snapshot;
                          return Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  color: AppColorStyle.background(context),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 20.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        StringHelper.currency,
                                        style: AppTextStyle.subHeadlineSemiBold(
                                          context,
                                          AppColorStyle.text(context),
                                        ),
                                      ),
                                      InkWellWidget(
                                        onTap: () {
                                          visaFeesBloc.clearCountrySearch();
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                          IconsSVG.closeIcon,
                                          height: 14,
                                          width: 14,
                                          colorFilter: ColorFilter.mode(
                                            AppColorStyle.text(context),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //SEARCH WIDGET
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 30.0, left: 30.0, bottom: 20.0),
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: SearchTextField(
                                        controller: searchController,
                                        searchHintText:
                                            StringHelper.currencyHintText,
                                        onClear: () {
                                          searchController.text = '';
                                          visaFeesBloc.onCountrySearch("");
                                        },
                                        onTextChanged:
                                            visaFeesBloc.onCountrySearch),
                                  ),
                                ),
                                ((countryModelList?.length ?? 0) > 0)
                                    ? Expanded(
                                        child: ListView.builder(
                                            itemCount: countryModelList?.length,
                                            itemBuilder: (context, index) {
                                              String flag =
                                                  Constants.cdnFlagURL +
                                                      (countryModelList?[index]
                                                              .flag ??
                                                          "");
                                              String symbolCode =
                                                  "1${countryModelList?[index].symbolCode ?? ""}";

                                              double inflationRate =
                                                  (countryModelList![index]
                                                              .rate !=
                                                          0.0)
                                                      ? 1.0 /
                                                          countryModelList[
                                                                  index]
                                                              .rate
                                                      : countryModelList[index]
                                                          .rate;
                                              return (countryModelList[index]
                                                              .rate !=
                                                          0.0 &&
                                                      inflationRate >= 0.0009)
                                                  ? InkWellWidget(
                                                      onTap: () {
                                                        //SET ONCHANGE COUNTRY
                                                        visaFeesBloc
                                                                .setSelectedCountry =
                                                            countryModelList[
                                                                index];

                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 30,
                                                                right: 30,
                                                                bottom: 10),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  child: Row(
                                                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      SvgPicture
                                                                          .network(
                                                                        flag,
                                                                        width:
                                                                            24.0,
                                                                        height:
                                                                            24.0,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        placeholderBuilder:
                                                                            (context) =>
                                                                                Icon(
                                                                          Icons
                                                                              .flag,
                                                                          size:
                                                                              24.0,
                                                                          color:
                                                                              AppColorStyle.surfaceVariant(context),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              20),
                                                                      Flexible(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              "${countryModelList[index].name}",
                                                                              style: AppTextStyle.subTitleRegular(context, AppColorStyle.textDetail(context)),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 5.0,
                                                                            ),
                                                                            Text(symbolCode,
                                                                                style: AppTextStyle.captionSemiBold(context, AppColorStyle.textDetail(context))),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 20),
                                                                  child: Text(
                                                                      "\$${double.parse((inflationRate).toStringAsFixed(3))}",
                                                                      style: AppTextStyle.subTitleSemiBold(
                                                                          context,
                                                                          AppColorStyle.text(
                                                                              context))),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 8.0,
                                                            ),
                                                            countryModelList.length -
                                                                        1 !=
                                                                    index
                                                                ? Divider(
                                                                    color: AppColorStyle
                                                                        .backgroundVariant(
                                                                            context),
                                                                    thickness:
                                                                        0.5)
                                                                : const SizedBox(
                                                                    height:
                                                                        10.0,
                                                                  ),
                                                          ],
                                                        ),
                                                      ))
                                                  : const SizedBox();
                                            }),
                                      )
                                    : Center(
                                        child: Text("Search result not found.",
                                            style: AppTextStyle.titleRegular(
                                                context,
                                                AppColorStyle.text(context)))),
                              ],
                            ),
                          );
                        })
                    : Center(
                        child: Column(
                        children: [
                          const SizedBox(
                            height: 150.0,
                          ),
                          Text(
                            StringHelper.errorOhSnap,
                            style: AppTextStyle.titleRegular(
                                context, AppColorStyle.primary(context)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "The data you are looking\nfor is not found",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.titleRegular(
                                context, AppColorStyle.primary(context)),
                          ),
                        ],
                      )),
              ],
            ),
          );
        });
  }
}

//Payment List Widget
class VisaFeesDetailPaymentWidget extends StatelessWidget {
  AnimationController animationController;

  VisaFeesDetailPaymentWidget({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visaFeesBloc = RxBlocProvider.of<VisaFeesBloc>(context);

    return StreamBuilder(
      stream: visaFeesBloc.getSelectedPaymentData,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final String selectedCardType = snapshot.data!.charges.toString();
          final String selectedIconPath = snapshot.data!.vcIconPath ?? "";

          return InkWellWidget(
            onTap: () {
              VisaPaymentWidget.paymentModelBottomSheet(
                  context: context,
                  paymentMethodList: visaFeesBloc.paymentMethodList.value,
                  visaFeesBloc: visaFeesBloc,
                  animationController: animationController);
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: AppColorStyle.backgroundVariant(context),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(
                children: [
                  Utility.imageCache(selectedIconPath, context),
                  const SizedBox(width: 10),
                  Text(
                    "$selectedCardType %",
                    style: AppTextStyle.titleSemiBold(
                        context, AppColorStyle.text(context)),
                  ),
                  const SizedBox(width: 20),
                  SvgPicture.asset(
                    IconsSVG.arrowDownIcon,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.purple(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

//Payment bottom sheet
class VisaPaymentWidget {
  static Future paymentModelBottomSheet(
      {required BuildContext context,
      required List<PaymentMethodData> paymentMethodList,
      required VisaFeesBloc visaFeesBloc,
      required AnimationController animationController}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        transitionAnimationController: animationController,
        backgroundColor: AppColorStyle.backgroundVariant(context),
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringHelper.paymentMode,
                      style: AppTextStyle.titleSemiBold(
                          context, AppColorStyle.text(context)),
                    ),
                    InkWellWidget(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        IconsSVG.closeIcon,
                        height: 14,
                        width: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Container(
                  color: AppColorStyle.backgroundVariant(context),
                  child: GridView.builder(
                    itemCount: paymentMethodList.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWellWidget(
                        onTap: () {
                          visaFeesBloc
                              .onClickPaymentMethod(paymentMethodList[index]);
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: AppColorStyle.background(context),
                          margin: const EdgeInsets.all(1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: AppColorStyle.backgroundVariant(
                                            context)),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Utility.imageCache(
                                    paymentMethodList[index].vcIconPath ?? '',
                                    context),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "(${paymentMethodList[index].charges ?? 0.0}%)",
                                  style: AppTextStyle.detailsMedium(
                                      context, AppColorStyle.text(context))),
                              StreamBuilder(
                                  stream: visaFeesBloc.getSelectedPaymentData,
                                  builder: (context, snapshot) {
                                    return Container(
                                      height: 5,
                                      width: 30,
                                      margin: const EdgeInsets.only(top: 8.0),
                                      decoration: BoxDecoration(
                                          color: (snapshot.hasData &&
                                                  snapshot.data != null &&
                                                  paymentMethodList[index]
                                                          .cardId ==
                                                      snapshot.data!.cardId)
                                              ? AppColorStyle.purple(context)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    );
                                  })
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

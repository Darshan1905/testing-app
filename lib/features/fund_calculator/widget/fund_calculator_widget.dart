import 'package:occusearch/common_widgets/search_field_widget.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/country_with_currency.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';

class FundCalculatorWidget {
  static Widget questionHeaderWidget({
    required BuildContext context,
    required int max,
    required int current,
    required String? category,
    required String? question,
    required String? notes,
  }) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  category ?? "",
                  style: AppTextStyle.headlineBold(
                    context,
                    AppColorStyle.text(context),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  IconsSVG.fundBulb,
                  width: 20.0,
                  colorFilter: ColorFilter.mode(
                    AppColorStyle.teal(context),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            max != 0
                ? FundCalculatorWidget.fundCalculatorProgressNavigator(
                    context: context, current: current, max: max)
                : const SizedBox(),
            const SizedBox(
              height: 30.0,
            ),
            Text(
              "$question",
              style: AppTextStyle.titleRegular(
                context,
                AppColorStyle.textDetail(context),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ],
    );
  }

  static Widget fundCalculatorProgressNavigator(
      {required BuildContext context, required int current, required int max}) {
    double value = (current + 1) / max;
    return SizedBox(
      height: 5.0,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: ((current).isInfinite || (current).isNaN) &&
                (max.isInfinite || max.isNaN)
            ? Container()
            : TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: value),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) => LinearProgressIndicator(
                  minHeight: 5.0,
                  value: max == 0 ? 0.0 : value,
                  backgroundColor: AppColorStyle.surfaceVariant(context),
                  // valueColor: AlwaysStoppedAnimation<Color>(AppColorStyle.blueOrRed(context)),
                  color: AppColorStyle.teal(context),
                ),
              ),
      ),
    );
  }

  // Footer: Currency, Answer amount & Total fund
  static Widget footerFundTotal({
    required BuildContext context,
    required String questionCategory,
    required selectedQuesAmount,
    CountryWithCurrencyModel? selectedCurrency,
    required bool isRequiredToShowAnswerTotal,
    required Function onCurrencyChange,
    List<FundCalculatorQuestion>? fundQuestions,
    required FundCalculatorBloc fundBloc,
    bool? isFromOtherLiving,
    List<OtherLivingQuestion>? otherQuestions,
    // required Stream<String> stream
  }) {
    dynamic answerTotal = 0.00;
    dynamic otherLivingTotal = 0.00;

    if (fundQuestions != null) {
      for (FundCalculatorQuestion question in fundQuestions) {
        answerTotal += question.answerAmount;
      }
    }

    if (otherQuestions != null) {
      for (OtherLivingQuestion question in otherQuestions) {
        otherLivingTotal += question.answerAmount;
      }
    }

    //SET DEFAULT COUNTRY
    // fundBloc.selectedCurrencyData = selectedCurrency;
    fundBloc.onChangeCountry;
    fundBloc.setSelectedCountry = selectedCurrency;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      color: AppColorStyle.background(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Currency
          InkWellWidget(
            onTap: () {
              // To change currency only in summary page
              if (!isRequiredToShowAnswerTotal) {
                onCurrencyChange();
              }
            },
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                decoration: BoxDecoration(
                    color: AppColorStyle.backgroundVariant(context),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                // padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                child: StreamWidget(
                  stream: fundBloc.selectedCountryStream,
                  onBuild: (_, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            selectedCurrency != null
                                ? SvgPicture.network(
                                    Constants.cdnFlagURL +
                                        (fundBloc.getSelectedCountry?.flag ??
                                            ''),
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.fill,
                                    placeholderBuilder: (context) => Icon(
                                      Icons.flag,
                                      size: 24.0,
                                      color:
                                          AppColorStyle.surfaceVariant(context),
                                    ),
                                  )
                                : const SizedBox(
                                    width: 20.0,
                                  ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              fundBloc.getSelectedCountry?.symbolCode
                                      .toString() ??
                                  "",
                              style: AppTextStyle.captionSemiBold(
                                context,
                                AppColorStyle.text(context),
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(
                          IconsSVG.icDropDown,
                          width: 11.0,
                          height: 11.0,
                        )
                      ],
                    );
                  },
                )),
          ),
          // Answer amount
          if (isRequiredToShowAnswerTotal)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  questionCategory,
                  style: AppTextStyle.detailsRegular(
                    context,
                    AppColorStyle.textDetail(context),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    Utility.getAmountInCurrencyFormat(
                        amount: isFromOtherLiving!
                            ? otherLivingTotal
                            : answerTotal),
                    style: AppTextStyle.subTitleSemiBold(
                      context,
                      AppColorStyle.text(context),
                    ),
                    key: ValueKey<double>(answerTotal),
                  ),
                )
              ],
            ),
          // Total fund
          StreamWidget(
              stream: fundBloc.selectedCountryStream,
              onBuild: (_, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: Text(
                        "Total Cost",
                        style: AppTextStyle.detailsRegular(
                          context,
                          AppColorStyle.textDetail(context),
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        "${fundBloc.getSelectedCountry?.symbolCode} ${Utility.getAmountInCurrencyFormat(amount: isFromOtherLiving! ? otherLivingTotal * fundBloc.getSelectedCountry?.rate : answerTotal * fundBloc.getSelectedCountry?.rate)}",
                        style: AppTextStyle.subTitleSemiBold(
                          context,
                          AppColorStyle.teal(context),
                        ),
                        key: ValueKey<double>(answerTotal),
                      ),
                    )
                  ],
                );
              })
        ],
      ),
    );
  }

  // currency selection bottom sheet
  static currencyListBottomSheetWidget(BuildContext buildContext,
      {required TextEditingController searchController,
      required bool isFromLivingCost,
      required bool needFundTotalAmountInAUD,
      required FundCalculatorBloc fundBloc}) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        // transitionAnimationController: animationController,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(buildContext).size.height -
                MediaQuery.of(buildContext).viewPadding.top),
        context: buildContext,
        builder: (context) {
          //for refresh inside bottom sheet
          return Container(
            color: AppColorStyle.background(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                fundBloc.countryWithCurrencyList.value.isNotEmpty
                    ? StreamWidget(
                        stream: fundBloc.getCountryListStream,
                        onBuild: (_, snapshot) {
                          List<CountryWithCurrencyModel>? countryModelList =
                              snapshot;
                          return Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 20,
                                      bottom: 20),
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
                                            fundBloc.clearSearch();
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: SvgPicture.asset(
                                              IconsSVG.closeIcon,
                                              height: 14,
                                              width: 14,
                                              colorFilter: ColorFilter.mode(
                                                AppColorStyle.text(context),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ))
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
                                          fundBloc.onSearch("");
                                        },
                                        onTextChanged: fundBloc.onSearch),
                                  ),
                                ),
                                if ((countryModelList?.length ?? 0) > 0)
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: countryModelList?.length,
                                        itemBuilder: (context, index) {
                                          String flag = Constants.cdnFlagURL +
                                              (countryModelList?[index].flag ??
                                                  "");
                                          String symbolCode =
                                              "1${countryModelList?[index].symbolCode ?? ""}";
                                          double inflationRate = 1.0 /
                                              countryModelList![index].rate;
                                          return InkWellWidget(
                                            onTap: () {
                                              // //SELECTED COUNTRY UPDATE IN MODEL
                                              fundBloc.selectedCurrencyData =
                                                  countryModelList[index];

                                              //SET ONCHANGE COUNTRY
                                              fundBloc.onChangeCountry;
                                              fundBloc.setSelectedCountry =
                                                  countryModelList[index];

                                              Navigator.pop(context);

                                              /*
                                              fundBloc.setCurrency(
                                                  countryModelList![index],
                                                  isFromLivingCost,
                                                  needFundTotalAmountInAUD);

                                               */
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
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
                                                            SvgPicture.network(
                                                              flag,
                                                              width: 24.0,
                                                              height: 24.0,
                                                              fit: BoxFit.fill,
                                                              placeholderBuilder:
                                                                  (context) =>
                                                                      Icon(
                                                                Icons.flag,
                                                                size: 24.0,
                                                                color: AppColorStyle
                                                                    .surfaceVariant(
                                                                        context),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                            Flexible(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    "${countryModelList[index].name}",
                                                                    style: AppTextStyle.subTitleRegular(
                                                                        context,
                                                                        AppColorStyle.textDetail(
                                                                            context)),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 3.0,
                                                                  ),
                                                                  Text(
                                                                      symbolCode,
                                                                      style: AppTextStyle.captionSemiBold(
                                                                          context,
                                                                          AppColorStyle.textDetail(
                                                                              context))),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: Text(
                                                            "\$${double.parse((inflationRate).toStringAsFixed(3))}",
                                                            style: AppTextStyle
                                                                .subTitleSemiBold(
                                                                    context,
                                                                    AppColorStyle
                                                                        .text(
                                                                            context))),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  countryModelList.length - 1 !=
                                                          index
                                                      ? Divider(
                                                          color: AppColorStyle
                                                              .surfaceVariant(
                                                                  context),
                                                          thickness: 0.5)
                                                      : const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                else
                                  Center(
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

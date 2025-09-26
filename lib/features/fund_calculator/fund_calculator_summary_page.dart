import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/country_with_currency.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_calculator_shimmer.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_calculator_widget.dart';
import 'package:occusearch/features/fund_calculator/widget/summary_chart_widget.dart';

import 'model/summary_chart_model.dart';

class FundCalculatorSummaryPage extends BaseApp {
  const FundCalculatorSummaryPage({super.key, super.arguments})
      : super.builder();

  @override
  BaseState createState() => _FundCalculatorSummaryPageState();
}

class _FundCalculatorSummaryPageState extends BaseState {
  FundCalculatorBloc? _fundCalculatorBloc;

  // final FundCalculatorBloc _fundCalculatorBloc = FundCalculatorBloc();

  final TextEditingController _countrySearchController =
      TextEditingController();

  List<FundCalculatorQuestion>? fundQuestions;

  @override
  init() async {
    if (widget.arguments != null) {
      dynamic argumentValue = widget.arguments;
      if (argumentValue != null) {
        if (argumentValue['fundAnswerSavedBloc'] != null) {
          _fundCalculatorBloc = argumentValue['fundAnswerSavedBloc'];
        } else if (argumentValue['_fundCalculatorBloc'] != null) {
          _fundCalculatorBloc = argumentValue['_fundCalculatorBloc'];
        } else {
          _fundCalculatorBloc = FundCalculatorBloc();
        }
        fundQuestions =
            argumentValue['fundQuestions'] ?? FundCalculatorQuestion();
      }
    }

    Future.delayed(Duration.zero, () async {
      await calculateSummaryData();
      await _fundCalculatorBloc?.setupRemoteConfigForCountryList();
      _fundCalculatorBloc?.setSearchFieldController = _countrySearchController;
      await _fundCalculatorBloc?.calculateFundTotal(
          needFundTotalAmountInAUD: true); // to calculate total fund amount
    });
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return WillPopScopeWidget(
      onWillPop: () async {
        WidgetHelper.alertDialogWidget(
          context: context,
          title: StringHelper.fundCalc,
          buttonColor: AppColorStyle.teal(context),
          message: StringHelper.fundConfirmDialogMessage,
          positiveButtonTitle: StringHelper.yesQuit,
          negativeButtonTitle: StringHelper.cancel,
          onPositiveButtonClick: () {
            GoRoutesPage.go(mode: NavigatorMode.remove, moveTo: RouteName.home);
          },
        );
        return false;
      },
      child: Container(
        color: AppColorStyle.background(context),
        child: Column(
          children: [
            Container(
              height: 34,
              color: AppColorStyle.teal(context),
            ),
            StreamBuilder<List<SummaryChartData>>(
              stream: _fundCalculatorBloc?.getSummaryChartList,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  List<SummaryChartData> summaryList = snapshot.data ?? [];
                  return SummaryChartWidget(
                    isFromOtherLiving: false,
                    summaryChartData: summaryList,
                    fundAnswerSavedBloc: _fundCalculatorBloc,
                    fundQuestions: fundQuestions,
                  );
                } else {
                  return const SummaryChartHeaderShimmer();
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: AppColorStyle.background(context),
                  child: StreamBuilder(
                      stream: _fundCalculatorBloc?.selectedCountryStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(StringHelper.summary,
                                      style: AppTextStyle.titleBold(
                                        context,
                                        AppColorStyle.text(context),
                                      )),
                                ),
                                // Question: 1
                                InkWellWidget(
                                  onTap: () {
                                    //REDIRECTION QUE-1 : COURSE FEE
                                    Map<String, dynamic> param = {
                                      "index": 0,
                                      "questionModel": fundQuestions,
                                    };
                                    context.pop(param);

                                    ///TODO: NAVIGATION TO PARTICULAR CATEGORY PENDING WHEN WE COME FROM OTHER LIVING SUMMARY PAGE
                                    // var fundSummaryPageParam = {
                                    //   "index": 0,
                                    //   "_fundCalculatorBloc":
                                    //       _fundCalculatorBloc,
                                    //   "fundQuestions": fundQuestions
                                    // };
                                  },
                                  child: summaryFundCalcAnswer(
                                    context: context,
                                    fundBloc: _fundCalculatorBloc!,
                                    quesID: 0,
                                  ),
                                ),
                                Divider(
                                    color:
                                        AppColorStyle.surfaceVariant(context),
                                    thickness: 0.5),
                                // Question: 2, 3, 4
                                InkWellWidget(
                                  onTap: () {
                                    //REDIRECTION QUE-2 : LIVING COST
                                    Map<String, dynamic> param = {
                                      "index": 1,
                                      "questionModel": fundQuestions,
                                    };
                                    context.pop(param);
                                  },
                                  child: summaryFundCalcAnswer(
                                    context: context,
                                    fundBloc: _fundCalculatorBloc!,
                                    quesID: 1,
                                  ),
                                ),
                                Divider(
                                    color:
                                        AppColorStyle.surfaceVariant(context),
                                    thickness: 0.5),
                                // Question: 5
                                InkWellWidget(
                                  onTap: () {
                                    //REDIRECTION QUE-4 : SCHOOLING COST
                                    Map<String, dynamic> param = {
                                      "index": 3,
                                      "questionModel": fundQuestions,
                                    };
                                    context.pop(param);
                                  },
                                  child: summaryFundCalcAnswer(
                                      context: context,
                                      fundBloc: _fundCalculatorBloc!,
                                      quesID: 4),
                                ),
                                Divider(
                                    color:
                                        AppColorStyle.surfaceVariant(context),
                                    thickness: 0.5),
                                // Question: 6
                                InkWellWidget(
                                  onTap: () {
                                    //REDIRECTION QUE-5 : TRAVELLING COST
                                    Map<String, dynamic> param = {
                                      "index": 5,
                                      "questionModel": fundQuestions,
                                    };
                                    context.pop(param);
                                  },
                                  child: summaryFundCalcAnswer(
                                    context: context,
                                    fundBloc: _fundCalculatorBloc!,
                                    quesID: 5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SummaryChartShimmer();
                        }
                      }),
                ),
              ),
            ),
            footerSection(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> calculateSummaryData() async {
    if (fundQuestions == null) {
      return;
    }

    List<SummaryChartData> summaryChartData = [];

    double totalCostAmount = 0.0;
    for (var element in fundQuestions!) {
      totalCostAmount += element.answerAmount;
    }
    double livingCostAmount = 0.0;
    String categoryName = "";
    int categoryPercentage = 0;

    for (FundCalculatorQuestion questionData in fundQuestions!) {
      // TO MERGE QUESTION [2,3,4] ANSWER AMOUNT FOR SINGLE LIVING COST CATEGORY
      if (questionData.questionId == 2 ||
          questionData.questionId == 3 ||
          questionData.questionId == 4) {
        if (questionData.questionId == 2) {
          categoryName = questionData.category ?? '';
          livingCostAmount = (questionData.amount ?? 0).toDouble();
        } else if (questionData.questionId == 3) {
          livingCostAmount += questionData.categoryWiseTotalAmt;
        } else if (questionData.questionId == 4) {
          livingCostAmount += questionData.categoryWiseTotalAmt;
          categoryPercentage =
              ((livingCostAmount * 100) / totalCostAmount).round();
          summaryChartData
              .add(SummaryChartData(categoryName, categoryPercentage));
        }
      } else {
        categoryName = questionData.category ?? '';
        categoryPercentage =
            ((questionData.categoryWiseTotalAmt * 100) / totalCostAmount)
                .round();
        summaryChartData
            .add(SummaryChartData(categoryName, categoryPercentage));
      }
    }
    _fundCalculatorBloc?.setSummaryChartList = summaryChartData;
  }

  Widget summaryFundCalcAnswer(
      {required BuildContext context,
      required FundCalculatorBloc fundBloc,
      required int quesID}) {
    //FROM SUMMARYFUNDCALCANSWER
    var qData = fundQuestions?[quesID];

    //FIND QUESTION BASED ON INDEX
    var fundQ1Data = fundQuestions?[1];
    var fundQ2Data = fundQuestions?[2];
    var fundQ3Data = fundQuestions?[3];
    var fundQ4Data = fundQuestions?[4];
    var fundQ5Data = fundQuestions?[5];

    //FOR QUESTION LIVING COST SPOUSE ADD OR NOT
    bool spouse = fundQ2Data?.answer.contains("true") == true ? true : false;

    //FOOTER TOTAL CALCULATION
    var answerTotal = 0.0;
    if (fundQuestions != null) {
      for (FundCalculatorQuestion question in fundQuestions!) {
        answerTotal += question.answerAmount;
      }
    }

    //PERCENTAGE FOR BASED ON QUESTION ANSWER AMOUNT
    var percentage =
        (((qData?.categoryWiseTotalAmt ?? 0) * 100) / answerTotal).round();

    //FOR QUE-1,2,3 PERCENTAGE AND CATEGORY WISE TOTAL CALCULATION [LIVING COST]
    var livingTotal = spouse
        ? (fundQ1Data?.amount ?? 0) +
            (fundQ2Data?.categoryWiseTotalAmt ?? 0.0) +
            (fundQ3Data?.categoryWiseTotalAmt ?? 0.0)
        : (fundQuestions?[quesID].categoryWiseTotalAmt ?? 0.0) +
            (fundQ3Data?.categoryWiseTotalAmt ?? 0.0);

    var livingPercentage = (((livingTotal) * 100) / answerTotal).round();

    //SET PERCENTAGE IN MODEL
    qData?.percentage = quesID == 1 ? livingPercentage : percentage;

    //ADD SELECTED ANSWER FOR QUESTION
    String subNote = quesID == 0
        ? "12 months fee included"
        : quesID == 1
            ? "${spouse == true ? "Spouse + " : ""}${fundQ3Data?.answer.isNotEmpty == true ? fundQ3Data?.answer : "0"} Children"
            : quesID == 4
                ? "Of ${fundQ4Data?.answer} Children"
                : "${fundQ5Data?.selectedOptionValue} ";

    if (qData?.questionTitle != null && qData?.questionTitle != "") {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppColorStyle.backgroundVariant(context),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: quesID == 1
                                  ? Text("$livingPercentage%",
                                      style: AppTextStyle.subTitleSemiBold(
                                        context,
                                        AppColorStyle.teal(context),
                                      ))
                                  : Text("$percentage%",
                                      style: AppTextStyle.subTitleSemiBold(
                                        context,
                                        AppColorStyle.teal(context),
                                      )),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(qData?.category ?? "",
                                        style: AppTextStyle.detailsMedium(
                                          context,
                                          AppColorStyle.text(context),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(subNote,
                                          style: AppTextStyle.captionLight(
                                            context,
                                            AppColorStyle.textDetail(context),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          quesID == 1
                              ? Text(
                                  "${fundBloc.getSelectedCountry?.symbolCode} ${Utility.getAmountInCurrencyFormat(amount: ((livingTotal) * (fundBloc.getSelectedCountry?.rate ?? 0.0)))}",
                                  style: AppTextStyle.subTitleSemiBold(
                                    context,
                                    AppColorStyle.text(context),
                                  ))
                              : Text(
                                  "${fundBloc.getSelectedCountry?.symbolCode} ${Utility.getAmountInCurrencyFormat(amount: (fundQuestions?[quesID].categoryWiseTotalAmt ?? 0.0) * (fundBloc.getSelectedCountry?.rate ?? 0.0))}",
                                  style: AppTextStyle.subTitleSemiBold(
                                    context,
                                    AppColorStyle.text(context),
                                  )),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            IconsSVG.arrowHalfRight,
                            colorFilter: ColorFilter.mode(
                              AppColorStyle.teal(context),
                              BlendMode.srcIn,
                            ),
                            width: 14.0,
                            height: 14.0,
                          )
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: quesID == 1,
                    child: InkWellWidget(
                        onTap: () {
                          var param = {
                            "_fundCalculatorBloc": _fundCalculatorBloc,
                            "fundQuestions": _fundCalculatorBloc
                                ?.getFundCalculatorListStreamValue
                          };
                          GoRoutesPage.go(
                            mode: NavigatorMode.push,
                            moveTo: RouteName.otherLivingCostScreen,
                            param: param,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 70,
                              ),
                              Text(
                                StringHelper.calculateLeavingCoast,
                                style: AppTextStyle.captionBold(
                                  context,
                                  AppColorStyle.teal(context),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5.0, top: 3),
                                child: SvgPicture.asset(
                                  IconsSVG.arrowRight,
                                  fit: BoxFit.contain,
                                  height: 10,
                                  width: 5,
                                  colorFilter: ColorFilter.mode(
                                    AppColorStyle.teal(context),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget footerSection() {
    return Column(
      children: [
        Container(
          height: 10,
          color: AppColorStyle.backgroundVariant(context),
        ),
        // [FOOTER WIDGET]
        StreamWidget(
          stream: _fundCalculatorBloc!.getCountryListStream,
          onBuild: (_, snapshot) {
            List<CountryWithCurrencyModel>? countryModelList = snapshot;
            return FundCalculatorWidget.footerFundTotal(
              context: context,
              isRequiredToShowAnswerTotal: false,
              onCurrencyChange: () {
                _countrySearchController.removeListener(() {});
                _countrySearchController.clear();
                _fundCalculatorBloc?.clearSearch();
                FundCalculatorWidget.currencyListBottomSheetWidget(context,
                    searchController: _countrySearchController,
                    isFromLivingCost: false,
                    needFundTotalAmountInAUD: false,
                    fundBloc: _fundCalculatorBloc!);
              },
              selectedCurrency:
                  _fundCalculatorBloc?.selectedCountrySubject.valueOrNull ??
                      countryModelList?[0],
              fundBloc: _fundCalculatorBloc!,
              fundQuestions: fundQuestions,
              isFromOtherLiving: false,
              questionCategory: _fundCalculatorBloc!.currentCategory,
              selectedQuesAmount: 0.0,
            );
          },
        ),
      ],
    );
  }
}

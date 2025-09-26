import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/country_with_currency.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/model/summary_chart_model.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_calculator_shimmer.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_calculator_widget.dart';
import 'package:occusearch/features/fund_calculator/widget/summary_chart_widget.dart';

class OtherLivingSummaryPage extends BaseApp {
  const OtherLivingSummaryPage({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _OtherLivingSummaryPageState();
}

class _OtherLivingSummaryPageState extends BaseState {
  FundCalculatorBloc? _fundCalculatorBloc;

  // final FundCalculatorBloc _fundCalculatorBloc = FundCalculatorBloc();

  List<FundCalculatorQuestion>? fundQuestions;

  var _fundSavedAnswer = FundCalculatorBloc();

  List<OtherLivingQuestion>? otherQuestions;

  final TextEditingController _countrySearchController =
      TextEditingController();

  @override
  init() async {
    dynamic argumentValue = widget.arguments;
    if (widget.arguments != null) {
      if (argumentValue['fundQuestionsBloc'] != null) {
        _fundCalculatorBloc = argumentValue['fundQuestionsBloc'];
      } else {
        _fundCalculatorBloc = FundCalculatorBloc();
      }
      _fundSavedAnswer =
          argumentValue['_fundCalculatorBloc'] ?? FundCalculatorBloc();
      fundQuestions = argumentValue['fundQuestions'];
    }

    otherQuestions = _fundCalculatorBloc?.getLivingCostQuestionData;

    Future.delayed(Duration.zero, () async {
      await calculateSummaryData();
      await _fundCalculatorBloc?.setupRemoteConfigForCountryList();
      _fundCalculatorBloc?.setSearchFieldController = _countrySearchController;
      await _fundCalculatorBloc?.calculateFundTotal(
          needFundTotalAmountInAUD: true);
    });
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return WillPopScopeWidget(
      onWillPop: () async {
        GoRoutesPage.go(mode: NavigatorMode.remove, moveTo: RouteName.home);
        return false;
      },
      child: Container(
        color: AppColorStyle.background(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                height: 25,
                color: AppColorStyle.teal(context),
              ),
              StreamBuilder<List<SummaryChartData>>(
                stream: _fundCalculatorBloc?.getSummaryChartList,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    List<SummaryChartData> summaryChartData =
                        snapshot.data ?? [];
                    return SummaryChartWidget(
                      isFromOtherLiving: true,
                      summaryChartData: summaryChartData,
                      fundAnswerSavedBloc: _fundSavedAnswer,
                      fundQuestions: fundQuestions,
                    );
                  } else {
                    return const SummaryChartHeaderShimmer();
                  }
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: AppColorStyle.background(context),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.commonPadding),
                        child: StreamBuilder<Object>(
                          stream: _fundCalculatorBloc?.selectedCountryStream,
                          builder: (context, snapshot) {
                            return snapshot.data != null || snapshot.hasData
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(StringHelper.summary,
                                            style: AppTextStyle.titleBold(
                                              context,
                                              AppColorStyle.text(context),
                                            )),
                                      ),
                                      InkWellWidget(
                                        onTap: () {
                                          var index = 1;
                                          context.pop(index);
                                        },
                                        child: summaryFundCalcAnswer(
                                          percentage: 12,
                                          context: context,
                                          quesID: 2,
                                        ),
                                      ),
                                      Divider(
                                          color: AppColorStyle.surfaceVariant(
                                              context),
                                          thickness: 0.5),
                                      InkWellWidget(
                                        onTap: () {
                                          var index = 3;
                                          context.pop(index);
                                        },
                                        child: summaryFundCalcAnswer(
                                          percentage: 14,
                                          context: context,
                                          quesID: 3,
                                        ),
                                      ),
                                      Divider(
                                          color: AppColorStyle.surfaceVariant(
                                              context),
                                          thickness: 0.5),
                                      InkWellWidget(
                                        onTap: () {
                                          var index = 4;
                                          context.pop(index);
                                        },
                                        child: summaryFundCalcAnswer(
                                          percentage: 35,
                                          context: context,
                                          quesID: 4,
                                        ),
                                      ),
                                      Divider(
                                          color: AppColorStyle.surfaceVariant(
                                              context),
                                          thickness: 0.5),
                                      InkWellWidget(
                                        onTap: () {
                                          var index = 5;
                                          context.pop(index);
                                        },
                                        child: summaryFundCalcAnswer(
                                          percentage: 35,
                                          context: context,
                                          quesID: 5,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SummaryChartShimmer();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
              footerSection(),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> calculateSummaryData() async {
    List<SummaryChartData> summaryChartData = [];
    //FOOTER TOTAL CALCULATION
    double answerTotal = 0.0;
    if (otherQuestions == null) {
      return;
    } else {
      for (OtherLivingQuestion qData in otherQuestions!) {
        answerTotal += qData.answerAmount;
      }
    }

    double accommodationAmount = 0.0;
    String categoryName = "";
    int categoryPercentage = 0;

    for (OtherLivingQuestion questionData in otherQuestions!) {
      if (questionData.questionId == 1 ||
          questionData.questionId == 2 ||
          questionData.questionId == 3) {
        accommodationAmount += questionData.categoryWiseTotalAmt;
        if (questionData.questionId == 3) {
          categoryName = questionData.category ?? '';
          categoryPercentage =
              ((accommodationAmount * 100) / answerTotal).round();
          summaryChartData
              .add(SummaryChartData(categoryName, categoryPercentage));
        }
      } else {
        categoryName = questionData.category ?? '';
        categoryPercentage =
            ((questionData.categoryWiseTotalAmt * 100) / answerTotal).round();
        summaryChartData
            .add(SummaryChartData(categoryName, categoryPercentage));
      }
    }
    _fundCalculatorBloc?.setSummaryChartList = summaryChartData;
  }

  Widget summaryFundCalcAnswer(
      {required BuildContext context,
      required int quesID,
      required int percentage}) {
    final qData = otherQuestions?[quesID];

    var other0Data = otherQuestions?[0];
    var other1Data = otherQuestions?[1];

    //FOOTER TOTAL CALCULATION
    var answerTotal = 0.0;
    if (otherQuestions != null) {
      for (OtherLivingQuestion question in otherQuestions!) {
        answerTotal += question.answerAmount;
      }
    }

    //PERCENTAGE FOR BASED ON QUESTION ANSWER AMOUNT
    var percentage =
        (((qData?.categoryWiseTotalAmt ?? 0) * 100) / answerTotal).round();

    //SET PERCENTAGE IN MODEL
    qData?.percentage = percentage;

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
                  Column(
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
                                    color: AppColorStyle.backgroundVariant(
                                        context),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("$percentage%",
                                      style: AppTextStyle.subTitleSemiBold(
                                        context,
                                        AppColorStyle.teal(context),
                                      )),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 3),
                                          child: Text(qData?.category ?? "",
                                              style: AppTextStyle.detailsMedium(
                                                context,
                                                AppColorStyle.text(context),
                                              )),
                                        ),
                                        quesID == 2
                                            ? Text(
                                                "${other0Data?.selectedAnswer}\n${other1Data?.selectedAnswer}\n${qData?.selectedAnswer}",
                                                style:
                                                    AppTextStyle.captionLight(
                                                  context,
                                                  AppColorStyle.textDetail(
                                                      context),
                                                ))
                                            : quesID == 5
                                                ? Text(
                                                    "${qData?.answer.toString().replaceAll('+', '\n')}",
                                                    style: AppTextStyle
                                                        .captionLight(
                                                      context,
                                                      AppColorStyle.textDetail(
                                                          context),
                                                    ))
                                                : Text(
                                                    qData?.selectedAnswer ?? "",
                                                    style: AppTextStyle
                                                        .captionLight(
                                                      context,
                                                      AppColorStyle.textDetail(
                                                          context),
                                                    ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                  "${_fundCalculatorBloc?.getSelectedCountry?.symbolCode} ${Utility.getAmountInCurrencyFormat(amount: (qData?.categoryWiseTotalAmt ?? 0.0) * (_fundCalculatorBloc?.getSelectedCountry?.rate ?? 0.0))}",
                                  style: AppTextStyle.subTitleSemiBold(
                                    context,
                                    AppColorStyle.text(context),
                                  )),
                              /*
                              const SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset(
                                IconsSVG.ic_arrow_right,
                                color: AppColorStyle.teal(context),
                                width: 14.0,
                                height: 14.0,
                              )
                               */
                            ],
                          ),
                        ],
                      ),
                    ],
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
                fundBloc: _fundCalculatorBloc!,
                isRequiredToShowAnswerTotal: false,
                selectedCurrency:
                    _fundCalculatorBloc!.selectedCountrySubject.valueOrNull ??
                        countryModelList?[0],
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
                isFromOtherLiving: true,
                otherQuestions: otherQuestions,
                questionCategory: _fundCalculatorBloc?.currentCategory ?? "",
                selectedQuesAmount: 0.0,
              );
            })
      ],
    );
  }
}

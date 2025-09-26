import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/file_viewer/generate_pdf_for_fund_cal.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/model/summary_chart_model.dart';
import 'package:printing/printing.dart';

class SummaryChartWidget extends StatelessWidget {
  final bool
      isFromOtherLiving; // TRUE = user came from [OTHER LIVING SCREEN] else [FUND CALCULATOR SCREEN]
  // Chart generate based on this data
  final List<SummaryChartData> summaryChartData;

  final List<FundCalculatorQuestion>? fundQuestions;

  final FundCalculatorBloc? fundAnswerSavedBloc;

  const SummaryChartWidget(
      {super.key,
      this.isFromOtherLiving = false,
      required this.summaryChartData,
      this.fundQuestions,
      this.fundAnswerSavedBloc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColorStyle.teal(context),
              padding: EdgeInsets.only(
                  left: Constants.commonPadding,
                  right: Constants.commonPadding,
                  top: !isFromOtherLiving ? 10.0 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            isFromOtherLiving == true
                                ? StringHelper.otherLivingSummary
                                : StringHelper.fundCalc,
                            style: AppTextStyle.subHeadlineBold(
                              context,
                              AppColorStyle.textWhite(context),
                            )),
                        Row(
                          children: [
                            Visibility(
                              visible:!isFromOtherLiving,
                              child: InkWellWidget(
                                onTap: () async {
                                  await Printing.sharePdf(
                                    bytes: await generatePDFForFundCalc(
                                        summaryChartData,
                                        fundAnswerSavedBloc,
                                        fundQuestions),
                                    filename:
                                    Constants.fundCalculatorSummaryPDFName,
                                  );
                                },
                                child: SvgPicture.asset(
                                  IconsSVG.fundCalcSummaryIcon,
                                  width: 30,
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                    AppColorStyle.textWhite(context),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: InkWell(
                                onTap: () {
                                  ///FOR OTHER LIVING TO FUND QUESTION SUMMARY PAGE REDIRECTION
                                  isFromOtherLiving == true
                                      ? Utility.popToSpecificPage(context,
                                      rootName: RouteName.fundCalculatorSummaryPage)
                                      : WidgetHelper.alertDialogWidget(
                                    context: context,
                                    title: StringHelper.fundCalc,
                                    buttonColor: AppColorStyle.teal(context),
                                    message: StringHelper.fundConfirmDialogMessage,
                                    positiveButtonTitle: StringHelper.yesQuit,
                                    negativeButtonTitle: StringHelper.cancel,
                                    onPositiveButtonClick: () {
                                      GoRoutesPage.go(
                                          mode: NavigatorMode.remove,
                                          moveTo: RouteName.home);
                                    },
                                  );
                                },
                                child: SvgPicture.asset(
                                  IconsSVG.closeIcon,
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                    AppColorStyle.textWhite(context),
                                    BlendMode.srcIn,
                                  ),
                                  height: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: summaryChartData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final percentageHeight =
                            (summaryChartData[index].percentage / 100) * 170;
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, right: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    width: 50,
                                    height: percentageHeight + 10.0,
                                    alignment: Alignment.centerLeft,
                                    color: AppColorStyle.tealVariant1(context),
                                  ),
                                  RotatedBox(
                                    quarterTurns: 3,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 14.0),
                                      child: Text(
                                        " ${summaryChartData[index].categoryName}",
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle.subTitleRegular(
                                            context,
                                            AppColorStyle.textWhite(context)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 10,
            color: AppColorStyle.backgroundVariant(context),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

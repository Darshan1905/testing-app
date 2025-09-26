import 'package:flutter/cupertino.dart';
import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'fund_question_header.dart';

class FundQuestion2Widget extends StatelessWidget {
  final int index;
  final int max;
  final Function onNextClick;
  final FundCalculatorQuestion questionStudentData;
  final FundCalculatorQuestion questionSpouseData;
  final bool themeBloc;

  const FundQuestion2Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.onNextClick,
      required this.questionStudentData,
      required this.questionSpouseData, required this.themeBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    questionStudentData.setAnswer(questionStudentData.answer,
        (questionStudentData.amount ?? 0.0).toDouble());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FundQuestionHeader(
              index: index,
              max: max,
              question: questionStudentData.questionTitle ?? '',
            ),
            // STUDENT LIVING
            Container(
              width: screenWidth,
              margin: const EdgeInsets.only(bottom: 15.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColorStyle.teal(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  questionStudentData.questionLabel != null &&
                          questionStudentData.questionLabel != ""
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            questionStudentData.questionLabel ?? '',
                            style: AppTextStyle.detailsRegular(
                              context,
                              AppColorStyle.background(context),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: questionStudentData.questionTitle != null &&
                            questionStudentData.questionTitle != ""
                        ? 15.0
                        : 0.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      "A\$ ${Utility.getAmountInCurrencyFormat(amount: (questionStudentData.amount ?? 0.0).toDouble())}",
                      style: AppTextStyle.titleBold(
                          context, AppColorStyle.background(context)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // SPOUSE APPLICATION
            questionSpouseData.questionTitle != null &&
                    questionSpouseData.questionTitle != ""
                ? Container(
                    margin: const EdgeInsets.only(bottom: 15.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColorStyle.backgroundVariant(context),
                    ),
                    child: Column(
                      children: [
                        questionSpouseData.questionTitle != null &&
                                questionSpouseData.questionTitle != ""
                            ? Text(
                                questionSpouseData.questionTitle ?? '',
                                style: AppTextStyle.detailsRegular(
                                  context,
                                  AppColorStyle.textDetail(context),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: questionSpouseData.questionTitle != null &&
                                  questionSpouseData.questionTitle != ""
                              ? 10.0
                              : 0.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "+ A\$ ${Utility.getAmountInCurrencyFormat(amount: (questionSpouseData.amount ?? 0.0).toDouble())}",
                              style: AppTextStyle.titleBold(
                                  context, AppColorStyle.teal(context)),
                            ),
                            StreamBuilder<String>(
                              stream: questionSpouseData.answerStream,
                              builder: (context, snapshot) {
                                return FittedBox(
                                  child: Transform.scale(
                                    scale: 0.6,
                                    child: CupertinoSwitch(
                                      onChanged: (value) =>
                                          questionSpouseData.setAnswer(
                                              '$value',
                                              value
                                                  ? (questionSpouseData.amount ??
                                                          0.0)
                                                      .toDouble()
                                                  : 0.0),
                                      value: snapshot.hasData
                                          ? snapshot.data == 'true'
                                          : false,
                                      activeColor: AppColorStyle.tealVariant2(context),
                                      thumbColor: AppColorStyle.teal(context),
                                      trackColor: themeBloc ? ThemeConstant.backgroundDark : ThemeConstant.surfaceVariant
                                      // AppColorStyle.surfaceVariant(context),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

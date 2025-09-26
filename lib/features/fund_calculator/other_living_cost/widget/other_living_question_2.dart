import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_header.dart';

class OtherLivingQuestion2Widget extends StatelessWidget {
  final int index;
  final int max;
  final Function onNextClick;
  final OtherLivingQuestion questionData;

  const OtherLivingQuestion2Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.onNextClick,
      required this.questionData})
      : super(key: key);

  static List<String> residentIcon = [IconsSVG.cityIcon, IconsSVG.suburbsIcon];

  @override
  Widget build(BuildContext context) {
    double width =
        MediaQuery.of(context).size.width - (Constants.commonPadding * 2);
    double height = MediaQuery.of(context).size.height / 8.5;

    if (questionData.answer == null || questionData.answer == "") {
      questionData.options?[0].isSelected = true;
      questionData.options?[1].isSelected = false;
      questionData.selectedAnswer = questionData.options?[0].option;
      questionData.setAnswerOtherLiving('${questionData.options?[0].optionId}',
          double.parse("${questionData.options?[0].amount ?? '0'}"));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FundQuestionHeader(
              index: index,
              max: max,
              question: questionData.questionTitle ?? '',
            ),
            questionData.options != null
                ? StreamBuilder<String>(
                    stream: questionData.answerStream,
                    builder: (context, snapshot) {
                      return Center(
                        child: Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            color: AppColorStyle.backgroundVariant(context),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                alignment: Alignment(
                                    questionData.answer == "1" ||
                                            questionData.answer == ""
                                        ? -1
                                        : 1,
                                    0),
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  width: width * 0.5,
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: AppColorStyle.teal(context),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  questionData.selectedAnswer =
                                      questionData.options?[0].option;
                                  double amount = 0.0;
                                  if (questionData.options != null) {
                                    amount = double.parse(
                                        "${questionData.options?[0].amount ?? '0'}");
                                  }
                                  questionData.setAnswerOtherLiving(
                                      '${questionData.options?[0].optionId}',
                                      amount);
                                },
                                child: Align(
                                  alignment: const Alignment(-1, 0),
                                  child: Container(
                                    width: width * 0.5,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          residentIcon[0],
                                          colorFilter: ColorFilter.mode(
                                            questionData.answer == "1" ||
                                                    questionData.answer == ""
                                                ? AppColorStyle.textWhite(
                                                    context)
                                                : AppColorStyle.textDetail(
                                                    context),
                                            BlendMode.srcIn,
                                          ),
                                          width: 30,
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            questionData.options?[0].option ??
                                                "",
                                            style: questionData.answer == "1" ||
                                                    questionData.answer == ""
                                                ? AppTextStyle.subTitleMedium(
                                                    context,
                                                    AppColorStyle.textWhite(
                                                        context))
                                                : AppTextStyle.captionRegular(
                                                    context,
                                                    AppColorStyle.textDetail(
                                                        context)))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  questionData.selectedAnswer =
                                      questionData.options?[1].option;
                                  questionData.answer =
                                      questionData.options?[1].option ?? '';
                                  double amount = 0.0;
                                  if (questionData.options != null) {
                                    questionData.options?[1].isSelected = true;
                                    amount = double.parse(
                                        "${questionData.options?[1].amount ?? '0'}");
                                  }
                                  questionData.setAnswerOtherLiving(
                                      '${questionData.options?[1].optionId}',
                                      amount);
                                },
                                child: Align(
                                  alignment: const Alignment(1, 0),
                                  child: Container(
                                    width: width * 0.5,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          residentIcon[1],
                                          colorFilter: ColorFilter.mode(
                                            questionData.answer == "2"
                                                ? AppColorStyle.textWhite(
                                                    context)
                                                : AppColorStyle.textDetail(
                                                    context),
                                            BlendMode.srcIn,
                                          ),
                                          width: 30,
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            questionData.options?[1].option ??
                                                "",
                                            style: questionData.answer == "2"
                                                ? AppTextStyle.subTitleMedium(
                                                    context,
                                                    AppColorStyle.textWhite(
                                                        context))
                                                : AppTextStyle.captionRegular(
                                                    context,
                                                    AppColorStyle.textDetail(
                                                        context))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_header.dart';

class OtherLivingQuestion4Widget extends StatelessWidget {
  final int index;
  final int max;
  final Function onNextClick;
  final OtherLivingQuestion questionData;

  const OtherLivingQuestion4Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.onNextClick,
      required this.questionData})
      : super(key: key);

  static List<String> transportIcon = [
    IconsSVG.publicTransport,
    IconsSVG.privateTransport,
    IconsSVG.skipTransport
  ];

  @override
  Widget build(BuildContext context) {
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
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: questionData.options?.length ?? 0,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      LivingCostOptions? selectedOption =
                          questionData.options?[index];
                      return StreamBuilder<String>(
                          stream: questionData.answerStream,
                          builder: (context, snapshot) {
                            return InkWellWidget(
                              onTap: () {
                                questionData.selectedAnswer =
                                    selectedOption?.option;
                                questionData.answer = selectedOption?.option;
                                debugPrint(
                                    "Selected_options: ${selectedOption?.option}");
                                double amount = 0.0;
                                if (questionData.options != null) {
                                  questionData.options?.forEach((option) {
                                    if (selectedOption?.optionId ==
                                        option.optionId) {
                                      option.isSelected = true;

                                      amount =
                                          double.parse("${option.amount ?? '0'}");
                                    } else if (selectedOption?.optionId !=
                                        option.optionId) {
                                      option.isSelected = false;
                                    }
                                  });
                                }
                                questionData.setAnswerOtherLiving(
                                    '${selectedOption!.optionId}', amount);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedOption?.isSelected == true
                                        ? AppColorStyle.teal(context)
                                        : AppColorStyle.backgroundVariant(
                                            context),
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Column(
                                      children: [
                                        selectedOption?.isSelected == true
                                            ? Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: AppColorStyle
                                                              .textWhite(
                                                                  context))),
                                                ),
                                              )
                                            : const SizedBox(
                                                height: 10,
                                                width: 10,
                                              ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              transportIcon[index],
                                              colorFilter: ColorFilter.mode(
                                                selectedOption?.isSelected ==
                                                    true
                                                    ? AppColorStyle.textWhite(
                                                    context)
                                                    : AppColorStyle.textDetail(
                                                    context),
                                                BlendMode.srcIn,
                                              ),
                                              width: 20,
                                              height: 20,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 3.0),
                                                  child: Text(
                                                      selectedOption?.option ??
                                                          "",
                                                      style: selectedOption
                                                                  ?.isSelected ==
                                                              true
                                                          ? AppTextStyle
                                                              .detailsRegular(
                                                                  context,
                                                                  AppColorStyle
                                                                      .textWhite(
                                                                          context))
                                                          : AppTextStyle.titleMedium(
                                                              context,
                                                              AppColorStyle
                                                                  .textDetail(
                                                                      context))),
                                                ),
                                                Text(
                                                  "A\$ ${selectedOption?.optionAmount.toString()}",
                                                  style: selectedOption
                                                              ?.isSelected ==
                                                          true
                                                      ? AppTextStyle
                                                          .titleSemiBold(
                                                              context,
                                                              AppColorStyle
                                                                  .textWhite(
                                                                      context))
                                                      : AppTextStyle
                                                          .detailsRegular(
                                                              context,
                                                              AppColorStyle
                                                                  .textHint(
                                                                      context)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

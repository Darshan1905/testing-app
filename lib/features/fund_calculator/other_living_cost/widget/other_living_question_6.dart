import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_header.dart';

class OtherLivingQuestion6Widget extends StatelessWidget {
  final int index;
  final int max;
  final Function onNextClick;
  final OtherLivingQuestion questionData;

  const OtherLivingQuestion6Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.onNextClick,
      required this.questionData})
      : super(key: key);

  static List<String> utilityIcon = [
    IconsSVG.phoneInternetIcon,
    IconsSVG.entertainmentIcon,
    IconsSVG.careAndHygieneIcon,
    IconsSVG.basicUtilityIcon,
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
              showMultiSelection: true,
            ),
            questionData.options != null
                ? ListView.builder(
                    itemCount: questionData.options?.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      LivingCostOptions? selectedOption =
                          questionData.options?[index];
                      return StreamBuilder<String>(
                          stream: questionData.answerStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: InkWellWidget(
                                onTap: () {
                                  // questionData.answer = selectedOption?.option;
                                  if (questionData.options != null) {
                                    questionData.options?.forEach((option) {
                                      if (selectedOption?.optionId ==
                                          option.optionId) {
                                        option.isSelected = !option.isSelected;
                                      }
                                    });
                                  }

                                  //STORE SELECTED MULTIPLE ANSWER IN MODEL
                                  questionData.answer = questionData.options
                                      ?.expand((e) =>
                                          [if (e.isSelected == true) e.option])
                                      .toList()
                                      .join("+");

                                  //STORE TOTAL AMOUNT FOR UTILITY MULTI SELECTION
                                  final selectedItemsArr = questionData.options
                                      ?.where((element) =>
                                          (element.isSelected == true))
                                      .toList();
                                  double totalAmount = 0.0;
                                  if (selectedItemsArr != null) {
                                    for (LivingCostOptions values
                                        in selectedItemsArr) {
                                      totalAmount += values.amount ?? 0.0;
                                    }
                                  }

                                  //SET LIVING TOTAL
                                  questionData.setAnswerOtherLiving(
                                      '${questionData.answer}',
                                      totalAmount,
                                      questionData);
                                },
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
                                              utilityIcon[index],
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
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      selectedOption?.option ??
                                                          "",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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

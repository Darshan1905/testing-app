import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_header.dart';

class OtherLivingQuestion5Widget extends StatelessWidget {
  final int index;
  final int max;
  final Function onNextClick;
  final OtherLivingQuestion questionData;

  const OtherLivingQuestion5Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.onNextClick,
      required this.questionData})
      : super(key: key);

  static List<String> foodIcon = [
    IconsSVG.atEatingOutIcon,
    IconsSVG.atHomeIcon
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
                ? GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: questionData.options?.length ?? 0,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 230,
                      // mainAxisSpacing: 15.0,
                      crossAxisSpacing: 20.0,
                    ),
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
                                      amount = double.parse(
                                          "${option.amount ?? '0'}");
                                    } else if (selectedOption?.optionId !=
                                        option.optionId) {
                                      option.isSelected = false;
                                    }
                                  });
                                }
                                questionData.setAnswerOtherLiving(
                                    '${selectedOption!.optionId}', amount);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: selectedOption?.isSelected == true
                                        ? AppColorStyle.teal(context)
                                        : AppColorStyle.backgroundVariant(
                                            context)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          foodIcon[index],
                                          colorFilter: ColorFilter.mode(
                                            selectedOption?.isSelected == true
                                                ? AppColorStyle.textWhite(
                                                    context)
                                                : AppColorStyle.textDetail(
                                                    context),
                                            BlendMode.srcIn,
                                          ),
                                          width: 40,
                                          height: 40,
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          selectedOption?.option ?? "",
                                          style:
                                              selectedOption?.isSelected == true
                                                  ? AppTextStyle.detailsRegular(
                                                      context,
                                                      AppColorStyle.textWhite(
                                                          context))
                                                  : AppTextStyle.titleMedium(
                                                      context,
                                                      AppColorStyle.textDetail(
                                                          context)),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "A\$ ${selectedOption?.optionAmount.toString()}",
                                          style:
                                              selectedOption?.isSelected == true
                                                  ? AppTextStyle.titleSemiBold(
                                                      context,
                                                      AppColorStyle.textWhite(
                                                          context))
                                                  : AppTextStyle.detailsRegular(
                                                      context,
                                                      AppColorStyle.textHint(
                                                          context)),
                                        ),
                                      ],
                                    ),
                                    selectedOption?.isSelected == true
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0, top: 10),
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
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
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

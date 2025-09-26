import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_header.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// ignore: must_be_immutable
class OtherLivingQuestion3Widget extends StatelessWidget {
  final int index;
  final int max;
  final Function onNextClick;
  final OtherLivingQuestion questionData;
  final OtherLivingQuestion question1Data;
  final OtherLivingQuestion question2Data;

  OtherLivingQuestion3Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.onNextClick,
      required this.questionData,
      required this.question1Data,
      required this.question2Data})
      : super(key: key);

  static PageController accommodationController =
      PageController(initialPage: 0, viewportFraction: 0.6, keepPage: true);

  ItemScrollController mapItemController = ItemScrollController();

  static List<String> accommodationIcon = [
    IconsSVG.homeStayIcon,
    IconsSVG.sharedHomeIcon,
    IconsSVG.oneBedRoomIcon,
    IconsSVG.manageApartmentIcon
  ];

  @override
  Widget build(BuildContext context) {
    var que1Ans = int.parse(question1Data.answer ?? "0");
    var que2Ans = question2Data.selectedAnswer;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: FundQuestionHeader(
              index: index,
              max: max,
              question: questionData.questionTitle ?? '',
            ),
          ),
          SizedBox(
              height: 300,
              // height: MediaQuery.of(context).size.height / 2.6,
              child: ScrollablePositionedList.builder(
                itemScrollController: mapItemController,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: questionData.accommodationOptions?.length ?? 0,
                // controller: accommodationController,
                itemBuilder: (BuildContext context, int index) {
                  AccommodationOptions? selectedOption =
                      questionData.accommodationOptions?[index];

                  StudyCityAmount? studyAmt = questionData
                      .accommodationOptions?[index]
                      .studyCityAmount?[que1Ans - 1];
                  var rangeAmount =
                      que2Ans.toString().toLowerCase().contains("city")
                          ? studyAmt?.cityRangeAmount
                          : studyAmt?.suburbsRangeAmount;
                  var totalAmount =
                      que2Ans.toString().toLowerCase().contains("city")
                          ? studyAmt?.cityAmount
                          : studyAmt?.suburbsAmount;

                  return Container(
                    width: MediaQuery.of(context).size.width / 1.8,
                    margin: EdgeInsets.only(
                        right: index == (questionData.options?.length ?? 0 - 1)
                            ? 10.0
                            : 0.0,
                        left: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<String>(
                          stream: questionData.answerStream,
                          builder: (context, snapshot) {
                            return InkWellWidget(
                              onTap: () {
                                questionData.selectedAnswer =
                                    selectedOption?.option;
                                questionData.answer = selectedOption?.option;
                                double amount = 0.0;
                                for (AccommodationOptions options
                                    in questionData.accommodationOptions ??
                                        []) {
                                  options.isSelected = false;
                                }
                                if (questionData.accommodationOptions != null) {
                                  questionData.accommodationOptions
                                      ?.forEach((option) {
                                    if (selectedOption?.optionId ==
                                        option.optionId) {
                                      option.isSelected = true;
                                      //AMOUNT SET FOR ACCOMMODATION
                                      amount = double.parse("$totalAmount");
                                    }
                                  });
                                }
                                questionData.setAnswerOtherLiving(
                                    '${selectedOption!.optionId}', amount);

                                mapItemController.scrollTo(
                                    index: index,
                                    duration: const Duration(seconds: 1));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
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
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: selectedOption
                                                            ?.isSelected ==
                                                        true
                                                    ? 15
                                                    : 25),
                                            child: SvgPicture.asset(
                                              accommodationIcon[index],
                                              colorFilter: ColorFilter.mode(
                                                selectedOption?.isSelected ==
                                                        true
                                                    ? AppColorStyle.textWhite(
                                                        context)
                                                    : AppColorStyle.textDetail(
                                                        context),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: selectedOption
                                                            ?.isSelected ==
                                                        true
                                                    ? 15
                                                    : 8),
                                            child: Text(
                                              selectedOption?.option ?? "",
                                              textAlign: TextAlign.center,
                                              style: AppTextStyle.titleMedium(
                                                  context,
                                                  selectedOption?.isSelected ==
                                                          true
                                                      ? AppColorStyle.textWhite(
                                                          context)
                                                      : AppColorStyle
                                                          .textDetail(context)),
                                            ),
                                          ),
                                          Text(
                                            'A\$ $rangeAmount',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.subTitleRegular(
                                                context,
                                                selectedOption?.isSelected ==
                                                        true
                                                    ? AppColorStyle.textWhite(
                                                        context)
                                                    : AppColorStyle.textDetail(
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
                                    ]),
                              ),
                            );
                          }),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}

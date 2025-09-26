import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_header.dart';

class OtherLivingQuestion1Widget extends StatelessWidget {
  final int index;
  final int max;
  final Function onNextClick;
  final OtherLivingQuestion questionData;

  OtherLivingQuestion1Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.onNextClick,
      required this.questionData})
      : super(key: key);

  final List<String> cityPinMapIcon = [
    IconsSVG.icPinAdelaide,
    IconsSVG.icPinMelbourne,
    IconsSVG.icPinBrisbane,
    IconsSVG.icPinSydney,
    IconsSVG.icPinPerth,
    IconsSVG.icPinCanberra,
    IconsSVG.icPinHobart,
    IconsSVG.icPinGoldCoast
  ];
  var strSelectedOption = "Select City";

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
                ? Column(
                    children: [
                      InkWellWidget(
                        onTap: () {
                          setBottomSheetForPins(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColorStyle.backgroundVariant1(context),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: StreamBuilder<Object>(
                              stream: questionData.answerStream,
                              builder: (context, snapshot) {
                                questionData.options?.forEach((option) {
                                  if (snapshot.data != null &&
                                      snapshot.data.toString() != "" &&
                                      option.optionId ==
                                          int.parse(snapshot.data.toString())) {
                                    strSelectedOption = option.option ?? "";
                                  }
                                });
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      strSelectedOption,
                                      style: AppTextStyle.subTitleRegular(
                                        context,
                                        AppColorStyle.text(context),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      width: 10,
                                      height: 10,
                                      IconsSVG.arrowDownIcon,
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
                      const SizedBox(height: 50.0)
                    ],
                  )
                : const SizedBox(),
            //map image
            StreamBuilder(
              stream: questionData.answerStream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        width: double.infinity,
                        height: 200,
                        IconsSVG.icMapForAustralianCity,
                      ),
                      (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data.toString() != "")
                          ? SvgPicture.asset(
                              width: double.infinity,
                              height: 200,
                              cityPinMapIcon[int.parse(snapshot.data!) - 1],
                              // because option ids are between 1 to 6 and index is between 0 to 5,
                            )
                          : Container(),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  setBottomSheetForPins(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: false,
      enableDrag: true,
      useSafeArea: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.80,
          minChildSize: 0.80,
          maxChildSize: 1.0,
          expand: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              child: Container(
                color: AppColorStyle.background(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 25.0),
                      child: Text(
                        "Select",
                        style: AppTextStyle.titleSemiBold(
                            context, AppColorStyle.text(context)),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: questionData.options?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        LivingCostOptions? selectedOption =
                            questionData.options?[index];
                        return StreamBuilder<String>(
                          stream: questionData.answerStream,
                          builder: (context, snapshot) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width / 1.8,
                              margin: EdgeInsets.only(
                                  right: index ==
                                          (questionData.options?.length ?? 0 - 1)
                                      ? 10.0
                                      : 0.0,
                                  left: 10),
                              child: InkWellWidget(
                                onTap: () {
                                  questionData.selectedAnswer =
                                      selectedOption.option;
                                  debugPrint(
                                      "Selected_options: ${selectedOption.option}");
                                  double amount = 0.0;
                                  if (questionData.options != null) {
                                    questionData.options?.forEach((option) {
                                      if (selectedOption.optionId ==
                                          option.optionId) {
                                        option.isSelected = true;
                                        amount = double.parse(
                                            "${option.amount ?? '0'}");
                                      } else if (selectedOption.optionId !=
                                          option.optionId) {
                                        option.isSelected = false;
                                      }
                                    });
                                  }
                                  questionData.setAnswerOtherLiving(
                                      '${selectedOption.optionId}', amount);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                AppColorStyle.backgroundVariant1(context)),
                                        child: Center(
                                          child: Text(
                                            questionData
                                                .options![index].option![0],
                                            style: AppTextStyle.detailsSemiBold(
                                                context,
                                                AppColorStyle.teal(context)),
                                            //textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15.0),
                                      Expanded(
                                        child: RichText(
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                            text: questionData
                                                    .options![index].option ??
                                                "",
                                            style: AppTextStyle.detailsRegular(
                                                context,
                                                AppColorStyle.text(context)),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            selectedOption!.isSelected == true
                                                ? true
                                                : false,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 10.0),
                                          child: SvgPicture.asset(
                                            width: 15,
                                            height: 15,
                                            IconsSVG.icGreenTick,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

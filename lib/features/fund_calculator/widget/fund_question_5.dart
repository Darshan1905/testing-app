import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'fund_question_header.dart';

// ignore: must_be_immutable
class FundQuestion5Widget extends StatelessWidget {
  late final int index;
  final int max;
  final FundCalculatorQuestion questionData;
  final FundCalculatorQuestion question3Data;
  final FundCalculatorQuestion question4Data;

  dynamic totalAmount;
  var isSpouseAdded = false;
  var noOfChildren = 0;

  FundCalculatorBloc? _fundBloc;
  final List<String> travellingMapIcon = [
    IconsSVG.mapAsiaGreen,
    IconsSVG.mapWestAfricaGreen,
    IconsSVG.mapEastOrSouthernAfrica,
    IconsSVG.mapEuropeGreen,
    IconsSVG.mapNorthSouthAmerica,
    IconsSVG.mapAustraliaGreen
  ];
  var strSelectedOption = "Select Country";

  FundQuestion5Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.question3Data,
      required this.question4Data,
      required this.questionData})
      : super(key: key);

  ItemScrollController mapItemController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    if (question3Data.answer.toString() != "" &&
        question3Data.answer.toString().toLowerCase() == "true") {
      isSpouseAdded = true;
    }

    if (question4Data.answer.toString() != "") {
      noOfChildren = int.parse(question4Data.answer);
    }

    //when user already selected any answer and if it make any change in previously selected question then we need to update the answer
    for (int i = 0; i < questionData.options!.length; i++) {
      if (questionData.options![i].isSelected == true) {
        var amount = double.parse(((isSpouseAdded
                    ? (2 * questionData.options![index].amount!)
                    : (questionData.options![index].amount!)) +
                (noOfChildren > 0
                    ? ((questionData.options![index].amount!) * noOfChildren)
                    : 0))
            .toString());
        questionData.setAnswer('${questionData.options![i].optionId}', amount);
      }
    }

    totalAmount = ((isSpouseAdded
            ? (2 * questionData.options![index].amount!)
            : (questionData.options![index].amount!)) +
        (noOfChildren > 0
            ? ((questionData.options![index].amount!) * noOfChildren)
            : 0));

    _fundBloc ??= RxBlocProvider.of<FundCalculatorBloc>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: FundQuestionHeader(
              index: index,
              max: max,
              question: questionData.questionTitle ?? '',
            ),
          ),
          questionData.questionLabel != null && questionData.questionLabel != ""
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "${questionData.questionLabel}",
                    style: AppTextStyle.subTitleRegular(
                      context,
                      AppColorStyle.text(context),
                    ),
                  ),
                )
              : const SizedBox(),
          questionData.options != null
              ? Column(
                  children: [
                    InkWellWidget(
                      onTap: () {
                        setBottomSheetForMap(
                            context, isSpouseAdded, noOfChildren);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      IconsSVG.worldMapLightGrey,
                    ),
                    (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data.toString() != "")
                        ? SvgPicture.asset(
                            width: double.infinity,
                            height: 200,
                            travellingMapIcon[int.parse(snapshot.data!) - 1],
                            // bcos option ids are between 1 to 6 and index is between 0 to 5,
                          )
                        : Container(),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  setBottomSheetForMap(
      BuildContext context, bool isSpouseAdded, int noOfChildren) {
    return showModalBottomSheet(
      isScrollControlled: false,
      enableDrag: true,
      useSafeArea: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        //for refresh inside bottom sheet
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
                        Options? selectedOption = questionData.options?[index];
                        return StreamBuilder<String>(
                          stream: questionData.answerStream,
                          builder: (context, snapshot) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width / 1.8,
                              margin: EdgeInsets.only(
                                  right: index ==
                                          (questionData.options?.length ??
                                              0 - 1)
                                      ? 10.0
                                      : 0.0,
                                  left: 10),
                              child: InkWellWidget(
                                onTap: () {
                                  double amount = 0.0;
                                  questionData.selectedOptionValue =
                                      selectedOption.option ?? "";
                                  //to make all options unselected
                                  for (int i = 0;
                                      i < questionData.options!.length;
                                      i++) {
                                    questionData.options![i].isSelected = false;
                                  }
                                  questionData.options![index].isSelected =
                                      true;

                                  amount = double.parse(((isSpouseAdded
                                              ? (2 *
                                                  questionData
                                                      .options![index].amount!)
                                              : (questionData
                                                  .options![index].amount!)) +
                                          (noOfChildren > 0
                                              ? ((questionData.options![index]
                                                      .amount!) *
                                                  noOfChildren)
                                              : 0))
                                      .toString());
                                  questionData.setAnswer(
                                      '${selectedOption.optionId}', amount);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            text:
                                                "${questionData.options![index].option ?? ""} A\$ ${((isSpouseAdded == true ? (2 * questionData.options![index].amount!) : (questionData.options![index].amount!)) + (noOfChildren > 0 ? (questionData.options![index].amount! * noOfChildren) : 0))}",
                                            style: AppTextStyle.detailsRegular(
                                                context,
                                                AppColorStyle.text(context)),
                                            children: [
                                              WidgetSpan(
                                                child: SizedBox(
                                                  height: 20.0,
                                                  width: 25.0,
                                                  child: PopupMenuButton(
                                                      offset:
                                                          const Offset(-5, 35),
                                                      icon: SvgPicture.asset(
                                                        IconsSVG.icFundInfo,
                                                        height: 24.0,
                                                        width: 24.0,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          AppColorStyle.teal(
                                                              context),
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      color:
                                                          AppColorStyle.surface(
                                                              context),
                                                      itemBuilder:
                                                          (BuildContext
                                                                  context) =>
                                                              [
                                                                PopupMenuItem(
                                                                    child: Text(
                                                                  isSpouseAdded
                                                                      ? "You're bringing your spouse and $noOfChildren children.\nYour (${questionData.options![index].amount}) +"
                                                                          " Spouse (${questionData.options![index].amount}) + $noOfChildren Children (${questionData.options![index].amount! * noOfChildren}) "
                                                                          "= ${((isSpouseAdded ? (2 * questionData.options![index].amount!) : questionData.options![index].amount!) + (noOfChildren > 0 ? (questionData.options![index].amount!) * noOfChildren : 0.0))} (Total) "
                                                                      : "You're bringing $noOfChildren children.\nYour (${questionData.options![index].amount}) +"
                                                                          " $noOfChildren Children (${questionData.options![index].amount! * noOfChildren}) "
                                                                          "= ${(questionData.options![index].amount!) + (noOfChildren > 0 ? (questionData.options![index].amount! * noOfChildren) : 0.0)} (Total) ",
                                                                  style: AppTextStyle.captionRegular(
                                                                      context,
                                                                      AppColorStyle
                                                                          .textDetail(
                                                                              context)),
                                                                )),
                                                              ]),
                                                ),
                                                alignment:
                                                    PlaceholderAlignment.top,
                                              ),
                                            ],
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

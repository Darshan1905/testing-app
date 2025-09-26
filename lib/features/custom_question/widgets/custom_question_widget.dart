// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/search_field_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/custom_question/custom_question_bloc.dart';
import 'package:occusearch/features/custom_question/model/custom_question_model.dart';
import 'package:occusearch/features/visa_fees/model/visa_subclass_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_shimmer.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:rxdart/rxdart.dart';
import "package:collection/collection.dart";

//Radio Button
class CustomQuesSingleSelectionWidget extends StatelessWidget {
  final CustomQuestions questionData;
  final Function onSelected;
  final bool isFromDashboard;

  const CustomQuesSingleSelectionWidget(
      {Key? key,
      required this.questionData,
      required this.onSelected,
      required this.isFromDashboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<String>(
          stream: questionData.answerStream,
          builder: (context, snapshot) {
            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              children: List.generate(
                questionData.options?.length ?? 0,
                (index) {
                  CustomQuestionOptions optionRowData =
                      questionData.options?[index] ?? CustomQuestionOptions();
                  return (questionData.options != null &&
                          questionData.options!.isNotEmpty)
                      ? InkWellWidget(
                          onTap: () {
                            questionData.setCustomQuestionAnswer(
                                "${optionRowData.optionId ?? 0}",
                                isFromDashboard);
                            onSelected();
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 24),
                              margin:
                                  const EdgeInsets.only(bottom: 15, right: 10),
                              decoration: BoxDecoration(
                                color:
                                    (questionData.answer?.isNotEmpty == true) &&
                                            questionData.answer ==
                                                "${optionRowData.optionId}"
                                        ? AppColorStyle.primaryVariant1(context)
                                        : AppColorStyle.surface(context),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                optionRowData.answer.toString(),
                                style:
                                    (questionData.answer?.isNotEmpty == true) &&
                                            questionData.answer ==
                                                "${optionRowData.optionId}"
                                        ? AppTextStyle.subTitleMedium(context,
                                            AppColorStyle.textWhite(context))
                                        : AppTextStyle.subTitleMedium(context,
                                            AppColorStyle.textDetail(context)),
                              )),
                        )
                      : const SizedBox();
                },
              ),
            );
          }),
    );
  }
}

//Radial Range Widget
class CustomQuestionRadialSliderSelectionWidget extends StatelessWidget {
  final CustomQuestions questionData;
  final bool isFromDashboard;

  const CustomQuestionRadialSliderSelectionWidget(
      {Key? key, required this.questionData, required this.isFromDashboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int userAnswerIndex = 0;
    if (questionData.options != null &&
        questionData.answer != null &&
        questionData.answer != "") {
      userAnswerIndex = questionData.options?.indexWhere((element) =>
              element.optionId == int.parse(questionData.answer ?? '0')) ??
          0;
    }
    return StreamBuilder<String>(
        stream: questionData.answerStream,
        builder: (context, snapshot) {
          return Center(
            child: SleekCircularSlider(
              appearance: CircularSliderAppearance(
                  angleRange: 360,
                  size: 160,
                  startAngle: 265,
                  counterClockwise: false,
                  animationEnabled: false,
                  customColors: CustomSliderColors(
                      hideShadow: false,
                      trackColor: AppColorStyle.primaryVariant1(context),
                      progressBarColor: AppColorStyle.primary(context)),
                  customWidths: CustomSliderWidths(progressBarWidth: 10)),
              onChange: (double value) {
                questionData.setCustomQuestionAnswer(
                    '${questionData.options?[value.round()].optionId}',
                    isFromDashboard);
                if (questionData.options != null &&
                    questionData.answer != null &&
                    questionData.answer != "") {
                  userAnswerIndex = questionData.options?.indexWhere(
                          (element) =>
                              element.optionId ==
                              int.parse(questionData.answer ?? '0')) ??
                      0;
                }
              },
              initialValue: double.parse('$userAnswerIndex'),
              // min: 0,
              innerWidget: (value) {
                return Center(
                  child: Text('${questionData.options![value.round()].answer}',
                      style: AppTextStyle.subHeadlineSemiBold(
                          context, AppColorStyle.text(context))),
                );
              },
              max: questionData.options!.length.toDouble() - 1.0,
            ),
          );
        });
  }
}

//Slider Widget
class CustomQuestionSliderSelectionWidget extends StatelessWidget {
  final CustomQuestions questionData;
  final bool isFromDashboard;

  const CustomQuestionSliderSelectionWidget(
      {Key? key, required this.questionData, required this.isFromDashboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: questionData.answerStream,
        builder: (context, snapshot) {
          int userAnswerIndex = 0;
          if (questionData.options != null &&
              questionData.answer != null &&
              questionData.answer != "") {
            userAnswerIndex = questionData.options?.indexWhere((element) =>
                    element.optionId ==
                    int.parse(questionData.answer ?? '0')) ??
                0;
          }
          // final double noOfSelectedAnswer =
          //     (questionData.answer?.isNotEmpty == true) &&
          //             questionData.answer != ""
          //         ? double.parse(questionData.answer.toString())
          //         : 0;
          return Column(
            children: [
              Slider(
                value: userAnswerIndex < 0
                    ? double.parse("0")
                    : double.parse(userAnswerIndex.toString()),
                min: 0.0,
                max: questionData.options!.length.toDouble() - 1.0,
                divisions: questionData.options!.length - 1,
                activeColor: AppColorStyle.primary(context),
                thumbColor: AppColorStyle.primary(context),
                inactiveColor: AppColorStyle.surface(context),
                onChanged: (double newValue) {
                  // questionData.setCustomQuestionAnswer('${newValue.round()}');
                  questionData.setCustomQuestionAnswer(
                      '${questionData.options?[newValue.toInt()].optionId}',
                      isFromDashboard);
                  if (questionData.options != null &&
                      questionData.answer != null &&
                      questionData.answer != "") {
                    userAnswerIndex = questionData.options?.indexWhere(
                            (element) =>
                                element.optionId ==
                                int.parse(questionData.answer ?? '0')) ??
                        0;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int no = 0; no < questionData.options!.length; no++)
                      Text(
                        questionData.options![no].answer.toString(),
                        style: no == userAnswerIndex
                            ? AppTextStyle.detailsSemiBold(
                                context,
                                AppColorStyle.primary(context),
                              )
                            : AppTextStyle.detailsSemiBold(
                                context,
                                AppColorStyle.textHint(context),
                              ),
                      ),
                  ],
                ),
              )
            ],
          );
        });
  }
}

//DropDown Widget
class CustomQuestionDropDownSelectionWidget extends StatelessWidget {
  final CustomQuestions questionData;
  final TextEditingController searchController;
  final TextEditingController dropDownSearchController;
  final bool isFromDashboard;

  const CustomQuestionDropDownSelectionWidget(
      {Key? key,
      required this.questionData,
      required this.searchController,
      required this.dropDownSearchController,
      required this.isFromDashboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visaFeesBloc = RxBlocProvider.of<VisaFeesBloc>(context);
    return StreamBuilder(
        stream: CombineLatestStream.list([
          questionData.answerStream,
          visaFeesBloc.getVisaSubclassListStream,
        ]),
        // stream: questionData.answerStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            List<SubclassData> visaFeesSubListValue =
                snapshot.data?[1] as List<SubclassData>;

            var selectedAnswer = "";
            if (questionData.type != "Short Text Entry") {
              //OPTIONS
              if (questionData.options?.isNotEmpty == true &&
                  questionData.answer?.isNotEmpty == true) {
                for (CustomQuestionOptions? optVal
                    in questionData.options ?? []) {
                  if (optVal?.optionId.toString() == questionData.answer) {
                    selectedAnswer = optVal?.answer ?? "";
                  }
                }
              }
            } else {
              //VISA FEES ANSWER
              if (visaFeesSubListValue.isNotEmpty == true &&
                  questionData.answer?.isNotEmpty == true) {
                for (SubclassData? subValue in visaFeesSubListValue) {
                  if (subValue?.id == questionData.answer) {
                    if (subValue?.name?.contains("(") == true) {
                      String? visaName = subValue?.name?.split("(").first;
                      selectedAnswer = visaName ?? "";
                    } else {
                      selectedAnswer = subValue?.name ?? "";
                    }
                  }
                }
              }
            }
            return InkWellWidget(
              onTap: () {
                if (questionData.question != null &&
                    questionData.question!.isNotEmpty &&
                    questionData.type == "Short Text Entry") {
                  bottomSheetVisaFeesWidgetNew(
                      context: context,
                      questionData: questionData,
                      visaFeesBloc: visaFeesBloc,
                      searchController: searchController,
                      isFromDashboard: isFromDashboard);
                } else {
                  bottomSheetWidget(
                      context: context,
                      questionData: questionData,
                      searchController: dropDownSearchController,
                      isFromDashboard: isFromDashboard);
                }
              },
              child: Container(
                height: 35,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 15, right: 10),
                decoration: BoxDecoration(
                  color: AppColorStyle.surface(context),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        (questionData.answer != "" &&
                                questionData.answer?.isNotEmpty == true)
                            ? selectedAnswer
                            : "Select study level",
                        maxLines: 3,
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.primary(context)),
                      ),
                    ),
                    SvgPicture.asset(IconsSVG.arrowDownIcon)
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }

  //BOTTOM SHEET - NEW COMMON
  static bottomSheetWidget(
      {required BuildContext context,
      required CustomQuestions questionData,
      required bool isFromDashboard,
      required TextEditingController searchController}) {
    String firstLetterA = "", firstLetterB = "";

    searchController.text = '';
    CustomQuestionBloc.setOptionsList = questionData.options;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top),
        builder: (appContext) {
          return Container(
            color: AppColorStyle.background(context),
            // height: MediaQuery.of(context).size.height * 0.50,
            child: StreamBuilder(
              stream: CustomQuestionBloc.getOptionListStream,
              // stream: questionData.answerStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var searchedOptionsList = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 20, left: 20, bottom: 10),
                          child: SearchTextField(
                            prefixIcon: IconsSVG.arrowBack,
                            isBackIcon: true,
                            onTextChanged: CustomQuestionBloc.onSearch,
                            onClear: () {
                              searchController.text = '';
                              CustomQuestionBloc.onSearch("");
                            },
                            controller: searchController,
                            searchHintText: StringHelper.searchHere,
                          ),
                        ),
                        questionData.options?.isNotEmpty == true &&
                                searchedOptionsList?.isNotEmpty == true
                            ? Expanded(
                                child: AnimationLimiter(
                                  child: ListView.separated(
                                    itemCount: searchedOptionsList?.length ?? 0,
                                    // itemCount: questionData.options?.length ?? 0,
                                    padding: EdgeInsets.zero,
                                    separatorBuilder: (context, index) {
                                      //sorting of list alphabetically
                                      searchedOptionsList?.sort((a, b) => a
                                          .answer
                                          .toString()
                                          .toLowerCase()
                                          .compareTo(b.answer
                                              .toString()
                                              .toLowerCase()));

                                      if (index ==
                                          (searchedOptionsList?.length ?? 0) -
                                              1) {
                                        return const SizedBox.shrink();
                                      }
                                      firstLetterA =
                                          (searchedOptionsList?[index]
                                                  .answer
                                                  .toString()
                                                  .toUpperCase() ??
                                              "")[0];
                                      firstLetterB =
                                          (searchedOptionsList?[index + 1]
                                                  .answer
                                                  .toString()
                                                  .toUpperCase() ??
                                              "")[0];

                                      if (firstLetterA != firstLetterB) {
                                        printLog(
                                            "firstLetterA:: $firstLetterA");
                                        printLog(
                                            "firstLetterB:: $firstLetterB");
                                        /*return Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 15.0),
                                              child: Text(firstLetterB,  style: AppTextStyle.subTitleSemiBold(
                                                  context, Utility.getRandomBGVisaListScreenColor()),),
                                            ),
                                          ],
                                        );*/
                                      }
                                      return const SizedBox.shrink();
                                    },
                                    itemBuilder: (_, int index) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: SlideAnimation(
                                                  verticalOffset: 50.0,
                                                  child: FadeInAnimation(
                                                      child:
                                                          DropDownSubDataWidget(
                                                    isFromDashboard:
                                                        isFromDashboard,
                                                    options:
                                                        searchedOptionsList?[
                                                            index],
                                                    index: index,
                                                    isLastItem:
                                                        searchedOptionsList
                                                                ?.length ==
                                                            index + 1,
                                                    questionData: questionData,
                                                    firstLetterA: firstLetterA,
                                                    firstLetterB: firstLetterB,
                                                  ))));
                                    },
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: NoDataFoundScreen(
                                    noDataTitle: StringHelper.noDataFound,
                                    noDataSubTitle:
                                        StringHelper.tryAgainWithDiffCriteria,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                } else {
                  return const VisaFeesSubclassShimmer();
                }
              },
            ),
          );
        });
  }

  //bottom sheet of visa fees list
  static bottomSheetVisaFeesWidgetNew(
      {required BuildContext context,
      required CustomQuestions questionData,
      required VisaFeesBloc visaFeesBloc,
      required bool isFromDashboard,
      required TextEditingController searchController}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top),
        builder: (appContext) {
          return StreamBuilder<List<SubclassData>>(
            stream: visaFeesBloc.getVisaSubclassListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data is List<SubclassData>) {
                List<SubclassData> subclassList =
                    snapshot.data as List<SubclassData>;

                ///sorting of list alphabetically [A-Z]
                subclassList.sort((a, b) => a.name
                    .toString()
                    .toLowerCase()
                    .compareTo(b.name.toString().toLowerCase()));

                ///Here we allocate alphabet name [If user search then again allocate alphabet value]
                var arrAlphabetCategory = <AlphabetCategory>[];
                final map = subclassList.groupListsBy((element) => element
                    .alphabet = element.name?.substring(0, 1).toUpperCase());
                map.forEach((key, value) {
                  arrAlphabetCategory
                      .add(AlphabetCategory(alphabet: key, list: value));
                });

                for (AlphabetCategory data in arrAlphabetCategory) {
                  for (int i = 0; i < (data.list?.length ?? 0); i++) {
                    if (i != 0) {
                      ///blank other index alphabet value
                      data.list?[i].alphabet = "";
                    }
                  }
                }

                return Container(
                  color: AppColorStyle.background(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, right: 20, left: 20, bottom: 10),
                        child: SearchTextField(
                          arrowBackTap: () {
                            Navigator.pop(context);
                            searchController.text = '';
                            visaFeesBloc.onSearch("");
                          },
                          prefixIcon: IconsSVG.arrowBack,
                          isBackIcon: true,
                          onTextChanged: visaFeesBloc.onSearch,
                          onClear: () {
                            searchController.text = '';
                            visaFeesBloc.onSearch("");
                          },
                          controller: searchController,
                          searchHintText: StringHelper.visaTypeHintText,
                        ),
                      ),
                      subclassList.isNotEmpty
                          ? Expanded(
                              child: AnimationLimiter(
                                child: ListView.separated(
                                  itemCount: subclassList.length,
                                  padding: EdgeInsets.zero,
                                  separatorBuilder: (context, index) {
                                    if (index == subclassList.length - 1) {
                                      return const SizedBox.shrink();
                                    }
                                    return const SizedBox.shrink();
                                  },
                                  itemBuilder: (_, int index) {
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                                child: VisaSubclassWidget(
                                              subclass: subclassList[index],
                                              index: index,
                                              isLastItem: subclassList.length ==
                                                  index + 1,
                                              onItemClick:
                                                  (SubclassData subclassData) {
                                                visaFeesBloc
                                                        .setSelectedSubClassData =
                                                    subclassData;
                                              },
                                              questionData: questionData,
                                              searchController:
                                                  searchController,
                                              visaFeesBloc: visaFeesBloc,
                                              isFromDashboard: isFromDashboard,
                                            ))));
                                  },
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: NoDataFoundScreen(
                                  noDataTitle: StringHelper.noDataFound,
                                  noDataSubTitle:
                                      StringHelper.tryAgainWithDiffCriteria,
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              } else {
                return const VisaFeesSubclassShimmer();
              }
            },
          );
        });
  }
}

//NEW COMMON DROP-DOWN WIDGET
class DropDownSubDataWidget extends StatelessWidget {
  final CustomQuestionOptions? options;
  final int index;
  final bool isLastItem;
  final CustomQuestions questionData;
  final String firstLetterA, firstLetterB;
  final bool isFromDashboard;

  const DropDownSubDataWidget(
      {super.key,
      required this.options,
      required this.index,
      required this.isLastItem,
      required this.questionData,
      required this.firstLetterA,
      required this.firstLetterB,
      required this.isFromDashboard});

  @override
  Widget build(BuildContext context) {
    String optionName = (options?.answer ?? "").toLowerCase();
    optionName = (options?.answer ?? "");
    printLog("firstLetterA:: $firstLetterA");
    printLog("firstLetterB:: $firstLetterB");

    String firstLetter = (options?.answer ?? "").substring(0, 1).toUpperCase();

    return InkWellWidget(
      onTap: () {
        questionData.setCustomQuestionAnswer(
            "${options?.optionId}", isFromDashboard);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (index == 0)
                    ? SizedBox(
                        width: 30.0,
                        child: Text(
                          // "A",
                          firstLetter,
                          // firstLetterA,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.subTitleSemiBold(
                              context, Colors.red),
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                      ),
                (firstLetterA != firstLetterB && index != 0)
                    ? SizedBox(
                        width: 30.0,
                        child: Text(firstLetterB,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.subTitleSemiBold(context,
                                Utility.getRandomBGVisaListScreenColor())),
                      )
                    : const SizedBox(
                        width: 0,
                      ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: (index == 0 || firstLetterA != firstLetterB)
                            ? 20.0
                            : 50.0),
                    child: Text(
                      optionName,
                      style: AppTextStyle.detailsRegular(
                        context,
                        AppColorStyle.text(context),
                      ),
                    ),
                  ),
                ),
                (questionData.answer ==
                        questionData.options?[index].optionId.toString())
                    ? SvgPicture.asset(IconsSVG.icGreenTick)
                    : const SizedBox(
                        height: 24,
                        width: 24,
                      )
              ],
            ),
            /*Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                optionName,
                style: AppTextStyle.detailsRegular(
                  context,
                  AppColorStyle.textDetail(context),
                ),
              ),
            ),*/
            const SizedBox(
              height: 10.0,
            ),
            isLastItem
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Divider(
                      thickness: 0.5,
                      color: AppColorStyle.surfaceVariant(context),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class VisaSubclassWidget extends StatelessWidget {
  final SubclassData subclass;
  final int index;
  final bool isLastItem;
  final Function onItemClick;
  final CustomQuestions questionData;
  final TextEditingController searchController;
  final VisaFeesBloc visaFeesBloc;
  final bool isFromDashboard;

  const VisaSubclassWidget({
    super.key,
    required this.subclass,
    required this.index,
    required this.isLastItem,
    required this.onItemClick,
    required this.questionData,
    required this.searchController,
    required this.visaFeesBloc,
    required this.isFromDashboard,
  });

  @override
  Widget build(BuildContext context) {
    String subclasscode = "", visatypename = "";
    if (subclass.name != "") {
      String? visaName = CustomQuestionBloc.visaSubTypeName(
          subVisaName: subclass.name, subClassCode: true);
      var visaNameSubString = visaName
          ?.split("+")
          .map((x) => x.trim())
          .where((element) => element.isNotEmpty)
          .toList();
      subclasscode = visaNameSubString![0];
      visatypename = visaNameSubString[1];
    }

    return InkWellWidget(
      onTap: () {
        questionData.setCustomQuestionAnswer(
            subclass.id.toString(), isFromDashboard);
        // questionData.setCustomQuestionAnswer(visatypename);
        Navigator.pop(context);
        searchController.text = '';
        visaFeesBloc.onSearch("");
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30.0,
                  child: Text(subclass.alphabet.toString(),
                      textAlign: TextAlign.center,
                      style: AppTextStyle.subTitleSemiBold(
                          context, subclass.alphabetColor)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Text(
                      subclasscode,
                      style: AppTextStyle.subTitleSemiBold(
                        context,
                        AppColorStyle.text(context),
                      ),
                    ),
                  ),
                ),
                (questionData.answer == subclass.id)
                    ? SvgPicture.asset(IconsSVG.icGreenTick)
                    : const SizedBox(
                        height: 24,
                        width: 24,
                      )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                visatypename,
                style: AppTextStyle.detailsRegular(
                  context,
                  AppColorStyle.textDetail(context),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            isLastItem
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Divider(
                      thickness: 0.5,
                      color: AppColorStyle.surfaceVariant(context),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

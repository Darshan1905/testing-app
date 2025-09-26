import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/visa_fees/model/question_model.dart';
import 'package:occusearch/features/visa_fees/model/visa_subclass_model.dart';
import 'package:occusearch/features/visa_fees/widget/visa_fees_question_widget.dart';

class VisaFeesAddApplicant {
  static showApplicantFormInSheet(BuildContext context,
      {required VisaQuestionApplicantModel questionModel,
      required List<SubclassData> subClassList,
      required Function onSubmit}) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: AppColorStyle.background(context),
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top),
      context: context,
      builder: (context) {
        // UPDATE ANSWER VALUE INTO SubjectBehavior VARIABLE AS DEFAULT
        for (var quesData in questionModel.getQuestionList) {
          quesData.setOptionStream = quesData.selectedOption;
          if (quesData.selectedSubclass != null) {
            quesData.setSubclassStream = quesData.selectedSubclass!;
          }
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                left: Constants.commonPadding,
                right: Constants.commonPadding,
                bottom: Constants.commonPadding,
                top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(questionModel.title,
                          style: AppTextStyle.headlineBold(
                              context, AppColorStyle.text(context))),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    InkWellWidget(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(IconsSVG.closeIcon,
                            colorFilter: ColorFilter.mode(
                            AppColorStyle.text(context),
                      BlendMode.srcIn,
                    ),
                        ))
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // *****************  Question No. 1 [RADIO BUTTON] *****************
                        questionModel.getQuestionList.isNotEmpty &&
                                questionModel.getQuestionList[0].type == "radio"
                            ? VisaRadioButtonWidget(
                                questionModel: questionModel.getQuestionList[0],
                              )
                            : Container(),
                        // *****************  Question No. 2 [RADIO BUTTON] *****************
                        questionModel.getQuestionList.isNotEmpty &&
                                questionModel.getQuestionList.length > 1 &&
                                questionModel.getQuestionList[1].type == "radio"
                            ? StreamBuilder<bool>(
                                stream: questionModel
                                    .getQuestionList[0].selectedOptionStream,
                                builder: (_, snapshot) {
                                  return questionModel
                                              .getQuestionList.isNotEmpty &&
                                          questionModel.getQuestionList.length >
                                              1 &&
                                          questionModel
                                                  .getQuestionList[1].type ==
                                              "radio"
                                      ? VisaRadioButtonWidget(
                                          questionModel:
                                              questionModel.getQuestionList[1],
                                        )
                                      : Container();
                                },
                              )
                            : const SizedBox(),
                        // *****************  Question No. 3 [DROPDOWN] *****************
                        questionModel.getQuestionList.isNotEmpty
                            ? StreamBuilder<bool>(
                                stream: questionModel
                                    .getQuestionList[
                                        questionModel.getQuestionList.length ==
                                                3
                                            ? 1
                                            : 0]
                                    .selectedOptionStream,
                                builder: (_, snapshot) {
                                  if ((questionModel
                                              .getQuestionList.isNotEmpty &&
                                          (questionModel
                                                      .getQuestionList.length ==
                                                  2 &&
                                              questionModel
                                                      .getQuestionList[1].type!
                                                      .toLowerCase() ==
                                                  "dropdown".toLowerCase() &&
                                              questionModel.getQuestionList[0]
                                                      .getSelectedOption ==
                                                  true)) ||
                                      (questionModel.getQuestionList.length ==
                                              3 &&
                                          questionModel.getQuestionList[2].type!
                                                  .toLowerCase() ==
                                              "dropdown".toLowerCase() &&
                                          questionModel.getQuestionList[1]
                                                  .getSelectedOption ==
                                              true)) {
                                    return VisaDropdownWidget(
                                      questionModel: questionModel
                                                      .getQuestionList.length ==
                                                  2 &&
                                              questionModel
                                                      .getQuestionList[1].type!
                                                      .toLowerCase() ==
                                                  "dropdown"
                                          ? questionModel.getQuestionList[1]
                                          : questionModel.getQuestionList
                                                          .length ==
                                                      3 &&
                                                  questionModel
                                                          .getQuestionList[2]
                                                          .type!
                                                          .toLowerCase() ==
                                                      "dropdown"
                                              ? questionModel.getQuestionList[2]
                                              : questionModel
                                                  .getQuestionList[0],
                                      subclassList: subClassList,
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                //FOOTER NEXT BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWellWidget(
                      onTap: () {
                        Navigator.pop(context);
                        onSubmit(questionModel);
                      },
                      child: Container(
                        width: 40.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                            color: AppColorStyle.purpleText(context),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            IconsSVG.rightIcon,
                            colorFilter: ColorFilter.mode(
                              AppColorStyle.purple(context),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

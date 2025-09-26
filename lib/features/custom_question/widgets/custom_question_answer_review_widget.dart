import 'package:go_router/go_router.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/custom_question/custom_question_bloc.dart';
import 'package:occusearch/features/custom_question/model/custom_question_model.dart';
import 'package:occusearch/features/visa_fees/model/visa_subclass_model.dart';

// ignore: must_be_immutable
class CustomQuestionAnswerReviewWidget extends StatelessWidget {
  final List<CustomQuestions>? customQuestionsList;
  bool? isFromEditProfileScreen = false;
  bool? firstAttemptSnapShot;
  final List<SubclassData>? visaFeesSubListValue;

  CustomQuestionAnswerReviewWidget(
      {Key? key,
      required this.customQuestionsList,
      required this.isFromEditProfileScreen,
      required this.firstAttemptSnapShot,
      required this.visaFeesSubListValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 60, bottom: 60),
          itemCount: customQuestionsList?.length ?? 0,
          itemBuilder: (context, index) {
            final item = customQuestionsList![index];
            String? selectedOptionValue;
            var questionIndex = customQuestionsList
                ?.indexWhere((element) => item.question == element.question);
            if (item.type != "Short Text Entry") {
              for (CustomQuestionOptions value in item.options ?? []) {
                if (value.optionId.toString() == item.answer) {
                  selectedOptionValue = value.answer ?? "";
                }
              }
            } else {
              //VISA FEES ANSWER STORE
              List<SubclassData>? visaFeeObject = visaFeesSubListValue
                  ?.where((subList) => (subList.id).toString() == item.answer)
                  .toList();
              if (visaFeeObject?.isNotEmpty == true) {
                selectedOptionValue = CustomQuestionBloc.visaSubTypeName(
                    subVisaName: visaFeeObject?.first.name,
                    subClassCode: false);
              }
            }
            return InkWellWidget(
              onTap: () {
                if (isFromEditProfileScreen == false) {
                  ///particular category redirection and send questionIndex
                  context.pop(questionIndex);
                } else {
                  Map<String, dynamic>? param = {
                    "questionIndex": questionIndex,
                  };
                  GoRoutesPage.go(
                      mode: NavigatorMode.push,
                      moveTo: RouteName.customQuestion,
                      param: param);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Center(
                          child: SvgPicture.asset(
                            IconsSVG.pencilIcon,
                            height: 24.0,
                            width: 24.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40, width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.question ?? "",
                            style: AppTextStyle.captionRegular(
                                context, AppColorStyle.primaryText(context))),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(selectedOptionValue ?? "-",
                            style: AppTextStyle.subTitleSemiBold(
                                context, AppColorStyle.primaryText(context))),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/text_edit_field_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'fund_question_header.dart';

class FundQuestion1Widget extends StatelessWidget {
  final int index;
  final int max;
  final Function onNextClick;
  final FundCalculatorQuestion questionData;

  const FundQuestion1Widget(
      {Key? key,
      required this.index,
      required this.max,
      required this.onNextClick,
      required this.questionData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FundQuestionHeader(
              index: index,
              max: max,
              question: questionData.questionTitle ?? '',
            ),
            const SizedBox(
              height: 30,
            ),
            TextEditFieldWidget(
              initialValue:
                  "${questionData.answerAmount == 0.0 ? '' : questionData.answerAmount}",
              stream: questionData.answerStream,
              maxLength: 8,
              prefixIcon: Text(
                "A\$ ",
                style: AppTextStyle.titleSemiBold(
                    context, AppColorStyle.teal(context)),
              ),
              hintText: StringHelper.courseHintText,
              suffixIcon: StreamWidget(
                  stream: questionData.answerStream,
                  onBuild: (_, snapshotAnswerStreamValue) {
                    return snapshotAnswerStreamValue != ''
                        ? InkWellWidget(
                            onTap: onNextClick,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColorStyle.teal(context),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(40.0))),
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(
                                IconsSVG.arrowRight,
                                colorFilter: ColorFilter.mode(
                                  AppColorStyle.background(context),
                                  BlendMode.srcIn,
                                ),
                                width: 14.0,
                              ),
                            ),
                          )
                        : Container();
                  }),
              onTextChanged: (text) => questionData.setAnswer(
                  text,
                  text.isNotEmpty && !text.toString().contains(",")
                      ? double.parse(text)
                      : 0.0),
              keyboardKey: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

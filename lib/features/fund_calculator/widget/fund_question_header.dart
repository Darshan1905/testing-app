import 'package:occusearch/constants/constants.dart';

class FundQuestionHeader extends StatelessWidget {
  final int index;
  final int max;
  final String question;
  final bool? showMultiSelection;

  const FundQuestionHeader(
      {Key? key,
        required this.index,
        required this.max,
        required this.question,
        this.showMultiSelection = false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Text(
          question,
          style: AppTextStyle.subTitleRegular(
            context,
            AppColorStyle.textDetail(context),
          ),
        ),
        SizedBox(
          height: showMultiSelection == true ? 5.0 : 0,
        ),
        Visibility(
          visible: showMultiSelection == true,
          child: Text(
            StringHelper.multiSelectionText,
            style: AppTextStyle.captionRegular(
              context,
              AppColorStyle.teal(context),
            ),
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
      ],
    );
  }
}

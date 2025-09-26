import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';

class CityOptionWidget extends StatelessWidget {
  final BuildContext context;
  final LivingCostOptions selectedOption;

  const CityOptionWidget(
      {Key? key, required this.context, required this.selectedOption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: " ${selectedOption.option ?? ''} ",
        style: AppTextStyle.subTitleRegular(
          context,
          selectedOption.isSelected
              ? AppColorStyle.textWhite(context)
              : AppColorStyle.textDetail(context),
        ),
      ),
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout();
    final double width = textPainter.size.width;
    // printLog(("Width==>$width"));
    return IntrinsicWidth(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        width: width > 65 ? width * 1.5 : width * 1.7,
        decoration: BoxDecoration(
          color: selectedOption.isSelected
              ? AppColorStyle.teal(context)
              : AppColorStyle.backgroundVariant(context),
          borderRadius: const BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: selectedOption.isSelected == true,
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1, color: AppColorStyle.textWhite(context))),
              ),
            ),
            Padding(
              padding: selectedOption.isSelected == true
                  ? const EdgeInsets.only(right: 8)
                  : const EdgeInsets.only(right: 0),
              child: Text(
                " ${selectedOption.option ?? ''} ",
                textAlign: selectedOption.isSelected == true
                    ? TextAlign.end
                    : TextAlign.center,
                style: AppTextStyle.subTitleRegular(
                  context,
                  selectedOption.isSelected
                      ? AppColorStyle.textWhite(context)
                      : AppColorStyle.textDetail(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

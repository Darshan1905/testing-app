import 'package:occusearch/constants/constants.dart';

class FundProgressBar extends StatelessWidget {
  final int index;
  final int max;

  const FundProgressBar({Key? key, required this.index, required this.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double value = (index + 1) / max;
    return SizedBox(
      height: 3.0,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: ((index).isInfinite || (index).isNaN) &&
                (max.isInfinite || max.isNaN)
            ? Container()
            : TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: value),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) => LinearProgressIndicator(
                  minHeight: 5.0,
                  value: max == 0 ? 0.0 : value,
                  backgroundColor: AppColorStyle.surfaceVariant(context),
                  // valueColor: AlwaysStoppedAnimation<Color>(AppColorStyle.blueOrRed(context)),
                  color: AppColorStyle.teal(context),
                ),
              ),
      ),
    );
  }
}

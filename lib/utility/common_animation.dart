import 'package:occusearch/constants/constants.dart';

AnimatedContainer animatedPageDot(BuildContext context, int currentPage,
    {required bool isBgBlue, int? index}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 800),
    margin: const EdgeInsets.only(right: 5),
    height: 5,
    width: currentPage == index ? 30 : 10,
    decoration: BoxDecoration(
      color: currentPage == index
          ? AppColorStyle.primary(context)
          : AppColorStyle.textCaption(context),
    ),
  );
}

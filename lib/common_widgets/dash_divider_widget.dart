// ignore_for_file: must_be_immutable
import 'package:occusearch/constants/constants.dart';

/*
*     Reference Link:  https://stackoverflow.com/a/69566783
* */

class DashDividerWidget extends StatelessWidget {
  double? dashHeight;
  double? dashWith;
  Color? dashColor;
  double? fillRate; // [0, 1] totalDashSpace/totalSpace
  Axis? direction;

  DashDividerWidget(
      {super.key, this.dashHeight = 0.5,
      this.dashWith = 8,
      this.dashColor = Colors.black,
      this.fillRate = 0.6,
      this.direction = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxSize = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dCount = (boxSize * fillRate! / dashWith!).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction!,
          children: List.generate(dCount, (_) {
            return SizedBox(
              width: direction == Axis.horizontal ? dashWith : dashHeight,
              height: direction == Axis.horizontal ? dashHeight : dashWith,
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: AppColorStyle.primaryText(context)),
              ),
            );
          }),
        );
      },
    );
  }
}

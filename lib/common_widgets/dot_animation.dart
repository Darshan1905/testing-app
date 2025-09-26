import 'package:occusearch/constants/constants.dart';

class DotAnimation extends StatefulWidget {
  final BuildContext? context;
  final int? currentPage, index;
  final double height;
  final double width;
  final int animationDuration;
  final Color? primaryColor;

  const DotAnimation({
    super.key,
    this.context,
    this.currentPage,
    this.index,
    this.height = 6,
    this.width = 40.0,
    this.animationDuration = 800,
    this.primaryColor,
  });

  @override
  DotAnimationState createState() => DotAnimationState();
}

class DotAnimationState extends State<DotAnimation> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          height: widget.height,
          width:
              widget.currentPage == widget.index ? widget.width : widget.height,
          decoration: BoxDecoration(
            color: AppColorStyle.surfaceVariant(context),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        AnimatedContainer(
          margin: const EdgeInsets.only(right: 8),
          height: widget.height,
          width:
              widget.currentPage == widget.index ? widget.width : widget.height,
          decoration: BoxDecoration(
            color: widget.currentPage == widget.index
                ? widget.primaryColor ?? AppColorStyle.primary(context)
                : AppColorStyle.surfaceVariant(context),
            borderRadius: BorderRadius.circular(1),
          ),
          duration: Duration(
              milliseconds: widget.currentPage == widget.index
                  ? widget.animationDuration
                  : 0),
        ),
      ],
    );
  }
}

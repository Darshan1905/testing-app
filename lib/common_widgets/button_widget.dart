import 'package:occusearch/constants/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color? buttonColor;
  final Color? textColor;
  final Color? arrowIconColor;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final bool? arrowIconVisibility;
  final TextStyle? titleTextStyle;

  // Firebase event log variable
  final String logActionEvent;
  final String? logSectionName;
  final String? logSubSectionName;
  final String? logMessage;
  final String? logOther;

  const ButtonWidget(
      {super.key,
      required this.title,
      required this.onTap,
      required this.logActionEvent,
      this.buttonColor,
      this.logSectionName,
      this.logSubSectionName,
      this.logMessage,
      this.logOther,
      this.arrowIconColor,
      this.textColor,
      this.prefixIcon,
      this.prefixIconColor,
      this.arrowIconVisibility = true,
      this.titleTextStyle});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: key,
        onTap: () {
          // Firebase event log
          FirebaseAnalyticLog.shared.eventTracking(
              screenName: GoRouterConfig.router.location,
              actionEvent: logActionEvent,
              sectionName: logSectionName,
              subSectionName: logSubSectionName,
              message: logMessage,
              other: logOther);
          // onClick function
          onTap();
        },
        child: Ink(
          decoration: BoxDecoration(
              color: buttonColor ?? AppColorStyle.primary(context),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              prefixIcon != null ? prefixIcon! : Container(),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: titleTextStyle ??
                    AppTextStyle.subTitleMedium(
                      context,
                      textColor ?? AppColorStyle.textWhite(context),
                    ),
              ),
              const Spacer(),
              Visibility(
                visible: arrowIconVisibility ?? true,
                child: SvgPicture.asset(
                  IconsSVG.arrowRight,
                  colorFilter: ColorFilter.mode(
                    arrowIconColor ??
                        (textColor ?? AppColorStyle.textWhite(context)),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

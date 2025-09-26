import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color? bgColor;
  final String? title;
  final String message;
  final String? positiveBtnText;
  final String? negativeBtnText;
  final Function? onPositivePressed;
  final Function? onNegativePressed;
  final double? circularBorderRadius;
  final bool? isDismissible;
  final Color? buttonColor;
  final bool? isFromAppUpdate;

  const CustomAlertDialog(
      {super.key,
      this.title,
      required this.message,
      this.circularBorderRadius = 15.0,
      this.isDismissible,
      this.bgColor = Colors.white,
      this.positiveBtnText = StringHelper.okay,
      this.negativeBtnText = StringHelper.cancel,
      this.onPositivePressed,
      this.onNegativePressed,
      this.buttonColor,
      this.isFromAppUpdate})
      : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    return WillPopScopeWidget(
      onWillPop: () async {
        return isDismissible ?? true;
      },
      child: AlertDialog(
        icon: Visibility(
          visible: isFromAppUpdate ?? false,
          child: Image.asset(
            IconsWEBP.occusearchLogo,
            width: 60.0,
            height: 60.0,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        title: title != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(title ?? '',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.subHeadlineBold(
                        context, AppColorStyle.text(context))),
              )
            : null,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(message,
                textAlign: TextAlign.center,
                style: AppTextStyle.detailsRegular(
                    context, AppColorStyle.textDetail(context))),
            const SizedBox(
              height: 20,
            ),
            positiveBtnText != null
                ? SizedBox(
                    height: 45,
                    child: InkWellWidget(
                      onTap: () {
                        if (onPositivePressed != null) {
                          onPositivePressed!();
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                            color:
                                buttonColor ?? AppColorStyle.primary(context),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              positiveBtnText ?? "",
                              style: AppTextStyle.subTitleMedium(
                                context,
                                AppColorStyle.textWhite(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 20,
            ),
            negativeBtnText != null
                ? InkWellWidget(
                    child: Text(negativeBtnText ?? '',
                        style: AppTextStyle.detailsMedium(
                            context, AppColorStyle.textHint(context))),
                    onTap: () {
                      if (onNegativePressed != null) {
                        onNegativePressed!();
                      }
                    },
                  )
                : Container(),
          ],
        ),
        backgroundColor: bgColor,
        scrollable: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circularBorderRadius ?? 10)),
      ),
    );
  }
}

import 'package:occusearch/constants/constants.dart';

/// toast
class Toast {
  static const int toastLengthShort = 1;
  static const int toastLengthLong = 2;

  /*  static const int toastBottom = 0;
  static const int toastCenter = 1;*/ // by default toast will be shown at top

  static const int toastTop = 2;
  static const int toastError = -1;
  static const int toastNormal = 0;
  static const int toastSuccess = 1;

  static void show(BuildContext context,
      {required String message,
      int type = toastNormal,
      int duration = 2,
      int gravity = toastTop,
      double backgroundRadius = 5.0}) {
    ToastView.dismiss();
    ToastView.createView(
        message,
        context,
        type,
        duration,
        gravity,
        AppColorStyle.text(context),
        AppColorStyle.textWhite(context),
        backgroundRadius);
  }
}

class ToastView {
  static final ToastView _singleton = ToastView._internal();

  factory ToastView() {
    return _singleton;
  }

  ToastView._internal();

  static OverlayState? overlayState;
  static OverlayEntry? overlayEntry;
  static bool _isVisible = false;

  static void createView(
      String msg,
      BuildContext context,
      int type,
      int duration,
      int gravity,
      Color background,
      Color textColor,
      double backgroundRadius) async {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
          widget: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: type == 1
                      ? AppColorStyle.tealText(context)
                      : type == 0
                          ? AppColorStyle.tealText(context)
                          : AppColorStyle.redText(context),
                  borderRadius: BorderRadius.circular(backgroundRadius),
                 ),
                constraints: const BoxConstraints(minHeight: 40, minWidth: 210),
                child: _buildContent(type, msg, textColor, context),
              ),
            ),
          ),
          gravity: gravity),
    );
    _isVisible = true;
    overlayState?.insert(overlayEntry!);
    await Future.delayed(
        Duration(seconds: duration, milliseconds: duration == 1 ? 500 : 0));
    dismiss();
  }

  static Widget _buildContent(
      int type, String msg, Color textColor, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SvgPicture.asset(
          type == 1
              ? IconsSVG.successToastIcon
              : type == 0
                  ? IconsSVG.successToastIcon
                  : IconsSVG.errorToastIcon,
          width: 20,
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16.0, right: 10),
        ),
        Flexible(
          child: Text(msg,
              maxLines: 20,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.captionRegular(
                  context,
                  type == 1
                      ? AppColorStyle.teal(context)
                      : type == 0
                          ? AppColorStyle.teal(context)
                          : AppColorStyle.red(context))),
        )
      ],
    );
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    if (overlayEntry != null) overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  const ToastWidget({
    Key? key,
    required this.widget,
    required this.gravity,
  }) : super(key: key);

  final Widget widget;
  final int gravity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: gravity == 2 ? 50 : null,
        bottom: gravity == 0 ? 50 : null,
        child: widget);
  }
}

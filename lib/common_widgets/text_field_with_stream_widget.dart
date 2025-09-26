import 'package:occusearch/constants/constants.dart';

class TextFieldWithStreamWidget extends StatelessWidget {
  final Stream<String> stream;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? textBackgroundColor;
  final Function? onTap;
  final bool? fromOccupationDashboard;

  const TextFieldWithStreamWidget({
    super.key,
    required this.stream,
    this.hintText = '',
    this.suffixIcon,
    this.prefixIcon,
    this.textBackgroundColor,
    this.onTap,
    this.fromOccupationDashboard = false,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color:
                textBackgroundColor ?? AppColorStyle.backgroundVariant(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              prefixIcon ?? const SizedBox(),
              SizedBox(width: prefixIcon == null ? 0.0 : 12.0),
              Expanded(
                child: InkWellWidget(
                  onTap: () {
                    if (onTap != null) {
                      onTap!();
                    }
                  },
                  child: Text(
                    snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data != ""
                        ? "${snapshot.data}"
                        : hintText,
                    style: fromOccupationDashboard == true
                        ? AppTextStyle.titleMedium(
                            context, AppColorStyle.textHint(context))
                        : AppTextStyle.titleMedium(
                            context, AppColorStyle.text(context)),
                  ),
                ),
              ),
              SizedBox(width: suffixIcon == null ? 0.0 : 12.0),
              suffixIcon ?? const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

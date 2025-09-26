import 'package:occusearch/constants/constants.dart';

class TextFormFieldWidget extends StatelessWidget {
  final Stream<String> stream;
  final TextEditingController? controller;
  final String hintText;
  final TextStyle? hintStyle;
  final TextInputType keyboardKey;
  final Function(String) onTextChanged;
  final bool isPassword; // TRUE if Field is Password else FALSE default
  final bool isErrorShow;
  final int maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final bool isShowErrorWidget;
  final Color? txtBgColor;
  final TextAlign textAlign;
  final String? initialValue;
  final bool? readOnly;
  final Function? onTap;

  const TextFormFieldWidget(
      {super.key,
      required this.stream,
      required this.onTextChanged,
      this.controller,
      this.keyboardKey = TextInputType.text,
      this.isPassword = false,
      this.isErrorShow = true,
      this.hintText = "",
      this.maxLength = 40,
      this.suffixIcon,
      this.prefixIcon,
      this.focusNode,
      this.isShowErrorWidget = true,
      this.readOnly = false,
      this.txtBgColor,
      this.hintStyle,
      this.textAlign = TextAlign.left,
      this.initialValue = "",
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Column(
          children: [
            TextFormField(
              initialValue: initialValue,
              key: key,
              focusNode: focusNode,
              onChanged: (text) => onTextChanged(text),
              style: AppTextStyle.titleMedium(
                context,
                AppColorStyle.text(context),
              ),
              obscureText: isPassword,
              keyboardType: keyboardKey,
              maxLength: maxLength,
              readOnly: readOnly ?? false,
              onTap: () {
                if (onTap != null) {
                  onTap;
                }
              },
              maxLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor:
                    txtBgColor ?? AppColorStyle.backgroundVariant(context),
                hintText: hintText,
                counterText: "",
                hintStyle: hintStyle ??
                    AppTextStyle.subTitleRegular(
                        context, AppColorStyle.textHint(context)),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 18.0),
              ),
            ),
            const SizedBox(
              height: 3.0,
            ),
            Visibility(
              visible: isShowErrorWidget,
              child: Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 5),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      isErrorShow
                          ? snapshot.error == null
                              ? ""
                              : snapshot.error.toString()
                          : "",
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.red(context)),
                      key: ValueKey<String>(snapshot.data ?? "textKey"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:occusearch/constants/constants.dart';

class TextFieldWidget extends StatelessWidget {
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
  final bool readOnly;
  final Function? onTap;

  const TextFieldWidget(
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
      this.txtBgColor,
      this.hintStyle,
      this.textAlign = TextAlign.left,
      this.readOnly = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Column(
          children: [
            TextField(
              readOnly: readOnly,
              key: key,
              controller: controller,
              focusNode: focusNode,
              onChanged: (text) => onTextChanged(text),
              style: AppTextStyle.titleMedium(
                context,
                AppColorStyle.text(context),
              ),
              onTap: () {
                if (onTap != null) {
                  onTap;
                }
              },
              obscureText: isPassword,
              keyboardType: keyboardKey,
              maxLength: maxLength,
              maxLines: 1,
              textAlign: textAlign,
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

class TextFieldWithoutStreamWidget extends StatelessWidget {
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
  final bool readOnly;
  final Function? onTap;

  const TextFieldWithoutStreamWidget(
      {super.key,
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
      this.txtBgColor,
      this.hintStyle,
      this.textAlign = TextAlign.left,
      this.readOnly = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      key: key,
      controller: controller,
      focusNode: focusNode,
      onChanged: (text) => onTextChanged(text),
      style: AppTextStyle.titleMedium(
        context,
        AppColorStyle.text(context),
      ),
      onTap: () {
        if (onTap != null) {
          onTap;
        }
      },
      obscureText: isPassword,
      keyboardType: keyboardKey,
      maxLength: maxLength,
      maxLines: 1,
      textAlign: textAlign,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        fillColor: txtBgColor ?? AppColorStyle.backgroundVariant(context),
        hintText: hintText,
        counterText: "",
        hintStyle: hintStyle ??
            AppTextStyle.subTitleRegular(
                context, AppColorStyle.textHint(context)),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
      ),
    );
  }
}

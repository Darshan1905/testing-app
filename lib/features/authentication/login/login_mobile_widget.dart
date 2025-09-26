import 'package:occusearch/constants/constants.dart';

class MobileTextFieldWidget extends StatelessWidget {
  final Stream<String> stream;
  final String hintText;
  final String initialValue;
  final TextInputType keyboardKey;
  final Function(String) onTextChanged;
  final bool isPassword; // TRUE if Field is Password else FALSE default
  final bool isErrorShow;
  final bool? readOnly;
  final int maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;

  const MobileTextFieldWidget(
      {super.key,
      required this.stream,
      required this.onTextChanged,
      this.keyboardKey = TextInputType.text,
      this.isPassword = false,
      this.isErrorShow = true,
      this.hintText = "",
      this.initialValue = "",
      this.readOnly = false,
      this.maxLength = 14,
      this.suffixIcon,
      this.prefixIcon,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Column(
          children: [
            TextFormField(
              key: key,
              initialValue: initialValue,
              focusNode: focusNode,
              onChanged: (text) => onTextChanged(text),
              style: AppTextStyle.titleMedium(
                context,
                readOnly == true
                    ? AppColorStyle.textHint(context)
                    : AppColorStyle.text(context),
              ),
              readOnly: readOnly ?? false,
              obscureText: isPassword,
              keyboardType: keyboardKey,
              maxLength: maxLength,
              maxLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: AppColorStyle.backgroundVariant(context),
                hintText: hintText,
                counterText: "",
                hintStyle: AppTextStyle.subTitleRegular(
                  context,
                  AppColorStyle.textHint(context),
                ),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 18.0),
              ),
            ),
            SizedBox(height: isErrorShow ? 3.0 : 0.0),
            isErrorShow
                ? Container(
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
                  )
                : const SizedBox(),
            SizedBox(height: isErrorShow ? 5.0 : 0.0),
          ],
        );
      },
    );
  }
}

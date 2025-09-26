import 'package:occusearch/constants/constants.dart';

class TextEditFieldWidget extends StatelessWidget {
  final Stream<String> stream;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function? onTextChanged;
  final TextInputType? keyboardKey;
  final int? maxLength;
  final String? initialValue;
  final bool? isErrorShow;
  final bool isShowErrorWidget;

  const TextEditFieldWidget(
      {super.key,
      required this.stream,
      this.isShowErrorWidget = true,
      this.hintText = '',
      this.suffixIcon,
      this.onTextChanged,
      this.prefixIcon,
      this.keyboardKey,
      this.maxLength,
      this.initialValue,
      this.isErrorShow = true});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: AppColorStyle.backgroundVariant(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  prefixIcon ?? const SizedBox(),
                  SizedBox(width: prefixIcon == null ? 0.0 : 12.0),
                  Expanded(
                    child: TextFormField(
                      initialValue: initialValue,
                      maxLength: maxLength,
                      style: AppTextStyle.detailsRegular(
                          context, AppColorStyle.text(context)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColorStyle.backgroundVariant(context),
                        counterText: "",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 0.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        hintText: hintText,
                        hintStyle: AppTextStyle.detailsRegular(
                            context, AppColorStyle.textHint(context)),
                      ),
                      onChanged: (text) => onTextChanged!(text),
                      keyboardType: keyboardKey,
                    ),
                  ),
                  SizedBox(width: suffixIcon == null ? 0.0 : 12.0),
                  suffixIcon ?? const SizedBox(),
                ],
              ),
              Visibility(
                visible: snapshot.error == true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 5),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        isErrorShow!
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
          ),
        );
      },
    );
  }
}

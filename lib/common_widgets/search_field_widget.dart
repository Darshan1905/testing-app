import 'package:occusearch/constants/constants.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onTextChanged;
  final Function onClear;
  final Function? onFilterTap;
  final String searchHintText;
  final String? prefixIcon;
  final bool isBackIcon;
  final bool isBackIconVisible;
  final bool isFilterIcon;
  final bool isFilterAppliedOrNot;
  final Function? arrowBackTap;

  const SearchTextField(
      {super.key,
      required this.controller,
      required this.onTextChanged,
      required this.onClear,
      this.onFilterTap,
      this.searchHintText = '',
      this.prefixIcon,
      this.isBackIcon = false,
      this.isFilterIcon = false,
      this.arrowBackTap,
      this.isBackIconVisible = true,
      this.isFilterAppliedOrNot = false});

  @override
  Widget build(BuildContext context) {
    double iconSize = isBackIcon ? 20 : 16;
    return TextField(
      key: key,
      onChanged: (searchText) => onTextChanged(searchText),
      cursorColor: AppColorStyle.text(context),
      controller: controller,
      style: AppTextStyle.detailsRegular(context, AppColorStyle.text(context)),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
        filled: true,
        fillColor: AppColorStyle.backgroundVariant(context),
        hintText: searchHintText,
        hintStyle: TextStyle(color: AppColorStyle.textHint(context)),
        prefixIcon: isBackIconVisible
            ? prefixIcon != null
                ? IconButton(
                    onPressed: () {
                      if (arrowBackTap != null) {
                        arrowBackTap!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: SvgPicture.asset(prefixIcon ?? IconsSVG.arrowBack,
                        height: iconSize,
                        width: iconSize,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        )),
                  )
                : null
            : null,
        suffixIcon: isFilterIcon
            ? IconButton(
                onPressed: () => onFilterTap!(),
                icon: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFilterAppliedOrNot
                            ? AppColorStyle.red(context)
                            : Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SvgPicture.asset(
                        IconsSVG.filterIcon,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : IconButton(
                onPressed: () => onClear(),
                icon: SvgPicture.asset(IconsSVG.cross, height: 14, width: 14),
              ),
      ),
    );
  }
}

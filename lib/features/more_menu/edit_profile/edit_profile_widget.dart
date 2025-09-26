import 'package:occusearch/constants/constants.dart';

class EditProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String email;
  final String mobile;
  final String dialCode;

  const EditProfileHeaderWidget(
      {Key? key,
      required this.name,
      required this.email,
      required this.mobile,
      required this.dialCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: AppColorStyle.purpleText(context)),
          child: Text(
            Utility.getInitials(name),
            style: AppTextStyle.subHeadlineSemiBold(
                context, AppColorStyle.purple(context)),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          Utility.capitalizeAllWords(name),
          style: AppTextStyle.subHeadlineSemiBold(
              context, AppColorStyle.text(context)),
        ),
        (mobile == "" && mobile.isEmpty)
            ? Text(
                email.toString(),
                style: AppTextStyle.captionRegular(
                    context, AppColorStyle.textDetail(context)),
              )
            : Text(
                "$dialCode $mobile",
                style: AppTextStyle.captionRegular(
                    context, AppColorStyle.textDetail(context)),
              )
      ],
    );
  }
}

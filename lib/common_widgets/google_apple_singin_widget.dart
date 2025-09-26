import 'package:occusearch/constants/constants.dart';

class GoogleAppleSignInWidget extends StatelessWidget {
  final Function onTap;
  final bool isGoogle;

  const GoogleAppleSignInWidget(
      {super.key, required this.onTap, required this.isGoogle});

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      logActionEvent: FBActionEvent.fbActionContinueWithGoogle,
      logSectionName: FBSectionEvent.fbSectionLogin,
      onTap: () {
        onTap();
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColorStyle.backgroundVariant(context),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isGoogle ? IconsSVG.googleIcon : IconsSVG.appleIcon,
                width: 20,
                height: 20,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Continue with ${isGoogle ? 'Google' : 'Apple'}",
                    style: AppTextStyle.subTitleMedium(
                        context, AppColorStyle.text(context)),
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

import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:rive/rive.dart';

class ModuleOnBoardingScreen extends StatelessWidget {
  final String? backgroundIcon,
      riveIcon,
      title,
      subtitle,
      detail,
      buttonText;

  final Color? backgroundIconColor,
      titleColor,
      subtitleColor,
      detailColor,
      buttonColor;

  final Function onTap;

  const ModuleOnBoardingScreen({
    Key? key,
    required this.backgroundIcon,
    required this.riveIcon,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.buttonText,
    required this.backgroundIconColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.detailColor,
    required this.buttonColor,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColorStyle.background(context),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              backgroundIcon!,
              colorFilter: ColorFilter.mode(
                backgroundIconColor!,
                BlendMode.srcIn,
              ),
              width: MediaQuery.of(context).size.width / 4.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: RiveAnimation.asset(riveIcon!),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        title!,
                        style: AppTextStyle.headlineBold(
                          context,
                          titleColor!,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style:
                            AppTextStyle.headlineBold(context, subtitleColor!),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        detail!,
                        style: AppTextStyle.subTitleRegular(
                          context,
                          detailColor!,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonWidget(
                      buttonColor: buttonColor,
                      onTap: onTap,
                      title: buttonText!,
                      logActionEvent: "",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        GoRoutesPage.go(
                            mode: NavigatorMode.remove,
                            moveTo: RouteName.home);
                        // Navigator.pop(context);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            StringHelper.willDoIt,
                            style: AppTextStyle.subTitleMedium(
                                context, AppColorStyle.textHint(context)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/get_my_policy/gmp_bloc.dart';

class GetMyPolicyWelcomePage extends BaseApp {
  const GetMyPolicyWelcomePage({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => GetMyPolicyWelcomePageState();
}

class GetMyPolicyWelcomePageState extends BaseState {
  GetMyPolicyBloc getMyPolicyBloc = GetMyPolicyBloc();

  @override
  init() {}

  @override
  Widget body(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColorStyle.background(context),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: double.infinity,
              child:
                  SvgPicture.asset(IconsSVG.bgTopHeaderBlue, fit: BoxFit.fill),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(IconsSVG.getMyPolicyLogo,
                          height: 50, width: 50),
                      const SizedBox(height: 25),
                      Text(
                        "Get your",
                        style: TextStyle(
                          color: AppColorStyle.text(context),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Health Insurance",
                        style: TextStyle(
                          color: AppColorStyle.green(context),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Your Hassle-Free OSHC/OVHC Coverage in Australia!",
                        style: AppTextStyle.detailsRegular(
                            context, AppColorStyle.textCaption(context)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                ButtonWidget(
                  buttonColor: AppColorStyle.primary(context),
                  onTap: onTap,
                  title: StringHelper.ovhcPolicy,
                  logActionEvent: "",
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                  buttonColor: AppColorStyle.green(context),
                  onTap: onTapOSHC,
                  title: StringHelper.oshcPolicy,
                  logActionEvent: "",
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    GoRoutesPage.go(
                        mode: NavigatorMode.remove, moveTo: RouteName.home);
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  onResume() {}

  onTap() {
    GoRoutesPage.go(mode: NavigatorMode.push, moveTo: RouteName.gmpOVHCScreen);
  }

  onTapOSHC() {
    GoRoutesPage.go(mode: NavigatorMode.push, moveTo: RouteName.gmpOSHCScreen);
  }
}

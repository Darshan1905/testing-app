import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/module_onboarding/module_onboarding_screen.dart';

class VisaFeesScreen extends BaseApp {
  const VisaFeesScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _VisaFeesScreenScreenState();
}

class _VisaFeesScreenScreenState extends BaseState {
  @override
  init() {}

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return ModuleOnBoardingScreen(
        backgroundIcon: IconsSVG.visaFeesBackgroundImage,
        riveIcon: RiveAssets.visaFees,
        title: StringHelper.calculateYour,
        subtitle: StringHelper.visaFees,
        detail: StringHelper.betterToStayPrepared,
        buttonText: StringHelper.letsStart,
        onTap: () {
          GoRoutesPage.go(
              mode: NavigatorMode.replace,
              moveTo: RouteName.visaFeesSubclassScreen);
        },
        backgroundIconColor: AppColorStyle.purple(context),
        titleColor: AppColorStyle.text(context),
        subtitleColor: AppColorStyle.purple(context),
        detailColor: AppColorStyle.purpleVariant1(context),
        buttonColor: AppColorStyle.purple(context));
  }
}

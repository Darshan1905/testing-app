import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/module_onboarding/module_onboarding_screen.dart';

class FundCalculatorOnBoardingScreen extends BaseApp {
  const FundCalculatorOnBoardingScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _FundCalculatorOnBoardingScreenState();
}

class _FundCalculatorOnBoardingScreenState extends BaseState {
  @override
  init() {}

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return ModuleOnBoardingScreen(
        backgroundIcon: IconsSVG.fundCalcBackgroundImage,
        riveIcon: RiveAssets.fundCalculator,
        title: StringHelper.checkExpense,
        subtitle: StringHelper.fundCalc,
        detail: StringHelper.forStudent,
        buttonText: StringHelper.letsStart,
        onTap: () {
          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.fundCalculatorQuestions);
        },
        backgroundIconColor: AppColorStyle.teal(context),
        titleColor: AppColorStyle.text(context),
        subtitleColor: AppColorStyle.teal(context),
        detailColor: AppColorStyle.tealVariant1(context),
        buttonColor: AppColorStyle.teal(context));
  }
}

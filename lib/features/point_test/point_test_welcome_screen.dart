import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/module_onboarding/module_onboarding_screen.dart';

class PointTestWelcomeScreen extends BaseApp {
  const PointTestWelcomeScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _PointTestWelcomeScreenState();
}

class _PointTestWelcomeScreenState extends BaseState {
  @override
  init() {}

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return ModuleOnBoardingScreen(
        backgroundIcon: IconsSVG.pointCalcBackgroundImage,
        riveIcon: RiveAssets.pointCalculator,
        title: StringHelper.heyLetsTake,
        subtitle: StringHelper.pointScoreTest,
        detail: StringHelper.gsmPointsCalculator,
        buttonText: StringHelper.letsStart,
        onTap: () {
          Map<String, dynamic> param = {
            "mode": PointTestMode.NEW_TEST,
            "question_ID": 0,
            "from_where": PointTestReviewType.DASHBOARD
          };
          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.pointTestQuestionScreen,
              param: param);
        },
        backgroundIconColor: AppColorStyle.cyan(context),
        titleColor: AppColorStyle.text(context),
        subtitleColor: AppColorStyle.cyan(context),
        detailColor: AppColorStyle.cyanVariant1(context),
        buttonColor: AppColorStyle.cyan(context));
  }
}

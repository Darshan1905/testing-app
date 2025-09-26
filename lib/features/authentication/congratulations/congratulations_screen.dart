import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:rive/rive.dart';

class CongratulationsScreen extends BaseApp {
  const CongratulationsScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _CongratulationsState();
}

class _CongratulationsState extends BaseState {
  final Duration animationDuration =
      const Duration(seconds: 5); //duration of animation
  final double height = 50;

  //double width = MediaQuery.of(context).size.width /1.2;
  final double borderRadius = 5.0;
  double animatedWidth = 0.0;

  @override
  init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 1), () {
        //delay of 1 seconds to start the animation
        setState(() {
          animatedWidth = MediaQuery.of(context).size.width / 1.2;
        });
      });

      /*
      TODO : CUSTOM QUESTION hide in this version
      Future.delayed(const Duration(seconds: 6), () {
        Map<String, dynamic> param = {
          "isFromCreateAccount" : true,
        };
        //1(for start animation)+5(Animation time) = 6 seconds.
        if(GoRouterConfig.router.location != "\/${RouteName.customQuestionOnboarding}"){
          GoRoutesPage.go(mode: NavigatorMode.remove, moveTo: RouteName.customQuestionOnboarding,param: param);
        }
      });*/
    });
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: AppColorStyle.background(context),
        padding: const EdgeInsets.only(
            right: 30.0, left: 30.0, bottom: 30.0, top: 30.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.2,
                    width: MediaQuery.of(context).size.height / 2.2,
                    child: const RiveAnimation.asset(
                      RiveAssets.congratulations,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    StringHelper.congratulationTitle,
                    style: AppTextStyle.extraBold(
                        context, AppColorStyle.text(context)),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    StringHelper.congratulationSubTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.subTitleRegular(
                        context, AppColorStyle.textDetail(context)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            //animatedButton(),
            ButtonWidget(
              title: "Continue to Dashboard",
              onTap: () {
                globalBloc!.isShowDialogSubscription = false;
                GoRoutesPage.go(
                    mode: NavigatorMode.remove, moveTo: RouteName.home);
              },
              logActionEvent: FBActionEvent.fbActionLetsGo,
            ),
            const SizedBox(
              height: 50.0,
            ),
            /*Center(
              child: InkWellWidget(
                onTap: () => GoRoutesPage.go(
                    mode: NavigatorMode.remove, moveTo: RouteName.home),
                child: Text(
                  StringHelper.willDoIt,
                  style: AppTextStyle.subTitleMedium(
                    context,
                    AppColorStyle.textHint(context),
                  ),
                ),
              ),
            ),*/
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  animatedButton() {
    //for button animation.
    return Stack(
      children: [
        Container(
          height: height,
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
            color: AppColorStyle.primary(context),
          ),
        ),
        AnimatedContainer(
          duration: animationDuration,
          height: height,
          width: animatedWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
            color: Colors.white.withOpacity(0.15),
          ),
        ),
        InkWellWidget(
          child: Container(
            height: height,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
              color: Colors.transparent,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Let's Start",
                      style: AppTextStyle.detailsMedium(
                        context,
                        AppColorStyle.textWhite(context),
                      )),
                  const Spacer(),
                  SvgPicture.asset(
                    IconsSVG.arrowRight,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.textWhite(context),
                      BlendMode.srcIn,
                    ),
                  )
                ],
              ),
            ),
          ),
          onTap: () {
            Map<String, dynamic> param = {
              "isFromCreateAccount": true,
            };

            ///redirect to custom question.
            GoRoutesPage.go(
                mode: NavigatorMode.remove,
                moveTo: RouteName.customQuestionOnboarding,
                param: param);
          },
        ),
      ],
    );
  }
}

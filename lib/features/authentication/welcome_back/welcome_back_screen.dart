import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:rive/rive.dart';

class WelcomeBackScreen extends BaseApp {
  const WelcomeBackScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _WelcomeBackScreen();
}

class _WelcomeBackScreen extends BaseState {
  final _authBloc = AuthenticationBloc();
  GlobalBloc? _globalBloc;
  String userFullName = '';
  int userID = 0;
  String firstName = "";

  @override
  init() {
    Map<String, dynamic>? param = widget.arguments;
    if (param != null) {
      printLog("#WELCOMEBACK# navigation param :: $param");
      if (param['user_name'] != null && param['user_name'] != "") {
        userFullName = param['user_name'];
        userID = param['user_id'];
      }
    }
  }

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);

    if (userFullName.toString().trim().contains(" ")) {
      firstName = userFullName
          .toString()
          .substring(0, userFullName.toString().indexOf(" "));
    } else {
      firstName = userFullName;
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColorStyle.background(context),
      padding: const EdgeInsets.only(
          left: 30.0, top: 50.0, right: 30.0, bottom: 30.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: const RiveAnimation.asset(
                      RiveAssets.welcomeBack,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    StringHelper.welcomeBackTitle,
                    style: AppTextStyle.headlineBold(
                        context, AppColorStyle.text(context)),
                  ),
                  Text(
                    Utility.capitalizeAllWords(firstName),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.headlineBold(
                        context, AppColorStyle.primary(context)),
                  ),
                  const SizedBox(
                    height: Constants.commonPadding,
                  ),
                  Text(
                    StringHelper.welcomeBackSubTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.subTitleRegular(
                        context, AppColorStyle.textHint(context)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ButtonWidget(
              title: "Continue with $firstName",
              onTap: () async {
                globalBloc!.isShowDialogSubscription = true;
                await SharedPreferenceController.setIsWelcomeOpen(true);
                GoRoutesPage.go(
                    mode: NavigatorMode.remove, moveTo: RouteName.home);
              },
              logActionEvent: FBActionEvent.fbActionWelcomeBack,
            ),
            const SizedBox(
              height: 25.0,
            ),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "Not $firstName?",
                    style: AppTextStyle.subTitleMedium(
                      context,
                      AppColorStyle.textHint(context),
                    ),
                  ),
                  InkWellWidget(
                    onTap: () {
                      // CLEAR DATA AND REDIRECT TO onBoarding SCREEN
                      _globalBloc?.clearUserInfo = UserInfoData(
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null,
                          null);
                      _authBloc.userLogout(
                          context: context, userID: userID, showMessage: false);
                    },
                    child: Text(
                      StringHelper.welcomeBackNewUser,
                      style: AppTextStyle.subTitleMedium(
                        context,
                        AppColorStyle.primary(context),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  onResume() {}
}

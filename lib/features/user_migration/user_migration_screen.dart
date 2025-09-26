// ignore_for_file: overridden_fields

import 'dart:io';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/google_apple_singin_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/user_migration/user_migration_bloc.dart';
import 'package:rive/rive.dart';

class UserMigrationScreen extends BaseApp {
  const UserMigrationScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _UserMigrationScreenState();
}

class _UserMigrationScreenState extends BaseState {
  final UserMigrationBloc _userMigrationBloc = UserMigrationBloc();
  @override
  GlobalBloc? globalBloc;

  @override
  Widget body(BuildContext context) {
    globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxBlocProvider(
      create: (_) => _userMigrationBloc,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColorStyle.background(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width / 1.25,
                    width: MediaQuery.of(context).size.width / 1.25,
                    child:
                        RiveAnimation.asset(RiveAssets.sleepy, onInit: _onInit),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  StringHelper.sessionExpired,
                  style: AppTextStyle.titleSemiBold(
                      context, AppColorStyle.text(context)),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                      text: "To ensure the security and reliability",
                      style: AppTextStyle.detailsRegular(
                          context, AppColorStyle.textDetail(context)),
                      children: [
                        TextSpan(
                            text: "\nof your data, please continue with",
                            style: AppTextStyle.detailsRegular(
                                context, AppColorStyle.textDetail(context))),
                        TextSpan(
                            text: Platform.isIOS ?"\nyour Google or Apple":"\nyour Google.",
                            style: AppTextStyle.detailsRegular(
                                context, AppColorStyle.textDetail(context))),
                      ]),
                ),
                const SizedBox(
                  height: 80.0,
                ),
                Visibility(
                  visible: Platform.isIOS,
                  child: GoogleAppleSignInWidget(
                      isGoogle: false,
                      onTap: () {
                        _userMigrationBloc.appleSignIn(context, globalBloc!);
                      }),
                ),
                SizedBox(
                  height: Platform.isIOS ? 20.0 : 0.0,
                ),
                GoogleAppleSignInWidget(
                  isGoogle: true,
                  onTap: () =>
                      _userMigrationBloc.googleSignIn(context, globalBloc!),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onInit(Artboard art) {
    var ctrl = StateMachineController.fromArtboard(art, 'State Machine 1')
        as StateMachineController;
    ctrl.isActive = false;
    art.addController(ctrl);
    setState(() {
    });
  }

  @override
  init() {
    dynamic param = widget.arguments;
    if (param != null) {
      printLog("#UserMigrationScreen# navigation param :: $param");
      _userMigrationBloc.setUserInfo = param;
    }
  }

  @override
  onResume() {}
}

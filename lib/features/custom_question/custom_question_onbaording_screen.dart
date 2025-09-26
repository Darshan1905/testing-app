import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/custom_question/custom_question_bloc.dart';
import 'package:occusearch/features/custom_question/model/custom_question_model.dart';
import 'package:occusearch/features/custom_question/widgets/custom_question_onboarding_widget.dart';

class CustomQuestionOnbaordingScreen extends BaseApp {
  const CustomQuestionOnbaordingScreen({super.key, super.arguments})
      : super.builder();

  @override
  BaseState createState() => _CustomQuestionOnbaordingScreenState();
}

class _CustomQuestionOnbaordingScreenState extends BaseState {
  var isFromCreateAccount = false;

  @override
  init() {
    Future.delayed(Duration.zero, () async {
      var arg = widget.arguments;
      //to get custom question data
      CustomQuestionBloc.getCustomQuestionData();
      if (arg != null) {
        if (arg['isFromCreateAccount']) {
          isFromCreateAccount = true;
        } else {
          isFromCreateAccount = false;
        }
      }
    });
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider(
      create: (_) => CustomQuestionBloc(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColorStyle.primary(context),
        child: StreamWidget(
            stream: CustomQuestionBloc.getFirstAttemptStream,
            onBuild: (_, firstAttemptSnapShot) {
              if (firstAttemptSnapShot != null) {
                printLog("firstAttemptSnapShot==$firstAttemptSnapShot");
                return Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 80, right: 30, bottom: 30),
                    child: StreamWidget(
                      stream: CustomQuestionBloc.getCustomQuestionsListStream,
                      onBuild: (_, snapShot) {
                        List<CustomQuestions>? customQuestionsList = snapShot;
                        if (snapShot != null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  "Only ${customQuestionsList?.length} simple steps",
                                  // StringHelper.onlySixSimpleSteps,
                                  style: AppTextStyle.subTitleRegular(context,
                                      AppColorStyle.primaryText(context))),
                              const SizedBox(height: 10),
                              Text(StringHelper.letsKnowYouBetter,
                                  style: AppTextStyle.headlineSemiBold(context,
                                      AppColorStyle.textWhite(context))),
                              //Custom Questions List
                              const CustomQuestionOnbordingListWidget(),
                              ButtonWidget(
                                title: StringHelper.customQuestionLetsStart,
                                onTap: () {
                                  Map<String, dynamic>? param = {
                                    "firstAttemptFromEditScreen":
                                        firstAttemptSnapShot,
                                  };
                                  GoRoutesPage.go(
                                      mode: NavigatorMode.push,
                                      moveTo: RouteName.customQuestion,
                                      param: param);
                                },
                                logActionEvent: FBActionEvent.fbActionLetsStart,
                                textColor: AppColorStyle.primary(context),
                                buttonColor: AppColorStyle.background(context),
                                arrowIconColor: AppColorStyle.primary(context),
                              ),
                              const SizedBox(height: 50),
                              InkWellWidget(
                                onTap: () {
                                  if (firstAttemptSnapShot &&
                                      !isFromCreateAccount) {
                                    context.popUntil(RouteName.editProfile);
                                  } else {
                                    GoRoutesPage.go(
                                        mode: NavigatorMode.push,
                                        moveTo: RouteName.home);
                                  }
                                },
                                child: Center(
                                  child: Text(StringHelper.willDoIt,
                                      style: AppTextStyle.subTitleRegular(
                                          context,
                                          AppColorStyle.primaryText(context))),
                                ),
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ));
              }
              return Container();
            }),
      ),
    );
  }
}

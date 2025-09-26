import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/other_living_cost/widget/other_living_footer.dart';
import 'package:occusearch/features/fund_calculator/other_living_cost/widget/other_living_question_1.dart';
import 'package:occusearch/features/fund_calculator/other_living_cost/widget/other_living_question_2.dart';
import 'package:occusearch/features/fund_calculator/other_living_cost/widget/other_living_question_3.dart';
import 'package:occusearch/features/fund_calculator/other_living_cost/widget/other_living_question_4.dart';
import 'package:occusearch/features/fund_calculator/other_living_cost/widget/other_living_question_5.dart';
import 'package:occusearch/features/fund_calculator/other_living_cost/widget/other_living_question_6.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_calculator_actionbar.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_progress_bar.dart';

class OtherLivingCostScreen extends BaseApp {
  const OtherLivingCostScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _OtherLivingCostScreenState();
}

class _OtherLivingCostScreenState extends BaseState {
  final FundCalculatorBloc _fundCalculatorBloc = FundCalculatorBloc();

  final PageController _controller = PageController(initialPage: 0);

  List<FundCalculatorQuestion>? fundQuestions;

  // ignore: prefer_typing_uninitialized_variables
  var _fundSavedAnswer;

  @override
  init() {
    dynamic argumentValue = widget.arguments;
    if (widget.arguments != null) {
      _fundSavedAnswer = argumentValue['_fundCalculatorBloc'];
      fundQuestions = argumentValue['fundQuestions'];
    }

    /// after refresh data show and option selection show after swipe
    Future.delayed(Duration.zero, () async {
      // To get other living data
      await _fundCalculatorBloc.getFundCalculatorData();
    });
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider(
        create: (_) => _fundCalculatorBloc,
        child: WillPopScopeWidget(
          onWillPop: () async {
            WidgetHelper.alertDialogWidget(
              context: context,
              title: StringHelper.fundCalc,
              buttonColor: AppColorStyle.teal(context),
              message: StringHelper.fundConfirmDialogMessage,
              positiveButtonTitle: StringHelper.yesQuit,
              negativeButtonTitle: StringHelper.cancel,
              onPositiveButtonClick: () {
                GoRoutesPage.go(
                    mode: NavigatorMode.remove, moveTo: RouteName.home);
              },
            );
            return false;
          },
          child: Container(
              color: AppColorStyle.background(context),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: SafeArea(
                bottom: false,
                child: StreamWidget(
                    stream: _fundCalculatorBloc.getLivingCurrentQuestionStream,
                    onBuild: (_, snapshot) {
                      List<OtherLivingQuestion> questionList = snapshot;
                      return Column(
                        children: [
                          // [ACTION BAR]
                          FundActionBarWidget(
                            fromOtherLivingCost: true,
                            actionbarTitle: '',
                            questionList: questionList,
                            onNextClicked: () {
                              moveToNextPage();
                            },
                            onBackPressed: () {
                              WidgetHelper.alertDialogWidget(
                                context: context,
                                title: StringHelper.fundCalc,
                                buttonColor: AppColorStyle.teal(context),
                                message: StringHelper.fundConfirmDialogMessage,
                                positiveButtonTitle: StringHelper.yesQuit,
                                negativeButtonTitle: StringHelper.cancel,
                                onPositiveButtonClick: () {
                                  ///page redirect to fund calc summary page
                                  Utility.popToSpecificPage(context,
                                      rootName:
                                          RouteName.fundCalculatorSummaryPage);
                                  // GoRoutesPage.go(mode: NavigatorMode.remove, moveTo: RouteName.home);
                                },
                              );
                            },
                            max: questionList.length,
                            // max: 6,
                          ),

                          //PROGRESS BAR
                          StreamWidget(
                            stream: _fundCalculatorBloc.getCurrentIndex,
                            onBuild: (_, indexSnapShot) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15),
                                child: FundProgressBar(
                                  index: indexSnapShot,
                                  max: 6,
                                ),
                              );
                            },
                          ),

                          Expanded(
                            child: GestureDetector(
                              onHorizontalDragEnd: (dragEndDetails) {
                                if (dragEndDetails.primaryVelocity! < 0) {
                                  if (_controller.page !=
                                      questionList.length - 1) {
                                    moveToNextPage();
                                  }
                                } else if (dragEndDetails.primaryVelocity! >
                                    0) {
                                  moveToPreviousPage();
                                }
                              },
                              child: PageView.builder(
                                itemCount: questionList.length,
                                scrollDirection: Axis.horizontal,
                                controller: _controller,
                                physics: const NeverScrollableScrollPhysics(),
                                onPageChanged: (int index) async {
                                  _fundCalculatorBloc.setCurrentIndex = index;
                                  _controller.animateToPage(index,
                                      duration:
                                          const Duration(milliseconds: 700),
                                      curve: Curves.linearToEaseOut);
                                },
                                itemBuilder: (context, index) {
                                  int progressbarMaxLength =
                                      questionList.length + 1;
                                  switch (index + 1) {
                                    //QUESTION 1
                                    case 1:
                                      OtherLivingQuestion ques1Data =
                                          _fundCalculatorBloc
                                              .getOtherLeavingQuestionData(1);
                                      _fundCalculatorBloc
                                          .setOtherLivingCurrentQuestion = [
                                        ques1Data
                                      ];
                                      return OtherLivingQuestion1Widget(
                                          index: index,
                                          max: progressbarMaxLength,
                                          onNextClick: () => {},
                                          questionData: ques1Data);
                                    //QUESTION 2
                                    case 2:
                                      OtherLivingQuestion ques2Data =
                                          _fundCalculatorBloc
                                              .getOtherLeavingQuestionData(2);
                                      _fundCalculatorBloc
                                          .setOtherLivingCurrentQuestion = [
                                        ques2Data
                                      ];
                                      return OtherLivingQuestion2Widget(
                                          index: index,
                                          max: progressbarMaxLength,
                                          onNextClick: () => {},
                                          questionData: ques2Data);
                                    //QUESTION 3
                                    case 3:
                                      OtherLivingQuestion ques1Data =
                                          _fundCalculatorBloc
                                              .getOtherLeavingQuestionData(1);
                                      OtherLivingQuestion ques2Data =
                                          _fundCalculatorBloc
                                              .getOtherLeavingQuestionData(2);
                                      OtherLivingQuestion ques3Data =
                                          _fundCalculatorBloc
                                              .getOtherLeavingQuestionData(3);
                                      _fundCalculatorBloc
                                          .setOtherLivingCurrentQuestion = [
                                        ques3Data
                                      ];
                                      return OtherLivingQuestion3Widget(
                                          index: index,
                                          max: progressbarMaxLength,
                                          onNextClick: () => {},
                                          question1Data: ques1Data,
                                          question2Data: ques2Data,
                                          questionData: ques3Data);
                                    //QUESTION 4
                                    case 4:
                                      OtherLivingQuestion ques4Data =
                                          _fundCalculatorBloc
                                              .getOtherLeavingQuestionData(4);
                                      _fundCalculatorBloc
                                          .setOtherLivingCurrentQuestion = [
                                        ques4Data
                                      ];
                                      return OtherLivingQuestion4Widget(
                                          index: index,
                                          max: progressbarMaxLength,
                                          onNextClick: () => {},
                                          questionData: ques4Data);
                                    //QUESTION 5
                                    case 5:
                                      OtherLivingQuestion ques5Data =
                                          _fundCalculatorBloc
                                              .getOtherLeavingQuestionData(5);

                                      _fundCalculatorBloc
                                          .setOtherLivingCurrentQuestion = [
                                        ques5Data
                                      ];
                                      return OtherLivingQuestion5Widget(
                                          index: index,
                                          max: progressbarMaxLength,
                                          onNextClick: () => {},
                                          questionData: ques5Data);
                                    //QUESTION 6
                                    case 6:
                                      OtherLivingQuestion ques6Data =
                                          _fundCalculatorBloc
                                              .getOtherLeavingQuestionData(6);
                                      _fundCalculatorBloc
                                          .setOtherLivingCurrentQuestion = [
                                        ques6Data
                                      ];
                                      return OtherLivingQuestion6Widget(
                                          index: index,
                                          max: progressbarMaxLength,
                                          onNextClick: () => {},
                                          questionData: ques6Data);
                                    default:
                                      return const Text(
                                          StringHelper.someThingWentWrong);
                                  }
                                },
                              ),
                            ),
                          ),

                          //PREV-NEXT BUTTON
                          StreamWidget(
                              stream: _fundCalculatorBloc.getCurrentIndex,
                              onBuild: (_, snapshot) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      snapshot + 1 != 1
                                          ? InkWell(
                                              onTap: () {
                                                moveToPreviousPage();
                                              },
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: AppColorStyle.tealText(
                                                      context),
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    topRight: Radius.zero,
                                                    bottomLeft:
                                                        Radius.circular(10.0),
                                                    bottomRight: Radius.zero,
                                                  ),
                                                ),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 10.0),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    IconsSVG.fundBackIcon,
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (_fundCalculatorBloc
                                                  .getCurrentIndexValue ==
                                              questionList.length) {
                                            if (NetworkController
                                                .isInternetConnected) {
                                              var param = {
                                                'fundSavedAnswerBloc':
                                                    _fundSavedAnswer,
                                                //STORE FUND QUESTION ANSWERS,
                                                'fundQuestions': fundQuestions,
                                                'fundQuestionsBloc':
                                                    _fundCalculatorBloc,
                                              };
                                              GoRoutesPage.go(
                                                  mode: NavigatorMode.push,
                                                  moveTo: RouteName
                                                      .otherLivingSummaryPage,
                                                  param: param);
                                            } else {
                                              Toast.show(context,
                                                  message: StringHelper
                                                      .internetConnection,
                                                  gravity: Toast.toastTop,
                                                  duration: 3,
                                                  type: Toast.toastError);
                                            }
                                          }
                                          moveToNextPage();
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                AppColorStyle.tealText(context),
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              topLeft: Radius.zero,
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              bottomLeft: Radius.zero,
                                            ),
                                          ),
                                          margin: const EdgeInsets.only(
                                              bottom: 10.0),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 10.0),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              (_fundCalculatorBloc
                                                          .getCurrentIndexValue ==
                                                      questionList.length - 1)
                                                  ? IconsSVG.correctIcon
                                                  : IconsSVG.fundNextIcon,
                                              width: 15,
                                              height: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                          StreamWidget(
                              stream: _fundCalculatorBloc.getCurrentIndex,
                              onBuild: (_, snapshot) {
                                // [FOOTER WIDGET]
                                return snapshot != 0 && snapshot != 1
                                    ? Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            height: 10,
                                            color:
                                                AppColorStyle.backgroundVariant(
                                                    context),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const OtherLivingFooterWidget(),
                                        ],
                                      )
                                    : Container();
                              }),
                        ],
                      );
                    }),
              )),
        ));
  }

  moveToNextPage() async {
    printLog(
        "current page Index${_fundCalculatorBloc.getCurrentIndexValue + 1}");
    if ((_fundCalculatorBloc.getCurrentIndexValue + 1) == 6) {
      if (NetworkController.isInternetConnected) {
        var param = {
          'fundSavedAnswerBloc': _fundSavedAnswer,
          //STORE FUND QUESTION ANSWERS,
          'fundQuestions': fundQuestions,
          'fundQuestionsBloc': _fundCalculatorBloc,
        };
        /*final result = await GoRoutesPage.go(
            mode: NavigatorMode.push,
            moveTo: RouteName.otherLivingSummaryPage,
            param: param);*/

        var result = await context.push<dynamic>(
            RouteName.root + RouteName.otherLivingSummaryPage,
            extra: param);
        if (result != null) {
          _controller.jumpToPage(result as int);
          // set default currency AUD
          if (_fundCalculatorBloc.defaultCurrency != null) {
            _fundCalculatorBloc.selectedCurrencyData =
                _fundCalculatorBloc.defaultCurrency;
          }
        }
      } else {
        Toast.show(context,
            message: StringHelper.internetConnection,
            type: Toast.toastError,
            duration: 2);
      }
    } else if ((_fundCalculatorBloc
                .getLivingCostQuestionData?[
                    (_fundCalculatorBloc.getCurrentIndexValue + 1) - 1]
                .answer ==
            "" ||
        _fundCalculatorBloc
                .getLivingCostQuestionData?[
                    (_fundCalculatorBloc.getCurrentIndexValue + 1) - 1]
                .answer ==
            null)) {
      Toast.show(context,
          message: StringHelper.optionSelectionValidation,
          type: Toast.toastError);
    } else {
      _controller.nextPage(
          duration: const Duration(microseconds: 500), curve: Curves.easeIn);
    }
  }

  moveToPreviousPage() {
    _controller.previousPage(
        duration: const Duration(microseconds: 500), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    super.dispose();
    _fundCalculatorBloc.dispose();
  }
}

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/country/country_bloc.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_calculator_actionbar.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_calculator_shimmer.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_progress_bar.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_1.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_2.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_3.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_4.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_5.dart';
import 'package:occusearch/features/fund_calculator/widget/fund_question_footer.dart';

import 'fund_calculator_bloc.dart';

class FundCalculatorQuestionsScreen extends BaseApp {
  const FundCalculatorQuestionsScreen({super.key, super.arguments})
      : super.builder();

  @override
  BaseState createState() => _FundCalculatorQuestionsScreenState();
}

class _FundCalculatorQuestionsScreenState extends BaseState {
  FundCalculatorBloc _fundCalculatorBloc = FundCalculatorBloc();

  // final FundCalculatorBloc _fundCalculatorBloc = FundCalculatorBloc();
  CountryBloc? _countryBloc;

  final PageController _controller = PageController(initialPage: 0);

  //If data exists in fundQuestions from summary page
  List<FundCalculatorQuestion>? fundQuestions;

  @override
  init() {
    Future.delayed(Duration.zero, () async {
      if (widget.arguments != null) {
        var argumentsValue = widget.arguments;
        fundQuestions =
            argumentsValue['fundQuestions'] ?? FundCalculatorQuestion();
        if (argumentsValue['_fundCalculatorBloc'] != null) {
          _fundCalculatorBloc = argumentsValue['_fundCalculatorBloc'];
        } else if (argumentsValue['fundAnswerSavedBloc'] != null) {
          _fundCalculatorBloc = argumentsValue['fundAnswerSavedBloc'];
        } else {
          _fundCalculatorBloc = FundCalculatorBloc();
        }
      }
      // To get fund calculator data
      await _fundCalculatorBloc.getFundCalculatorData();
      await _countryBloc?.setupRemoteConfigForCountryList();
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
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SafeArea(
            bottom: false,
            child: StreamWidget(
              stream: _fundCalculatorBloc.getFundCalculatorListStream,
              onBuild: (_, snapshot) {
                List<FundCalculatorQuestion> questionList = snapshot;
                return Column(
                  children: [
                    // [ACTION BAR]
                    FundActionBarWidget(
                      fromOtherLivingCost: false,
                      questionList: questionList,
                      actionbarTitle: '',
                      onNextClicked: () {
                        moveToNextPage(
                            context,
                            _fundCalculatorBloc
                                .getFundCalculatorListStreamValue.length,
                            false);
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
                            GoRoutesPage.go(
                                mode: NavigatorMode.remove,
                                moveTo: RouteName.home);
                          },
                        );
                        /*GoRoutesPage.go(
                            mode: NavigatorMode.remove,
                            moveTo: RouteName.fundCalculatorOnBoarding);*/
                      },
                      max: (questionList.length - 1),
                    ),

                    //PROGRESS BAR
                    StreamWidget(
                        stream: _fundCalculatorBloc.getFundCalculatorListStream,
                        onBuild: (_, snapshot) {
                          List<dynamic> questionList = snapshot;
                          return StreamWidget(
                            stream: _fundCalculatorBloc.getCurrentIndex,
                            onBuild: (_, indexSnapShot) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: FundProgressBar(
                                    index: indexSnapShot,
                                    max: (questionList.length - 1),
                                  ),
                                ),
                              );
                            },
                          );
                        }),

                    // [QUESTION WIDGET]
                    snapshot != null
                        ? Expanded(
                            child: GestureDetector(
                              onHorizontalDragEnd: (dragEndDetails) {
                                if (dragEndDetails.primaryVelocity! < 0) {
                                  moveToNextPage(
                                      context, questionList.length, true);
                                } else if (dragEndDetails.primaryVelocity! >
                                    0) {
                                  moveToPreviousPage();
                                }
                              },
                              child: PageView.builder(
                                itemCount: questionList.length - 1,
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
                                  switch (index + 1) {
                                    // COURSE FEES QUESTION
                                    case 1:
                                      FundCalculatorQuestion ques1Data =
                                          _fundCalculatorBloc
                                              .getFundCalcQuestionData(1);
                                      _fundCalculatorBloc.setCurrentQuestion = [
                                        ques1Data
                                      ];
                                      return FundQuestion1Widget(
                                          index: index,
                                          max: questionList.length,
                                          onNextClick: () => moveToNextPage(
                                              context,
                                              questionList.length,
                                              false),
                                          questionData: ques1Data);
                                    // LIVING COST - Q: 2, 3
                                    case 2:
                                      FundCalculatorQuestion ques2Data =
                                          _fundCalculatorBloc
                                              .getFundCalcQuestionData(2);
                                      FundCalculatorQuestion ques3Data =
                                          _fundCalculatorBloc
                                              .getFundCalcQuestionData(3);
                                      _fundCalculatorBloc.setCurrentQuestion = [
                                        ques2Data,
                                        ques3Data
                                      ];
                                      return FundQuestion2Widget(
                                        index: index,
                                        themeBloc:
                                            themeBloc?.currentTheme ?? false,
                                        max: questionList.length,
                                        onNextClick: () => moveToNextPage(
                                            context,
                                            questionList.length,
                                            false),
                                        questionStudentData: ques2Data,
                                        questionSpouseData: ques3Data,
                                      );
                                    // LIVING COST - Q: 4
                                    case 3:
                                      FundCalculatorQuestion ques4Data =
                                          _fundCalculatorBloc
                                              .getFundCalcQuestionData(4);
                                      _fundCalculatorBloc.setCurrentQuestion = [
                                        ques4Data
                                      ];
                                      return FundQuestion3Widget(
                                        index: index,
                                        max: questionList.length,
                                        themeBloc:
                                            themeBloc?.currentTheme ?? false,
                                        questionData: ques4Data,
                                      );
                                    // SCHOOLING COST - Q: 5
                                    case 4:
                                      FundCalculatorQuestion ques4Data =
                                          _fundCalculatorBloc
                                              .getFundCalcQuestionData(4);
                                      FundCalculatorQuestion ques5Data =
                                          _fundCalculatorBloc
                                              .getFundCalcQuestionData(5);
                                      _fundCalculatorBloc.setCurrentQuestion = [
                                        ques5Data
                                      ];
                                      return FundQuestion4Widget(
                                        index: index,
                                        themeBloc:
                                            themeBloc?.currentTheme ?? false,
                                        max: questionList.length,
                                        prevQuestionData: ques4Data,
                                        questionData: ques5Data,
                                      );
                                    case 5:
                                      FundCalculatorQuestion ques3Data =
                                          _fundCalculatorBloc
                                              .getFundCalcQuestionData(3);
                                      FundCalculatorQuestion ques4Data =
                                          _fundCalculatorBloc
                                              .getFundCalcQuestionData(4);
                                      FundCalculatorQuestion ques6Data =
                                          _fundCalculatorBloc
                                              .getFundCalcQuestionData(6);
                                      _fundCalculatorBloc.setCurrentQuestion = [
                                        ques6Data
                                      ];
                                      return FundQuestion5Widget(
                                        index: index,
                                        max: questionList.length,
                                        question3Data: ques3Data,
                                        question4Data: ques4Data,
                                        questionData: ques6Data,
                                      );
                                    default:
                                      return const Text(
                                          StringHelper.someThingWentWrong);
                                  }
                                },
                              ),
                            ),
                          )
                        : const FundCalculatorQuestionShimmer(),

                    //PREV-NEXT BUTTON
                    StreamWidget(
                        stream: _fundCalculatorBloc.getCurrentIndex,
                        onBuild: (_, snapshot) {
                          return Visibility(
                            visible: snapshot != null && snapshot != 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.zero,
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight: Radius.zero,
                                              ),
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 10.0),
                                            padding: const EdgeInsets.symmetric(
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
                                      moveToNextPage(
                                          context, questionList.length, false);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColorStyle.tealText(context),
                                        shape: BoxShape.rectangle,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          topLeft: Radius.zero,
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.zero,
                                        ),
                                      ),
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 10.0),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          (snapshot + 1 ==
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
                            ),
                          );
                        }),

                    const SizedBox(
                      height: 15,
                    ),

                    Container(
                      height: 10,
                      color: AppColorStyle.backgroundVariant(context),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // [FOOTER WIDGET]
                    const FundQuestionFooterWidget(),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void moveToNextPage(
      BuildContext context, int questionListLength, bool isFromDrag) {
    //isFromDrag = true when last question and this method called from drag.
    try {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      // check validation
      final flag = _fundCalculatorBloc.checkValidation(context,
          index: _fundCalculatorBloc.getCurrentIndexValue + 1,
          checkValidation: true);

      Future.delayed(Duration.zero, () async {
        if (questionListLength - 1 ==
                _fundCalculatorBloc.getCurrentIndexValue + 1 &&
            flag &&
            !isFromDrag) {
          var param = {
            "_fundCalculatorBloc": _fundCalculatorBloc,
            "fundQuestions":
                _fundCalculatorBloc.getFundCalculatorListStreamValue
          };
          // [DONE] Move to Fund calculator summary page
          if (NetworkController.isInternetConnected == true) {
            var result = await context.push<dynamic>(
                RouteName.root + RouteName.fundCalculatorSummaryPage,
                extra: param);
            if (result.toString().isNotEmpty) {
              _controller.jumpToPage(result['index']);
            }
          } else {
            Toast.show(context,
                message: StringHelper.internetConnection,
                gravity: Toast.toastTop,
                duration: 3,
                type: Toast.toastError);
          }
        } else if (questionListLength - 1 !=
                _fundCalculatorBloc.getCurrentIndexValue &&
            flag) {
          _fundCalculatorBloc.setSelectedQuesAmount = 0.0;
          // Move to next page
          _controller.nextPage(
              duration: const Duration(microseconds: 500),
              curve: Curves.easeIn);
        }
      });
    } catch (e) {
      printLog(e);
    }
  }

  void moveToPreviousPage() {
    // check validation
    _controller.previousPage(
        duration: const Duration(microseconds: 500), curve: Curves.easeOut);
  }
}

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/custom_question/custom_question_bloc.dart';
import 'package:occusearch/features/custom_question/model/custom_question_model.dart';
import 'package:occusearch/features/custom_question/widgets/custom_question_widget.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';

class CustomQuestionScreen extends BaseApp {
  const CustomQuestionScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _CustomQuestionScreenState();
}

class _CustomQuestionScreenState extends BaseState {
  final VisaFeesBloc _visaFeesBloc = VisaFeesBloc();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dropDownSearchController =
      TextEditingController();

  int currentQuestionIndex = 0;

  late bool _loop;
  late bool _autoplay;
  late int _autoplayDely;
  late bool _outer;
  late double _scale;
  late Curve _curve;
  late double _fade;
  late bool _autoplayDisableOnInteraction;
  late CustomLayoutOption customLayoutOption;
  late SwiperController _controller;

  int? popQuestionIndex;
  bool? popResult = false;
  bool firstAttemptFromEditScreen = false;
  List<CustomQuestions> pendingQuestionList = [];

  @override
  init() {
    Future.delayed(Duration.zero, () async {
      CustomQuestionBloc.setCurrentIndexValue = 0;
      CustomQuestionBloc.setPopIndexValue = "";

      //to get visa fees list data
      _visaFeesBloc.setSearchFieldController = _searchController;
      await _visaFeesBloc.getVisaSubclassData(context);

      Map<String, dynamic>? param = widget.arguments;
      if (param != null) {
        //IF WE CAME FROM EDIT SCREEN
        if (param['firstAttemptFromEditScreen'] != null) {
          firstAttemptFromEditScreen = param['firstAttemptFromEditScreen'];
        }
        if (param['questionIndex'] != null) {
          popQuestionIndex = param['questionIndex'];
          //IF WE CAME FROM EDIT PROFILE - MOVE TO THE PARTICULAR QUESTION
          _controller.move((param['questionIndex']), animation: true);
          CustomQuestionBloc.setPopIndexValue =
              param['questionIndex'].toString();
          CustomQuestionBloc.setCurrentIndexValue =
              int.parse(param['questionIndex'].toString());
        }
        //IF WE CAME FROM DASHBOARD
        if (param['pendingQuestionList'] != null) {
          pendingQuestionList = param['pendingQuestionList'];
        }
      } else {
        await CustomQuestionBloc.getCustomQuestionData();
      }

      //to get custom question search list data
      CustomQuestionBloc.setSearchFieldController = _dropDownSearchController;
    });

    customLayoutOption = CustomLayoutOption(startIndex: -1, stateCount: 3);
    _fade = 1.0;
    _curve = Curves.ease;
    _scale = 0.8;
    _controller = SwiperController();
    _loop = false;
    _autoplay = false;
    _autoplayDely = 3000;
    _outer = false;
    _autoplayDisableOnInteraction = false;
  }

  @override
  onResume() {}

  @override
  void dispose() {
    super.dispose();
    CustomQuestionBloc.setCurrentIndexValue = 0;
    CustomQuestionBloc.setPopIndexValue = "";
  }

  @override
  Widget body(BuildContext context) {
    return RxMultiBlocProvider(
      providers: [
        RxBlocProvider<VisaFeesBloc>(create: (context) => _visaFeesBloc),
      ],
      child: WillPopScopeWidget(
        onWillPop: () async {
          /*
          if (popQuestionIndex != null || firstAttemptFromEditScreen) {
            context.popUntil(RouteName.editProfile);
          } else {
            return GoRoutesPage.go(
                mode: NavigatorMode.push, moveTo: RouteName.home);
          }
          CustomQuestionBloc.setCurrentIndexValue = 0;
           */
          return false;
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColorStyle.primary(context),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, top: 60, right: 30, bottom: 30),
              child: StreamWidget(
                  stream: CustomQuestionBloc.getCustomQuestionsListStream,
                  onBuild: (context, questionListSnapshot) {
                    if (questionListSnapshot != null) {
                      return StreamWidget(
                          stream: CustomQuestionBloc.getCurrentIndexStream,
                          onBuild: (_, snapshot) {
                            if (snapshot != null) {
                              bool isFromDashboard =
                                  pendingQuestionList.isNotEmpty ? true : false;

                              ///IF PENDING QUESTION LIST [MEANS WE CAME FROM DASHBOARD] NOT EMPTY THEN SORT BASED ON IS-ATTEMPTED FLAG
                              List<CustomQuestions>? customQuestionsList =
                                  isFromDashboard && popResult == true
                                      ? questionListSnapshot
                                      : isFromDashboard
                                          ? questionListSnapshot
                                              .where((element) =>
                                                  element.primary == true &&
                                                  !element.isAttempted)
                                              .toList()
                                          : questionListSnapshot;
                              var totalLength =
                                  customQuestionsList?.length ?? 0;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Question ${(CustomQuestionBloc.getCurrentIndex ?? 0) + 1} of $totalLength",
                                    style: AppTextStyle.titleRegular(
                                      context,
                                      AppColorStyle.whiteTextColor(context),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(StringHelper.letsKnowYouBetter,
                                      style: AppTextStyle.headlineSemiBold(
                                          context,
                                          AppColorStyle.textWhite(context))),
                                  const SizedBox(height: 50),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1.5,
                                    child: Swiper(
                                        onTap: (val) {},
                                        itemCount: customQuestionsList!.length,
                                        customLayoutOption: customLayoutOption,
                                        fade: _fade,
                                        viewportFraction: popQuestionIndex !=
                                                    null ||
                                                popResult == true
                                            ? 0.9
                                            : 0.8,
                                        layout: popQuestionIndex != null ||
                                                popResult == true
                                            ? SwiperLayout.DEFAULT
                                            : SwiperLayout.TINDER,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        index:
                                            CustomQuestionBloc.getCurrentIndex,
                                        onIndexChanged: (int index) {
                                          moveToAnswerReviewPage(
                                              context,
                                              isFromDashboard &&
                                                      ((customQuestionsList
                                                                  .length) -
                                                              1) ==
                                                          index
                                                  ? questionListSnapshot
                                                  : customQuestionsList,
                                              false,
                                              index);
                                        },
                                        curve: _curve,
                                        scale: _scale,
                                        controller: _controller,
                                        outer: _outer,
                                        autoplayDelay: _autoplayDely,
                                        loop: _loop,
                                        autoplay: _autoplay,
                                        autoplayDisableOnInteraction:
                                            _autoplayDisableOnInteraction,
                                        itemWidth:
                                            MediaQuery.of(context).size.width,
                                        itemHeight:
                                            MediaQuery.of(context).size.height /
                                                1.5,
                                        axisDirection: AxisDirection.right,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          final CustomQuestions questionData =
                                              customQuestionsList[index];
                                          var displayRadialUi = false;
                                          // var radialQuestionArray = [408,442,443,444,445];  //Staging
                                          var radialQuestionArray = [
                                            1411,
                                            1412,
                                            1413,
                                            1414,
                                            1415
                                          ]; //Live
                                          if (radialQuestionArray.contains(
                                              questionData.questionId)) {
                                            displayRadialUi = true;
                                          } else {
                                            displayRadialUi = false;
                                          }
                                          return Container(
                                            color: AppColorStyle.background(
                                                context),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 30,
                                                      horizontal: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    questionData.question
                                                        .toString(),
                                                    style: AppTextStyle
                                                        .subHeadlineMedium(
                                                            context,
                                                            AppColorStyle.text(
                                                                context)),
                                                  ),
                                                  const SizedBox(height: 40),
                                                  questionData.type ==
                                                          "RadioButton"
                                                      ? Expanded(
                                                          child:
                                                              CustomQuesSingleSelectionWidget(
                                                          questionData:
                                                              questionData,
                                                          onSelected: () {
                                                            CustomQuestionBloc
                                                                .setCustomQuestionList(
                                                                    questionData);
                                                          },
                                                          isFromDashboard:
                                                              isFromDashboard,
                                                        ))
                                                      : questionData.type ==
                                                              "Number"
                                                          ? CustomQuestionRadialSliderSelectionWidget(
                                                              isFromDashboard:
                                                                  isFromDashboard,
                                                              questionData:
                                                                  questionData)
                                                          : questionData.type ==
                                                                  "Autocomplete"
                                                              ? CustomQuestionSliderSelectionWidget(
                                                                  isFromDashboard:
                                                                      isFromDashboard,
                                                                  questionData:
                                                                      questionData,
                                                                )
                                                              : (questionData.type == "Dropdown" &&
                                                                      displayRadialUi)
                                                                  ? CustomQuestionRadialSliderSelectionWidget(
                                                                      isFromDashboard:
                                                                          isFromDashboard,
                                                                      questionData:
                                                                          questionData)
                                                                  : (questionData.type == "Dropdown") ||
                                                                          (questionData.type ==
                                                                              "Short Text Entry")
                                                                      ? CustomQuestionDropDownSelectionWidget(
                                                                          isFromDashboard:
                                                                              isFromDashboard,
                                                                          questionData:
                                                                              questionData,
                                                                          dropDownSearchController:
                                                                              _dropDownSearchController,
                                                                          searchController:
                                                                              _searchController)
                                                                      : Expanded(
                                                                          child:
                                                                              CustomQuesSingleSelectionWidget(
                                                                            isFromDashboard:
                                                                                isFromDashboard,
                                                                            questionData:
                                                                                questionData,
                                                                            onSelected:
                                                                                () {
                                                                              CustomQuestionBloc.setCustomQuestionList(questionData);
                                                                            },
                                                                          ),
                                                                        ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  const SizedBox(height: 50),
                                  StreamWidget(
                                      stream:
                                          CustomQuestionBloc.getPopIndexStream,
                                      onBuild: (_, popIndexSnap) {
                                        if (popIndexSnap != null) {
                                          return Visibility(
                                              visible: ((customQuestionsList
                                                          .length) -
                                                      1) !=
                                                  CustomQuestionBloc
                                                      .getCurrentIndex,
                                              child: InkWellWidget(
                                                onTap: () {
                                                  CustomQuestionBloc
                                                      .setCurrentIndexValue = 0;
                                                  if (popIndexSnap != "") {
                                                    // For redirect on review page - popIndex not blank
                                                    moveToAnswerReviewPage(
                                                        context,
                                                        isFromDashboard &&
                                                                ((customQuestionsList
                                                                            .length) -
                                                                        1) ==
                                                                    CustomQuestionBloc
                                                                        .getCurrentIndex
                                                            ? questionListSnapshot
                                                            : customQuestionsList,
                                                        true,
                                                        0);
                                                  } else {
                                                    //FINAL SUBMIT CALL
                                                    CustomQuestionBloc.submitCustomQuestionAnswersList(
                                                        context: context,
                                                        customQuestionsList:
                                                            customQuestionsList,
                                                        fromEditScreen:
                                                            popQuestionIndex !=
                                                                    null
                                                                ? true
                                                                : false,
                                                        firstAttemptFromEditScreen:
                                                            firstAttemptFromEditScreen,
                                                        isFromWillDoLater:
                                                            true);
                                                  }
                                                },
                                                child: Center(
                                                  child: Text(
                                                      popQuestionIndex !=
                                                                  null ||
                                                              popResult == true
                                                          ? StringHelper
                                                              .doneText
                                                          : StringHelper
                                                              .willDoIt,
                                                      style: AppTextStyle
                                                          .subTitleRegular(
                                                              context,
                                                              AppColorStyle
                                                                  .primaryText(
                                                                      context))),
                                                ),
                                              ));
                                        }
                                        return Container();
                                      }),
                                  Visibility(
                                      visible: ((customQuestionsList.length) -
                                              1) ==
                                          CustomQuestionBloc.getCurrentIndex,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: InkWellWidget(
                                          onTap: () {
                                            //FINAL SUBMIT CALL
                                            CustomQuestionBloc
                                                .submitCustomQuestionAnswersList(
                                                    context: context,
                                                    customQuestionsList:
                                                        customQuestionsList,
                                                    fromEditScreen:
                                                        popQuestionIndex != null
                                                            ? true
                                                            : false,
                                                    firstAttemptFromEditScreen:
                                                        firstAttemptFromEditScreen,
                                                    isFromLastQuestion: true);

                                            moveToAnswerReviewPage(
                                              context,
                                              isFromDashboard &&
                                                      ((customQuestionsList
                                                                  .length) -
                                                              1) ==
                                                          CustomQuestionBloc
                                                              .getCurrentIndex
                                                  ? questionListSnapshot
                                                  : customQuestionsList,
                                              true,
                                              CustomQuestionBloc
                                                  .getCurrentIndex,
                                            );
                                          },
                                          child: Center(
                                            child: Text(
                                                popQuestionIndex != null ||
                                                        popResult == true
                                                    ? StringHelper.doneText
                                                    : StringHelper.finish,
                                                style: AppTextStyle
                                                    .subTitleRegular(
                                                        context,
                                                        AppColorStyle.textWhite(
                                                            context))),
                                          ),
                                        ),
                                      )),
                                ],
                              );
                            }
                            return Container();
                          });
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  void moveToAnswerReviewPage(BuildContext context,
      List<CustomQuestions>? customQuestionsList, bool isSubmitPress,
      [int? index]) {
    try {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      // check validation
      Future.delayed(Duration.zero, () async {
        if (((customQuestionsList?.length ?? 0) - 1 ==
                    CustomQuestionBloc.getCurrentIndex &&
                isSubmitPress) ||
            isSubmitPress) {
          var param = {
            "customQuestionList": customQuestionsList,
            //HERE FROM WHICH ROUTE USER CAME
            "isFromEditProfileScreen": popQuestionIndex != null ? true : false,
            "isFromDashboard": pendingQuestionList.isNotEmpty ? true : false
          };
          //IF WE CAME FROM REVIEW [CREATE ACCOUNT FLOW]
          var result = await context.push<dynamic>(
              RouteName.root + RouteName.customQuestionAnswerReview,
              extra: param);
          if (result.toString().isNotEmpty) {
            popResult = true;

            ///when we came from answer review page move to the particular question index
            _controller.move(result, animation: true);
            //FOR VISIBILITY DONE AND WILL DO LATER - NEED POP-INDEX VALUE
            CustomQuestionBloc.setPopIndexValue = result.toString();
            CustomQuestionBloc.setCurrentIndexValue =
                int.parse(result.toString());
          }
        } else {
          CustomQuestionBloc.setCurrentIndexValue = index ?? 0;
        }
      });
    } catch (e) {
      printLog(e);
    }
  }
}

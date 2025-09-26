// ignore_for_file: use_build_context_synchronously, overridden_fields

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/point_test/point_test_bloc.dart';
import 'package:occusearch/features/point_test/point_test_shimmer.dart';
import 'package:occusearch/features/point_test/point_test_widget.dart';

import 'point_test_model/point_test_ques_model.dart';

class PointTestQuestionScreen extends BaseApp {
  const PointTestQuestionScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _PointTestQuestionScreenState();
}

class _PointTestQuestionScreenState extends BaseState {
  final PointTestBloc _pointTestBloc = PointTestBloc();
  @override
  GlobalBloc? globalBloc;
  final PageController _pageController = PageController();
  UserInfoData? userData;

  @override
  init() {
    initData();
  }

  Future<void> initData() async {
    // Receive result from previous screen
    Map<String, dynamic>? param = widget.arguments;
    _pointTestBloc.setupPointTestQuestionTestData(
        param, _pageController, context);
    globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    userData = await globalBloc?.getUserInfo(context);
  }

  @override
  onResume() {
    setState(() {});
  }

  @override
  Widget body(BuildContext context) {
    globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);

    return RxBlocProvider(
      create: (_) => _pointTestBloc,
      child: Container(
        color: AppColorStyle.background(context),
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: StreamWidget(
            stream: _pointTestBloc.visibleQuestionList,
            onBuild: (_, snapshot) {
              List<Questionlist> questionList =
                  (snapshot != null && snapshot != [] ? snapshot : []);
              return (questionList
                      .isNotEmpty /*snapshot != null && snapshot != []*/)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, left: 25.0, right: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PointTestWidget.headerWidget(
                                  context, _pointTestBloc),
                              const SizedBox(
                                height: 15.0,
                              ),
                              StreamBuilder(
                                stream: globalBloc!.getUserInfoStream,
                                builder: (_, snapshots) {
                                  return PointTestWidget
                                      .pointTestProgressNavigator(
                                          context, _pointTestBloc, () {
                                    if (NetworkController.isInternetConnected) {
                                      // If user want to skip next all the question
                                      _pointTestBloc.savePointTestData(
                                          context, snapshots.data!.userId!);
                                    } else {
                                      Toast.show(context,
                                          message:
                                              StringHelper.internetConnection,
                                          type: Toast.toastError);
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Expanded(
                          child: PageView.builder(
                              controller: _pageController,
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: questionList.length,
                              onPageChanged: (currentIndex) {
                                Future.delayed(Duration.zero, () async {
                                  setState(() {
                                    _pointTestBloc.setPageViewIndex =
                                        currentIndex;
                                  });
                                });
                              },
                              itemBuilder: (context, pagePosition) {
                                final Questionlist questionData =
                                    questionList[pagePosition];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // [QUESTION TYPE]
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Constants.commonPadding),
                                      child: Text(
                                          questionData.qtype == null
                                              ? ""
                                              : questionData.qtype!,
                                          textAlign: TextAlign.left,
                                          style: AppTextStyle.headlineBold(
                                              context,
                                              AppColorStyle.text(context))),
                                    ),
                                    const SizedBox(height: 6.0),
                                    // [QUESTION TITLE]
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Text(
                                          questionData.qname == null
                                              ? ""
                                              : questionData.qname!,
                                          textAlign: TextAlign.left,
                                          style: AppTextStyle.detailsRegular(
                                              context,
                                              AppColorStyle.textCaption(
                                                  context))),
                                    ),
                                    const SizedBox(height: 10),
                                    // [QUESTION OPTIONS]
                                    Expanded(
                                      child: PointTestWidget
                                          .pointTestOptionsWidget(context,
                                              _pointTestBloc, questionData),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25.0),
                          child: footerWidget(
                              context: context,
                              questionData: questionList[
                                  _pointTestBloc.getPageViewIndexValue],
                              pointTestBloc: _pointTestBloc,
                              pageController: _pageController,
                              userData: userData),
                        )
                      ],
                    )
                  : const PointTestShimmer();
            },
          ),
        ),
      ),
    );
  }

  Widget footerWidget(
      {required BuildContext context,
      required Questionlist questionData,
      required PointTestBloc pointTestBloc,
      required PageController pageController,
      required UserInfoData? userData}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
            stream: pointTestBloc.pageViewIndex.stream,
            builder: (context, snapshot) {
              final int? pageViewIndex = snapshot.data;
              return Visibility(
                visible: pageViewIndex != 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 750),
                  curve: Curves.fastOutSlowIn,
                  child: InkWellWidget(
                    onTap: () {
                      pointTestBloc.handleQuestionToDisplay(
                          context: context,
                          status: PointTestQuesStatus.PREVIOUD_QUESTION,
                          needToValidate: true,
                          pageController: pageController);
                    },
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                          color: AppColorStyle.cyanVariant2(context),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          IconsSVG.leftIcon,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.textWhite(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
        InkWellWidget(
          onTap: () async {
            if (pointTestBloc.getPageViewIndexValue ==
                (pointTestBloc.visibleQuestionList.value.length - 1)) {
              // For submit question Data
              userData = await globalBloc?.getUserInfo(context);
              FirebaseAnalyticLog.shared.eventTracking(
                  screenName: RouteName.pointTestQuestionScreen,
                  actionEvent: FBActionEvent.fbActionSubmit,
                  sectionName: FBSectionEvent.fbSectionPointTest);

              pointTestBloc.handleQuestionToDisplay(
                  context: context,
                  status: PointTestQuesStatus.TEST_COMPLETION,
                  needToValidate: true,
                  pageController: pageController,
                  userId: userData!.userId);
            } else {
              //For next question
              pointTestBloc.handleQuestionToDisplay(
                  currentVisibleQuestionData: questionData,
                  context: context,
                  status: PointTestQuesStatus.NEXT_QUESTION,
                  needToValidate: true,
                  pageController: pageController);
            }
          },
          child: Container(
            width: 45.0,
            height: 45.0,
            // width: 40,
            // height: 36.0,
            decoration: BoxDecoration(
                color: AppColorStyle.cyan(context),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                (pointTestBloc.getPageViewIndexValue ==
                        (pointTestBloc.visibleQuestionList.value.length - 1))
                    ? IconsSVG.correctIcon
                    : IconsSVG.rightIcon,
                colorFilter: ColorFilter.mode(
                  AppColorStyle.textWhite(context),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

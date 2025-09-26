import 'dart:async';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/custom_question/custom_question_bloc.dart';
import 'package:occusearch/features/custom_question/model/custom_question_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_bloc.dart';

class DashboardCustomQuestionWidget extends StatefulWidget {
  final int currentQuestionIndex = 0;

  final List<CustomQuestions> customQuestionsList;

  const DashboardCustomQuestionWidget(
      {Key? key, required this.customQuestionsList})
      : super(key: key);

  @override
  State<DashboardCustomQuestionWidget> createState() =>
      _DashboardCustomQuestionWidgetState();
}

class _DashboardCustomQuestionWidgetState
    extends State<DashboardCustomQuestionWidget> with TickerProviderStateMixin {
  final _customQuestionBloc = CustomQuestionBloc();
  final VisaFeesBloc _visaFeesBloc = VisaFeesBloc();

  /*
  late AnimationController animationControllerForText = AnimationController(
      duration: const Duration(milliseconds: 1500), vsync: this);

  late Animation<double> animation = CurvedAnimation(
      parent: animationControllerForText,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut));

   */

  late AnimationController animationControllerForText;
  late Animation<double> animation;

  //CUSTOM QUESTION TIMER
  Timer? _customQuestionTimer;

  @override
  void initState() {
    animationControllerForText = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    animation = CurvedAnimation(
        parent: animationControllerForText,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut));

    animationControllerForText.reset();
    animationControllerForText.forward();
    _customQuestionTimer =
        Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      List<CustomQuestions>? pendingQuestionList = widget.customQuestionsList
          .where((element) => element.answer == "" && element.primary == true)
          .toList();
      CustomQuestionBloc.setDashBoardIndexHandler(pendingQuestionList);
      animationControllerForText.reset();
      animationControllerForText.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _customQuestionTimer?.cancel();
    animationControllerForText.dispose();
    animation.isDismissed;
    CustomQuestionBloc.setDashboardIndexValue = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RxMultiBlocProvider(
      providers: [
        RxBlocProvider<VisaFeesBloc>(create: (context) => _visaFeesBloc),
        RxBlocProvider<CustomQuestionBloc>(
            create: (context) => _customQuestionBloc),
      ],
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.0,
        // height: MediaQuery.of(context).size.height / 3.7,
        padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: Constants.commonPadding),
        color: AppColorStyle.backgroundVariant(context),
        child: StreamBuilder(
            stream: CustomQuestionBloc.getDashboardIndexStream,
            builder: (context, snapshot) {
              List<CustomQuestions>? pendingQuestionList = widget
                  .customQuestionsList
                  .where((element) => element.answer == "")
                  .toList();
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  pendingQuestionList.isNotEmpty &&
                  snapshot.hasData) {
                var index = snapshot.data ?? 0;
                final questionData = pendingQuestionList[index];
                return Stack(
                  children: [
                    RotationTransition(
                      turns: const AlwaysStoppedAnimation(3.3 / 360),
                      // turns: const AlwaysStoppedAnimation(3.5/ 360),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColorStyle.primaryVariant3(context)
                              .withOpacity(0.4),
                          // color: AppColorStyle.teal(context),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: -3.5 / 70,
                      // angle: -4.5 / 70,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColorStyle.primaryVariant3(context)
                              .withOpacity(0.5),
                          // color: AppColorStyle.red(context),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColorStyle.primaryVariant3(context),
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(StringHelper.likeToKnowSome,
                                    style: AppTextStyle.captionMedium(context,
                                        AppColorStyle.textHint(context))),
                                Text(
                                    "${index + 1}/${pendingQuestionList.length}",
                                    style: AppTextStyle.captionSemiBold(context,
                                        AppColorStyle.primary(context))),
                              ],
                            ),
                          ),
                          FadeTransition(
                            opacity: animation,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 10, bottom: 15),
                              // height: 60,
                              child: Text(
                                questionData.question.toString(),
                                style: AppTextStyle.subTitleRegular(
                                    context, AppColorStyle.text(context)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 10),
                            // padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ButtonWidget(
                              onTap: () {
                                _customQuestionTimer?.cancel();
                                CustomQuestionBloc.setDashboardIndexValue = 0;
                                Map<String, dynamic> param = {
                                  'pendingQuestionList': pendingQuestionList,
                                };
                                //HERE WE PASS PENDING QUESTIONS LIST
                                GoRoutesPage.go(
                                    mode: NavigatorMode.push,
                                    moveTo: RouteName.customQuestion,
                                    param: param);
                              },
                              title: StringHelper.startAnswering,
                              logActionEvent: FBActionEvent
                                  .fbActionUserDashboardCustomQuestionCard,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }
}

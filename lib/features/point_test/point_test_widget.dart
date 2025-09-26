import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/point_test/point_test_bloc.dart';
import 'package:occusearch/features/point_test/point_test_model/point_test_ques_model.dart';

class PointTestWidget {
  // Top header UI
  static Widget headerWidget(
      BuildContext context, PointTestBloc pointTestBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [PointTestWidget.totalPointCountWidget(context, pointTestBloc)],
    );
  }

  // Total Point count based on given answer UI
  static Widget totalPointCountWidget(context, PointTestBloc pointTestBloc) {
    return StreamBuilder(
      stream: pointTestBloc.totalScoreCount,
      builder: (_, snapshot) {
        String score = (snapshot.hasData && snapshot.data != null)
            ? snapshot.data!.toString()
            : "0";
        return Row(
          children: [
            Text(
              StringHelper.pointTestTotalPoints,
              style: AppTextStyle.titleSemiBold(
                  context, AppColorStyle.text(context)),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 750),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(score,
                  style: AppTextStyle.titleSemiBold(
                      context, AppColorStyle.text(context)),
                  key: ValueKey<int>(
                    int.parse(score),
                  )),
            ),
          ],
        );
      },
    );
  }

  static Widget footerWidget(
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
                      width: 40.0,
                      height: 36.0,
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
          onTap: () {
            if (pointTestBloc.getPageViewIndexValue ==
                (pointTestBloc.visibleQuestionList.value.length - 1)) {
              // For submit question Data
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
            width: 40,
            height: 36.0,
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

  static Widget pointTestProgressNavigator(
      BuildContext context, PointTestBloc pointTestBLoc, onCloseClick) {
    //double value = (pointTestBLoc.pageViewIndex.value + 1) /pointTestBLoc.visibleQuestionList.value.length;
    return StreamBuilder(
      stream: pointTestBLoc.pageViewIndex,
      builder: (_, snapshot) {
        double value = 0.1;
        if (snapshot.hasData && snapshot.data != null) {
          value = (snapshot.data! + 1) /
              pointTestBLoc.visibleQuestionList.value.length;
        }
        return Column(
          children: [
            Row(
              children: [
                Text(
                  "Question  ${(pointTestBLoc.pageViewIndex.value + 1).toString().padLeft(2, '0')}/${pointTestBLoc.visibleQuestionList.value.length}",
                  style: AppTextStyle.detailsRegular(
                      context, AppColorStyle.textCaption(context)),
                ),
                const Spacer(),
                InkWellWidget(
                    child: Text(
                      StringHelper.pointTestSkipAll,
                      style: AppTextStyle.detailsMedium(
                          context, AppColorStyle.textCaption(context)),
                    ),
                    onTap: () => onCloseClick())
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 3.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: ((pointTestBLoc.pageViewIndex.value).isInfinite ||
                            (pointTestBLoc.pageViewIndex.value).isNaN) &&
                        (pointTestBLoc
                                .visibleQuestionList.value.length.isInfinite ||
                            pointTestBLoc
                                .visibleQuestionList.value.length.isNaN)
                    ? Container()
                    : TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: value),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, _) => LinearProgressIndicator(
                          minHeight: 5.0,
                          value: pointTestBLoc.visibleQuestionList.value.isEmpty
                              ? 0.0
                              : value,
                          backgroundColor:
                              AppColorStyle.surfaceVariant(context),
                          color: AppColorStyle.cyan(context),
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Point Test Question:- Option UI + Logic handle here
  static Widget pointTestOptionsWidget(BuildContext context,
      PointTestBloc pointTestBloc, Questionlist questionData) {
    List<Option> options = questionData.option!;
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: options.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => InkWellWidget(
            child: optionRow(context, options, index, pointTestBloc),
            onTap: () {
              pointTestBloc.onOptionSelection(questionData,
                  options[index].oid ?? 0, SelectedOptionType.OPTION_SELECTION);
            }),
      ),
    );
  }

  static Widget optionRow(BuildContext context, List<Option> options, int index,
      PointTestBloc pointTestBloc) {
    return StreamBuilder(
      stream: options[index].selection,
      builder: (_, snapshot) {
        bool isSelected = (snapshot.hasData) ? snapshot.data! : false;

        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColorStyle.cyan(context)
                  : ThemeConstant.cyanVariant2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 45,
                  child: Center(
                    child: Text(
                      options[index].ovalue == "0" ||
                              options[index].ovalue == "00"
                          ? "0"
                          : options[index].ovalue.toString().padLeft(2, '0'),
                      style: AppTextStyle.detailsBold(
                          context,
                          isSelected
                              ? AppColorStyle.textWhite(context)
                              : ThemeConstant.textDetail),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColorStyle.cyan(context)
                          : AppColorStyle.backgroundVariant(context),
                    ),
                    // Define how long the animation should take.
                    duration: Duration(
                        milliseconds: /*options[index].isSelected*/
                            isSelected ? 750 : 0),
                    // Provide an optional curve to make the animation feel smoother.
                    curve: Curves.fastOutSlowIn,
                    child: Text(
                      softWrap: true,
                      options[index].oname ?? "",
                      style: AppTextStyle.detailsRegular(
                          context,
                          isSelected
                              ? AppColorStyle.textWhite(context)
                              : AppColorStyle.textDetail(context)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

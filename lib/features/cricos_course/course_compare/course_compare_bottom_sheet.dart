// ignore_for_file: use_build_context_synchronously

import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/button_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_detail/model/course_detail_model.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';

class CourseCompareBottomSheet {
  static showCourseCompareBottomSheet(BuildContext context,
      CourseDetailData mainCourseData, CoursesBloc coursesBloc) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        String courseName;
        if (mainCourseData.courseName != null &&
            mainCourseData.courseName!.isNotEmpty &&
            mainCourseData.courseName!.contains("(")) {
          courseName = mainCourseData.courseName!
              .substring(0, mainCourseData.courseName!.indexOf("("));
        } else {
          courseName = mainCourseData.courseName ?? "";
        }
        return Container(
          color: AppColorStyle.backgroundVariant(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        StringHelper.compareQueue,
                        style: AppTextStyle.titleSemiBold(
                            context, AppColorStyle.text(context)),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    InkWellWidget(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        IconsSVG.closeIcon,
                        width: 14,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24.0),
                              Text(courseName.toString(),
                                  style: AppTextStyle.detailsMedium(
                                      context, AppColorStyle.text(context))),
                              const SizedBox(height: 10.0),
                              Container(
                                  decoration: BoxDecoration(
                                      color: AppColorStyle.primaryVariant3(
                                          context),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    child: Text(
                                        "${StringHelper.cricosText} ${mainCourseData.courseCode!}",
                                        style: AppTextStyle.captionSemiBold(
                                            context,
                                            AppColorStyle.primary(context))),
                                  )),
                              const SizedBox(height: 5.0),
                              Text(mainCourseData.institutionName!,
                                  style: AppTextStyle.captionRegular(context,
                                      AppColorStyle.textDetail(context))),
                              const SizedBox(height: 20.0)
                            ]),
                      ),
                    ),
                    VerticalDivider(
                      color: AppColorStyle.textHint(context),
                      thickness: 1,
                    ),
                    const SizedBox(width: 10),
                    StreamBuilder(
                        stream: coursesBloc.viewSelectedCourseToCompare.stream,
                        builder: (_, snapshotForView) {
                          return StreamBuilder(
                            stream: coursesBloc.selectedCourseObject.stream,
                            builder: (_, snapshot) {
                              String circosCourseName = "";
                              if (snapshot.data != null) {
                                if (snapshot.data!.courseName!.isNotEmpty &&
                                    snapshot.data!.courseName!.contains("(")) {
                                  circosCourseName = snapshot.data!.courseName!
                                      .substring(
                                          0,
                                          snapshot.data!.courseName!
                                              .indexOf("("));
                                } else {
                                  circosCourseName =
                                      snapshot.data!.courseName ?? "";
                                }
                              }
                              return (snapshot.data != null &&
                                      snapshot.hasData &&
                                      snapshotForView.data != null &&
                                      snapshotForView.data == true)
                                  ? Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWellWidget(
                                              onTap: () {
                                                //to remove course name and show add course widget
                                                coursesBloc
                                                    .viewSelectedCourseToCompare
                                                    .sink
                                                    .add(false);
                                              },
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: SvgPicture.asset(
                                                  IconsSVG.courseDeleteIcon,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ),
                                            Text(circosCourseName,
                                                style:
                                                    AppTextStyle.detailsMedium(
                                                        context,
                                                        AppColorStyle.text(
                                                            context))),
                                            const SizedBox(height: 10.0),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: AppColorStyle
                                                        .primaryVariant3(
                                                            context),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                                  child: Text(
                                                      "${StringHelper.cricosText} ${snapshot.data!.courseCode!}",
                                                      style: AppTextStyle
                                                          .captionSemiBold(
                                                              context,
                                                              AppColorStyle
                                                                  .primary(
                                                                      context))),
                                                )),
                                            const SizedBox(height: 5.0),
                                            Text(
                                                snapshot.data!.institutionName!,
                                                style:
                                                    AppTextStyle.captionRegular(
                                                        context,
                                                        AppColorStyle
                                                            .textDetail(
                                                                context))),
                                            const SizedBox(height: 10.0)
                                          ],
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 24.0),
                                              Text(
                                                  StringHelper.addDesireCourses,
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyle
                                                      .detailsMedium(
                                                          context,
                                                          AppColorStyle.text(
                                                              context))),
                                              const SizedBox(height: 10.0),
                                              InkWellWidget(
                                                onTap: () async {
                                                  var params = {
                                                    "isFromCompare": true
                                                  };
                                                  CourseList result =
                                                      await context.push<
                                                              dynamic>(
                                                          RouteName.root +
                                                              RouteName
                                                                  .coursesListScreen,
                                                          extra: params);
                                                  printLog(
                                                      "Result :-> ${result.runtimeType}");
                                                  if (result.courseCode !=
                                                          null &&
                                                      result.courseCode!
                                                          .isNotEmpty) {
                                                    if (mainCourseData
                                                            .courseCode ==
                                                        result.courseCode) {
                                                      //TODO: change toast message after talking to rahul.
                                                      Toast.show(context,
                                                          message:
                                                              StringHelper.compareCourseValidationMsg,
                                                          type:
                                                              Toast.toastError,
                                                          duration: 3);
                                                    } else {
                                                      coursesBloc
                                                              .setSelectedCourseObject =
                                                          result;
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: AppColorStyle
                                                            .primaryVariant1(
                                                                context),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5.0))),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          IconsSVG.searchIcon,
                                                          width: 20,
                                                          height: 20,
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                            AppColorStyle
                                                                .textWhite(
                                                                    context),
                                                            BlendMode.srcIn,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5.0),
                                                        Text(
                                                            StringHelper
                                                                .searchHere,
                                                            style: AppTextStyle
                                                                .captionRegular(
                                                                    context,
                                                                    AppColorStyle
                                                                        .textWhite(
                                                                            context))),
                                                      ],
                                                    )),
                                              ),
                                              const SizedBox(height: 10.0)
                                            ]),
                                      ),
                                    );
                            },
                          );
                        })
                  ],
                ),
              ),

              Divider(thickness: 1.0, color: AppColorStyle.textHint(context)),

              //Compare button
              StreamBuilder(
                stream: coursesBloc.viewSelectedCourseToCompare.stream,
                builder: (_, snapshotForView) {
                  return StreamBuilder(
                      stream: coursesBloc.selectedCourseObject.stream,
                      builder: (_, snapshot) {
                        return Column(
                          children: [
                            SizedBox(
                                height: (snapshot.data != null &&
                                        snapshot.hasData &&
                                        snapshotForView.data != null &&
                                        snapshotForView.data == true)
                                    ? 10.0
                                    : 30.0),
                            Visibility(
                              visible: (snapshot.data != null &&
                                  snapshot.hasData &&
                                  snapshotForView.data != null &&
                                  snapshotForView.data == true),
                              //Add condition that if other course is added then only this button is visible,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20.0, left: 20.0, right: 20.0),
                                  child: ButtonWidget(
                                      title: StringHelper.compare2Courses,
                                      textColor:
                                          AppColorStyle.textWhite(context),
                                      arrowIconVisibility: true,
                                      onTap: () {
                                        var params = {
                                          "firstCourseData": mainCourseData,
                                          "compareCourseData": coursesBloc
                                              .selectedCourseObject.value,
                                        };
                                        Navigator.pop(context);
                                        GoRoutesPage.go(
                                            mode: NavigatorMode.push,
                                            moveTo: RouteName
                                                .compareCourseDetailScreen,
                                            param: params);
                                      },
                                      logActionEvent: '',
                                      titleTextStyle:
                                          AppTextStyle.detailsSemiBold(
                                              context,
                                              AppColorStyle.textWhite(
                                                  context))),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

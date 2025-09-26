import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/model/related_courses_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_shimmer.dart';

//Related Courses Widget
class RelatedCoursesWidget extends StatelessWidget {
  const RelatedCoursesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final soUnitGroupBloc =
        RxBlocProvider.of<SoUnitGroupAndGeneralBloc>(context);

    return soUnitGroupBloc.relatedCourseLoading.value
        ? SoUnitGroupAndGeneralShimmer.relatedOccupationShimmer(context)
        : StreamBuilder(
            stream: soUnitGroupBloc.getRelatedCoursesListStream,
            builder: (context, snapshot) {
              final List<RelatedCoursesList>? relatedCoursesList =
                  snapshot.data;
              return snapshot.data != null && snapshot.data!.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColorStyle.background(context),
                      ),
                      padding: const EdgeInsets.only(bottom: 20, top: 15),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  StringHelper.relatedCourseText,
                                  style: AppTextStyle.titleSemiBold(
                                      context, AppColorStyle.text(context)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColorStyle.primarySurface2(context),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                  ),
                                  child: Text(
                                    "${relatedCoursesList?.length}",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.captionMedium(context,
                                        AppColorStyle.primary(context)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                              itemCount: relatedCoursesList?.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                RelatedCoursesList relatedCourses =
                                    relatedCoursesList![index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWellWidget(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 15.0,
                                              bottom:
                                                  ((relatedCoursesList.length) -
                                                              1 !=
                                                          index)
                                                      ? 15.0
                                                      : 0.0,
                                              right: 20.0,
                                              left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      relatedCourses
                                                              .courseCode ??
                                                          '',
                                                      style: AppTextStyle
                                                          .detailsSemiBold(
                                                              context,
                                                              AppColorStyle
                                                                  .primary(
                                                                      context)),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      relatedCourses
                                                              .courseName ??
                                                          '',
                                                      style: AppTextStyle
                                                          .detailsRegular(
                                                              context,
                                                              AppColorStyle
                                                                  .text(
                                                                      context)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SvgPicture.asset(
                                                IconsSVG.arrowHalfRight,
                                                colorFilter: ColorFilter.mode(
                                                  AppColorStyle.text(context),
                                                  BlendMode.srcIn,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          CourseList courseData = CourseList(
                                            courseCode:
                                                relatedCourses.courseCode,
                                            ascedCode: relatedCourses.ascedCode,
                                          );

                                          GoRoutesPage.go(
                                              mode: NavigatorMode.push,
                                              moveTo:
                                                  RouteName.coursesDetailScreen,
                                              param: courseData);
                                        }),
                                    ((relatedCoursesList.length) - 1 != index)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Divider(
                                                color: AppColorStyle
                                                    .disableVariant(context),
                                                thickness: 0.5),
                                          )
                                        : Container(),
                                  ],
                                );
                              })
                        ],
                      ),
                    )
                  : const SizedBox();
            });
  }
}

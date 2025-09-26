import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_course_table.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';
import 'package:occusearch/features/discover_dream/widget/discover_dream_widget_shimmer.dart';

class CourseRecentSearchWidget extends StatelessWidget {
  final CoursesBloc coursesBloc;

  const CourseRecentSearchWidget({Key? key, required this.coursesBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RecentCourseTable>>(
      stream: coursesBloc.courseRecentUpdateStream,
      builder: (_, snapshot) {
        return (snapshot.hasData && snapshot.data != null)
            ? Visibility(
                visible: snapshot.data!.isNotEmpty,
                child: Container(
                  color: AppColorStyle.backgroundVariant(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 10, left: Constants.commonPadding),
                        child: Text(StringHelper.recentSearchText,
                            style: AppTextStyle.titleSemiBold(
                                context, AppColorStyle.text(context))),
                      ),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length > 5
                                ? 5
                                : snapshot.data!.length,
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>
                                recentSearchListView(
                                    context, snapshot.data!, index)),
                      ),
                      Divider(
                          color: AppColorStyle.background(context),
                          thickness: 10),
                    ],
                  ),
                ),
              )
            : const RecentSearchShimmer();
      },
    );
  }

  Widget recentSearchListView(BuildContext context,
      List<RecentCourseTable> courseRecentList, int index) {
    return Padding(
      padding: EdgeInsets.only(
          top: 5,
          left: index == 0 ? 5 : 15,
          right: index == 2 ? 5 : 0,
          bottom: 20),
      child: InkWellWidget(
        onTap: () {
          goToCourseDetailScreen(courseRecentList[index]);
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColorStyle.primary(context),
            ),
            width: MediaQuery.of(context).size.width -
                (Constants.commonPadding * 3),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                      color: AppColorStyle.primary(context),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0))),
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(
                    IconsSVG.dashboardRecentUpdateCard,
                    colorFilter: ColorFilter.mode(
                      AppColorStyle.primarySurface2(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                recentSearchListItem(context, courseRecentList, index),
              ],
            )),
      ),
    );
  }

  Widget recentSearchListItem(BuildContext context,
      List<RecentCourseTable> courseRecentList, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    "${StringHelper.cricosText}: ${courseRecentList[index].cricos}",
                    style: AppTextStyle.subTitleSemiBold(
                        context, AppColorStyle.textWhite(context))),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("${courseRecentList[index].courseName}",
                  style: AppTextStyle.detailsMedium(
                      context, AppColorStyle.textWhite(context)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                courseRecentList[index].courseDurationWeeks?.isNotEmpty == true
                    ? Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 2.0, right: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.courseDurationIcon,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                                "${Utility.getYearFromWeek(int.parse(courseRecentList[index].courseDurationWeeks ?? "1"))} year",
                                style: AppTextStyle.captionMedium(
                                    context, AppColorStyle.textWhite(context))),
                          ),
                        ],
                      )
                    : Container(width: 60),
                const SizedBox(width: 20.0),
                Visibility(
                  visible:
                      courseRecentList[index].courseLevel?.isNotEmpty == true,
                  child: Flexible(
                    child: IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        height: 25.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColorStyle.primaryVariant1(context)),
                        child: Center(
                          child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "${courseRecentList[index].courseLevel}",
                              style: AppTextStyle.captionMedium(
                                  context, AppColorStyle.textWhite(context))),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  goToCourseDetailScreen(RecentCourseTable courseList) {
    CourseList? courseRowData;
    RecentCourseTable convertedData = courseList;
    courseRowData = CourseList(
        ascedCode: convertedData.ascedCode.toString(),
        courseCode: convertedData.cricos.toString(),
        courseName: convertedData.courseName);

    GoRoutesPage.go(
        mode: NavigatorMode.push,
        moveTo: RouteName.coursesDetailScreen,
        param: courseRowData);
  }
}

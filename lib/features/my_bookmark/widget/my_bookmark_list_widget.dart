import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';
import 'package:occusearch/features/my_bookmark/my_bookmark_bloc.dart';
import 'package:occusearch/features/my_bookmark/my_bookmark_list_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';

class MyBookmarkListWidget extends StatelessWidget {
  final MyBookmarkBloc myBookmarkBloc;

  const MyBookmarkListWidget({Key? key, required this.myBookmarkBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: myBookmarkBloc.getBookmarkListStream,
        builder: (context, snapshot) {
          final String noDataMessage = myBookmarkBloc.bookmarkTypeStream.value
                  .toString()
                  .contains("COURSE")
              ? StringHelper.courseData
              : myBookmarkBloc.bookmarkTypeStream.value
                      .toString()
                      .contains("OCCUPATION")
                  ? StringHelper.occupationData
                  : StringHelper.data;
          final List<MyBookmarkTable>? allBookmarkList = snapshot.data;
          return (snapshot.hasData && snapshot.data != null)
              ? Expanded(
                  child: allBookmarkList != null && allBookmarkList.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: allBookmarkList.length,
                          itemBuilder: (context, index) {
                            return InkWellWidget(
                              onTap: () {
                                if (NetworkController.isInternetConnected ==
                                    false) {
                                  Toast.show(context,
                                      message: StringHelper.internetConnection,
                                      gravity: Toast.toastTop,
                                      duration: 3,
                                      type: Toast.toastError);
                                  return;
                                }
                                if (allBookmarkList[index].type ==
                                    BookmarkType.COURSE.name) {
                                  CourseList courseData = CourseList(
                                    courseCode: snapshot.data?[index].code,
                                    ascedCode: snapshot.data?[index].subCode,
                                  );
                                  GoRoutesPage.go(
                                      mode: NavigatorMode.push,
                                      moveTo: RouteName.coursesDetailScreen,
                                      param: courseData);
                                } else if (allBookmarkList[index].type ==
                                    BookmarkType.OCCUPATION.name) {
                                  OccupationRowData occuRowData =
                                      OccupationRowData(
                                          id: snapshot.data?[index].code,
                                          mainId: snapshot.data?[index].subCode,
                                          name: snapshot.data?[index].name);
                                  GoRoutesPage.go(
                                      mode: NavigatorMode.push,
                                      moveTo: RouteName.occupationSearchScreen,
                                      param: occuRowData);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      allBookmarkList[index]
                                                              .code ??
                                                          '',
                                                      style: AppTextStyle.subTitleMedium(
                                                          context,
                                                          (allBookmarkList[
                                                                          index]
                                                                      .type ==
                                                                  BookmarkType
                                                                      .COURSE
                                                                      .name)
                                                              ? AppColorStyle
                                                                  .red(context)
                                                              : AppColorStyle
                                                                  .primary(
                                                                      context)),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    (allBookmarkList[index]
                                                                .type ==
                                                            BookmarkType
                                                                .COURSE.name)
                                                        ? Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                    vertical:
                                                                        3.0),
                                                            decoration: BoxDecoration(
                                                                color: AppColorStyle
                                                                    .redText(
                                                                        context),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100.0)),
                                                            child: Text(
                                                              BookmarkType
                                                                      .COURSE
                                                                      .name[0]
                                                                      .toUpperCase() +
                                                                  BookmarkType
                                                                      .COURSE
                                                                      .name
                                                                      .substring(
                                                                          1)
                                                                      .toLowerCase(),
                                                              //BookmarkType.COURSE.name.toLowerCase(),
                                                              style: AppTextStyle
                                                                  .captionMedium(
                                                                      context,
                                                                      AppColorStyle
                                                                          .red(
                                                                              context)),
                                                            ),
                                                          )
                                                        : (allBookmarkList[
                                                                        index]
                                                                    .type ==
                                                                BookmarkType
                                                                    .OCCUPATION
                                                                    .name)
                                                            ? Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                    vertical:
                                                                        3.0),
                                                                decoration: BoxDecoration(
                                                                    color: AppColorStyle
                                                                        .primarySurfaceWithOpacity(
                                                                            context),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100.0)),
                                                                child: Text(
                                                                    BookmarkType
                                                                            .OCCUPATION
                                                                            .name[
                                                                                0]
                                                                            .toUpperCase() +
                                                                        BookmarkType
                                                                            .OCCUPATION
                                                                            .name
                                                                            .substring(
                                                                                1)
                                                                            .toLowerCase(),
                                                                    //BookmarkType.OCCUPATION.name.toLowerCase(),
                                                                    style: AppTextStyle.captionMedium(
                                                                        context,
                                                                        AppColorStyle.primary(
                                                                            context))),
                                                              )
                                                            : Container(),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  allBookmarkList[index].name ??
                                                      '',
                                                  style: AppTextStyle
                                                      .captionRegular(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0),
                                            child: SvgPicture.asset(
                                              IconsSVG.arrowHalfRight,
                                              colorFilter: ColorFilter.mode(
                                                AppColorStyle.text(context),
                                                BlendMode.srcIn,
                                              ),
                                              width: 20.0,
                                              height: 20.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    (allBookmarkList.length - 1) != index
                                        ? Divider(
                                            color: AppColorStyle.borderColors(
                                                context),
                                            thickness: 0.5,
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: NoDataFoundScreen(
                            noDataTitle: "No $noDataMessage has been added",
                            noDataIcon: IconsSVG.icNoCoursesFound,
                            isButtonVisible: true,
                            noDataSubTitle:
                                "Looks like you don’t have anything in your list",
                            buttonText:
                                "Let's find best suitable $noDataMessage",
                            isOccupation: myBookmarkBloc
                                    .bookmarkTypeStream.value
                                    .toString()
                                    .contains("OCCUPATION")
                                ? true
                                : false,
                          ),
                        ),
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 10),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: MyBookmarkListShimmer(),
                      );
                    },
                  ),
                );
        });
  }
}

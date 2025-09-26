import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';
import 'package:occusearch/features/dashboard/dashboard_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_shimmer.dart';

class DashboardBookmarkOccupationWidget extends StatelessWidget {
  final GlobalBloc? globalBloc;

  const DashboardBookmarkOccupationWidget({Key? key, this.globalBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = RxBlocProvider.of<DashboardBloc>(context);

    return StreamBuilder(
        stream: dashboardBloc.bookmarkByTypeListStream.stream,
        builder: (context, snapshot) {
          final List<MyBookmarkTable>? allBookmarkList = snapshot.data;
          //Occupation list for free trial or expired plan
          List<MyBookmarkTable> occupationList = [];
          if (allBookmarkList != null && allBookmarkList.isNotEmpty) {
            for (int i = 0; i < allBookmarkList.length; i++) {
              // Check if the bookmark is of type OCCUPATION
              if (allBookmarkList[i].type == BookmarkType.OCCUPATION.name) {
                occupationList.add(allBookmarkList[i]);
              }
            }
          }
          //------------------

          return (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data != [])
              ? Visibility(
                  visible: allBookmarkList!.isNotEmpty == true,
                  child: Column(
                    children: [
                      Container(
                          height: 15.0,
                          color: AppColorStyle.backgroundVariant(context)),
                      Container(
                        color: AppColorStyle.background(context),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Constants.commonPadding,
                                  vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(StringHelper.myBookmarks,
                                      style: AppTextStyle.titleSemiBold(
                                        context,
                                        AppColorStyle.text(context),
                                      )),
                                  Visibility(
                                    visible: allBookmarkList.length > 5,
                                    child: InkWellWidget(
                                      onTap: () {
                                        GoRoutesPage.go(
                                          mode: NavigatorMode.push,
                                          moveTo:
                                              RouteName.myBookmarkListScreen,
                                        );
                                      },
                                      child: Text(StringHelper.viewAllText,
                                          style: AppTextStyle.detailsRegular(
                                              context,
                                              AppColorStyle.primaryVariant2(
                                                  context))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  //in Paid plan-show whole list or list of 5 latest book mark, in free show only last 3
                                  globalBloc?.subscriptionType == AppType.PAID
                                      ? (allBookmarkList.length) > 5
                                          ? 5
                                          : allBookmarkList.length
                                      : occupationList.length >= 3
                                          ? 3
                                          : occupationList.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  BookmarkListWidget(
                                context: context,
                                index: index,
                                allBookmarkList:
                                    globalBloc?.subscriptionType == AppType.PAID
                                        ? allBookmarkList
                                        : occupationList,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : NetworkController.isInternetConnected
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: OccupationListShimmer(),
                        );
                      },
                    )
                  : Container();
        });
  }
}

class BookmarkListWidget extends StatelessWidget {
  final BuildContext context;
  final int index;
  final List<MyBookmarkTable>? allBookmarkList;

  const BookmarkListWidget(
      {Key? key,
      required this.context,
      required this.index,
      required this.allBookmarkList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? listLength =
        (allBookmarkList?.length ?? 0) > 5 ? 5 : allBookmarkList?.length;

    return InkWellWidget(
      onTap: () {
        if (NetworkController.isInternetConnected == false) {
          Toast.show(context,
              message: StringHelper.internetConnection,
              gravity: Toast.toastTop,
              duration: 3,
              type: Toast.toastError);
          return;
        }
        if (allBookmarkList?[index].type == BookmarkType.COURSE.name) {
          CourseList courseData = CourseList(
            courseCode: allBookmarkList?[index].code,
            ascedCode: allBookmarkList?[index].subCode,
          );

          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.coursesDetailScreen,
              param: courseData);
        } else if (allBookmarkList?[index].type ==
            BookmarkType.OCCUPATION.name) {
          OccupationRowData occuRowData = OccupationRowData(
              id: allBookmarkList?[index].code,
              mainId: allBookmarkList?[index].subCode,
              name: allBookmarkList?[index].name);
          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.occupationSearchScreen,
              param: occuRowData);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColorStyle.background(context),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.commonPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("${allBookmarkList?[index].code}",
                                style: AppTextStyle.detailsSemiBold(
                                    context, AppColorStyle.primary(context))),
                            const SizedBox(
                              width: 10,
                            ),
                            (allBookmarkList?[index].type ==
                                    BookmarkType.COURSE.name)
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 3.0),
                                    decoration: BoxDecoration(
                                        color: AppColorStyle.redText(context),
                                        borderRadius:
                                            BorderRadius.circular(100.0)),
                                    child: Text(
                                      BookmarkType.COURSE.name[0]
                                              .toUpperCase() +
                                          BookmarkType.COURSE.name
                                              .substring(1)
                                              .toLowerCase(),
                                      //BookmarkType.COURSE.name.toLowerCase(),
                                      style: AppTextStyle.captionMedium(
                                          context, AppColorStyle.red(context)),
                                    ),
                                  )
                                : (allBookmarkList?[index].type ==
                                        BookmarkType.OCCUPATION.name)
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 3.0),
                                        decoration: BoxDecoration(
                                            color: AppColorStyle
                                                .primarySurfaceWithOpacity(
                                                    context),
                                            borderRadius:
                                                BorderRadius.circular(100.0)),
                                        child: Text(
                                            BookmarkType.OCCUPATION.name[0]
                                                    .toUpperCase() +
                                                BookmarkType.OCCUPATION.name
                                                    .substring(1)
                                                    .toLowerCase(),
                                            /*BookmarkType.OCCUPATION.name
                                                .toLowerCase()*/
                                            style: AppTextStyle.captionMedium(
                                                context,
                                                AppColorStyle.primary(
                                                    context))),
                                      )
                                    : Container()
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("${allBookmarkList?[index].name}",
                            style: AppTextStyle.detailsRegular(
                                context, AppColorStyle.text(context))),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        IconsSVG.arrowHalfRight,
                        colorFilter: ColorFilter.mode(
                          AppColorStyle.text(context),
                          BlendMode.srcIn,
                        ),
                        width: 20.0,
                        height: 20.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            (listLength! - 1) != index
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: Constants.commonPadding, top: 10, bottom: 10),
                    child: Divider(
                        color: AppColorStyle.borderColors(context),
                        thickness: 0.5),
                  )
                : const SizedBox(
                    height: 20,
                  ),
          ],
        ),
      ),
    );
  }
}

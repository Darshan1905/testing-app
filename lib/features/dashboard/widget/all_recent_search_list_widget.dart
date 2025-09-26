import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';
import 'package:occusearch/features/dashboard/dashboard_bloc.dart';
import 'package:occusearch/features/dashboard/model/recent_search_model.dart';
import 'package:occusearch/features/discover_dream/widget/discover_dream_widget_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';

class AllRecentSearchListWidget extends StatelessWidget {
  final bool isFromDashboard;
  final GlobalBloc? globalBloc;

  const AllRecentSearchListWidget(
      {Key? key, this.isFromDashboard = false, this.globalBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = RxBlocProvider.of<DashboardBloc>(context);

    return StreamBuilder(
      stream: dashboardBloc.getAllRecentSearchListStream,
      builder: (_, snapshot) {
        return (snapshot.hasData && snapshot.data != null)
            ? Container(
                width: double.infinity,
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
                          itemCount:
                              globalBloc?.subscriptionType == AppType.PAID
                                  ? snapshot.data!.length > 5
                                      ? 5
                                      : snapshot.data!.length
                                  : snapshot.data!.length >= 3
                                      ? 3
                                      : snapshot.data!.length,
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) =>
                              RecentSearchListview(
                                  recentSearchList: snapshot.data!,
                                  index: index)),
                    ),
                    // Divider(color: AppColorStyle.textWhite(context), thickness: 10),
                  ],
                ),
              )
            : isFromDashboard == false
                ? Expanded(
                    child: Center(
                      child: NoDataFoundScreen(
                        noDataTitle: "Your recent activity will be shown here.",
                        noDataIcon: IconsSVG.icNoActivityIcon,
                        isButtonVisible: false,
                      ),
                    ),
                  )
                : Container(
                    height: 15.0,
                    color: AppColorStyle.backgroundVariant(context));
      },
    );
  }
}

class RecentSearchListview extends StatelessWidget {
  final List<RecentSearchData> recentSearchList;
  final int index;

  const RecentSearchListview(
      {Key? key, required this.recentSearchList, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (recentSearchList.isNotEmpty)
        ? Padding(
            padding: EdgeInsets.only(
                top: 5,
                left: index == 0 ? 5 : 15,
                right: index == 2 ? 5 : 0,
                bottom: 20),
            child: InkWellWidget(
              onTap: () {
                if (NetworkController.isInternetConnected) {
                  if (recentSearchList[index].type ==
                      RecentSearchType.COURSE.name) {
                    CourseList courseData = CourseList(
                      courseCode: recentSearchList[index].code,
                      ascedCode: recentSearchList[index].mainId,
                    );

                    GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.coursesDetailScreen,
                        param: courseData);
                  } else if (recentSearchList[index].type ==
                      RecentSearchType.OCCUPATION.name) {
                    OccupationRowData occuRowData = OccupationRowData(
                        id: recentSearchList[index].code,
                        mainId: recentSearchList[index].mainId,
                        name: recentSearchList[index].name);
                    GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.occupationSearchScreen,
                        param: occuRowData);
                  }
                } else {
                  Toast.show(context,
                      message: StringHelper.internetConnection,
                      type: Toast.toastError,
                      duration: 2);
                }
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
                      RecentSearchListItem(
                          recentSearchList: recentSearchList, index: index)
                    ],
                  )),
            ),
          )
        //SHIMMER FOR RECENT SEARCH OCCUPATION
        : const RecentSearchShimmer();
  }
}

class RecentSearchListItem extends StatelessWidget {
  final OccupationDetailBloc searchOccuBloc = OccupationDetailBloc();
  final List<RecentSearchData> recentSearchList;
  final int index;

  RecentSearchListItem(
      {Key? key, required this.recentSearchList, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var skillColorList =
        Utility.getSkillLevelColor(recentSearchList[index].skillLevel ?? 0);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        (recentSearchList[index].type ==
                                RecentSearchType.COURSE.name)
                            ? "${StringHelper.cricosText}: ${recentSearchList[index].code}"
                            : "${StringHelper.anzscoText}: ${recentSearchList[index].code}",
                        style: AppTextStyle.subTitleSemiBold(
                            context, AppColorStyle.textWhite(context))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 3.0),
                      decoration: BoxDecoration(
                          color: AppColorStyle.textWhite(context),
                          borderRadius: BorderRadius.circular(100.0)),
                      child: Text(
                        (recentSearchList[index].type ==
                                RecentSearchType.COURSE.name)
                            ? RecentSearchType.COURSE.name[0].toUpperCase() +
                                RecentSearchType.COURSE.name
                                    .substring(1)
                                    .toLowerCase()
                            //RecentSearchType.COURSE.name.toLowerCase()
                            : RecentSearchType.OCCUPATION.name[0]
                                    .toUpperCase() +
                                RecentSearchType.OCCUPATION.name
                                    .substring(1)
                                    .toLowerCase(),
                        //RecentSearchType.OCCUPATION.name.toLowerCase(),
                        style: AppTextStyle.captionMedium(
                            context, AppColorStyle.primary(context)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("${recentSearchList[index].name}",
                  style: AppTextStyle.detailsRegular(
                      context, AppColorStyle.textWhite(context)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Visibility(
            visible: skillColorList.length > 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(StringHelper.skillLevelText,
                          style: AppTextStyle.captionRegular(
                              context, AppColorStyle.textWhite(context))),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var item in skillColorList)
                            Row(
                              children: [
                                Container(
                                  width: 25,
                                  height: 5,
                                  color: item,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                              ],
                            ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

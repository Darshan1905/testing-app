// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/dashboard/dashboard_bloc.dart';
import 'package:occusearch/features/dashboard/recent_updates/model/recent_update_model.dart';
import 'package:occusearch/features/dashboard/recent_updates/recent_update_list_shimmer.dart';
import 'package:occusearch/features/dashboard/recent_updates/recent_update_widget.dart';

class DashboardRecentUpdateWidget extends StatefulWidget {
  final GlobalBloc? globalBloc;

  const DashboardRecentUpdateWidget({Key? key, required this.globalBloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardRecentUpdateState();
}

class _DashboardRecentUpdateState extends State<DashboardRecentUpdateWidget>
    with TickerProviderStateMixin {
  DashboardBloc? _dashboardBloc;
  late AnimationController animationController;
  bool isPaidTrial = false;

  final PageController _recentUpdateController = PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.90,
  );

  @override
  void initState() {
    super.initState();
    if (widget.globalBloc?.subscriptionType == AppType.PAID) {
      isPaidTrial = true;
    } else {
      isPaidTrial = false;
    }
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = const Duration(milliseconds: 500);
  }

  @override
  Widget build(BuildContext context) {
    _dashboardBloc ??= RxBlocProvider.of<DashboardBloc>(context);
    return Container(
      color: AppColorStyle.backgroundVariant(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  StringHelper.dashboardRecentUpdate,
                  style: AppTextStyle.titleSemiBold(
                      context, AppColorStyle.text(context)),
                ),
                InkWellWidget(
                  onTap: () async {
                    if (true == await NetworkController.isConnected()) {
                      GoRoutesPage.go(
                          mode: NavigatorMode.push,
                          moveTo: RouteName.recentUpdateScreen);
                    } else {
                      Toast.show(context,
                          message: StringHelper.internetConnection,
                          type: Toast.toastError);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      StringHelper.viewAllText,
                      style: AppTextStyle.detailsRegular(
                          context, AppColorStyle.primaryVariant2(context)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<bool>(
            stream: _dashboardBloc?.isRecentUpdateLoading,
            builder: (context, snapshotLoading) {
              if (snapshotLoading.hasData &&
                  snapshotLoading.data != null &&
                  snapshotLoading.data == false) {
                return StreamBuilder<List<Recordset>>(
                    stream: _dashboardBloc?.getRecentUpdateList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final List<Recordset> recentUpdateList =
                            snapshot.data ?? [];
                        return SizedBox(
                          height: 130,
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: _recentUpdateController,
                            onPageChanged: (value) {},
                            itemCount:
                                isPaidTrial ? recentUpdateList.length : 3,
                            itemBuilder: (context, index) =>
                                RecentUpdateRowWidget(
                              data: recentUpdateList[index],
                              index: index,
                              animationController: animationController,
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: RecentUpdateListShimmer(1),
                        );
                      }
                    });
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RecentUpdateListShimmer(1),
                );
              }
            },
          ),
          const SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }
}

class RecentUpdateRowWidget extends StatelessWidget {
  final Recordset data;
  final AnimationController animationController;
  final int index;

  const RecentUpdateRowWidget(
      {Key? key,
      required this.data,
      required this.animationController,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final dateFormat = DateFormat('dd MMMM yyyy');
    late final utcFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final date = utcFormat.parse(data.createdDate ?? '');
    final latestUpdateDate = dateFormat.format(date);
    return InkWellWidget(
      onTap: () {
        FirebaseAnalyticLog.shared.eventTracking(
            screenName: RouteName.home,
            actionEvent: data.title ?? '',
            sectionName: FBSectionEvent.fbSectionRecentUpdates);
        double top = 20.0; //MediaQuery.of(context).viewPadding.top;
        RecentUpdateWidget.showRecentUpdateInSheet(
            context, data, top, animationController);
      },
      child: Padding(
        padding: EdgeInsets.only(left: index == 0 ? 0 : 0.0),
        child: Stack(alignment: Alignment.centerLeft, children: [
          Container(
            margin: EdgeInsets.only(left: index == 0 ? 0 : 5.0, right: 5.0),
            width: MediaQuery.of(context).size.width * 0.90,
            constraints: const BoxConstraints(minHeight: 50.0),
            decoration: BoxDecoration(
                color: AppColorStyle.primary(context),
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              IconsSVG.dashboardRecentUpdateCard,
              colorFilter: ColorFilter.mode(
                AppColorStyle.primarySurface2(context),
                BlendMode.srcIn,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Text(
                    data.title.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.detailsMedium(
                      context,
                      AppColorStyle.textWhite(context),
                    ),
                  ),
                ),
                /*Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      data.subTitle != null
                          ? data.subTitle.toString()
                          : "",
                      maxLines: 5,
                      overflow: TextOverflow.fade,
                      style: AppTextStyle.detailsRegular(
                        context,
                        AppColorStyle.textWhite(context),
                      ),
                    ),
                  ),
                ),*/
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        IconsSVG.icCalenderRecentUpdate,
                        height: 15,
                        width: 15,
                      ),
                      const SizedBox(width: 7.0),
                      Text(
                        data.createdDate == null ? "" : latestUpdateDate,
                        style: AppTextStyle.captionRegular(
                          context,
                          AppColorStyle.whiteTextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

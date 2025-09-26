import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/dashboard/dashboard_bloc.dart';
import 'package:occusearch/features/dashboard/model/unitgroup_occupationlist_model.dart';
import 'package:occusearch/features/discover_dream/widget/discover_dream_widget_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';

class BecauseYouSearchedWidget extends StatelessWidget {
  final GlobalBloc? globalBloc;

  const BecauseYouSearchedWidget({Key? key, this.globalBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = RxBlocProvider.of<DashboardBloc>(context);

    return StreamBuilder<UnitGroupOccupationListModel?>(
        stream: dashboardBloc.getUGCodeOccupationModelStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.isLoading == true) {
              return const RecentSearchShimmer();
            } else if (snapshot.data == null) {
              return Container();
            } else {
              return Column(
                children: [
                  // Container(
                  //     height: 15.0,
                  //     color: AppColorStyle.backgroundVariant(context)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(StringHelper.becauseYouSearched,
                                  style: AppTextStyle.titleSemiBold(
                                      context, AppColorStyle.text(context))),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data!.occupationCode} - ',
                                    style: AppTextStyle.detailsRegular(context,
                                        AppColorStyle.textHint(context)),
                                  ),
                                  Expanded(
                                    child: Text(
                                        snapshot.data!.occupationName ?? '',
                                        style: AppTextStyle.detailsRegular(
                                            context,
                                            AppColorStyle.textHint(context))),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                      StringHelper
                                          .occupationMainRelatedOccupations,
                                      style: AppTextStyle.subTitleSemiBold(
                                          context,
                                          AppColorStyle.textDetail(context))),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                        color: AppColorStyle
                                            .primarySurfaceWithOpacity(context),
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    child: Text(
                                        snapshot.data!.occupationDataList!
                                                    .length >
                                                10
                                            ? snapshot.data!.occupationDataList!
                                                .length
                                                .toString()
                                            : '0${snapshot.data!.occupationDataList!.length.toString()}',
                                        style: AppTextStyle.detailsMedium(
                                            context,
                                            AppColorStyle.primary(context))),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: globalBloc!.subscriptionType ==
                                      AppType.PAID
                                  ? snapshot.data!.occupationDataList!.length
                                  : snapshot.data!.occupationDataList!.length >=
                                          3
                                      ? 3
                                      : snapshot
                                          .data!.occupationDataList!.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  unitGroupOccupationListItem(
                                      context,
                                      snapshot.data!.occupationDataList!,
                                      index)),
                        )
                      ]),
                ],
              );
            }
          } else {
            return Container();
          }
        });
  }

  Widget unitGroupOccupationListItem(BuildContext context,
      List<OccupationDataList> occupationList, int index) {
    var skillColorList =
        Utility.getSkillLevelColor(occupationList[index].skillLevel ?? 0);
    return occupationList.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(
                top: 15,
                left: index == 0 ? 5 : 15,
                right: index == 2 ? 5 : 0,
                bottom: 10),
            child: InkWellWidget(
              onTap: () {
                if (NetworkController.isInternetConnected == true) {
                  if (globalBloc!.subscriptionType != AppType.PAID) {
                    GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.subscription);
                    return;
                  } else {
                    OccupationRowData? occupationRowData;
                    occupationRowData = OccupationRowData(
                        id: occupationList[index].occCode,
                        mainId: occupationList[index].occCode,
                        name: occupationList[index].occName);
                    GoRoutesPage.go(
                        mode: NavigatorMode.push,
                        moveTo: RouteName.occupationSearchScreen,
                        param: occupationRowData);
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(children: [
                                Text(
                                    "${StringHelper.anzscoText} ${occupationList[index].occCode}",
                                    style: AppTextStyle.subTitleSemiBold(
                                        context,
                                        AppColorStyle.textWhite(context))),
                                const SizedBox(width: 5.0),
                                Visibility(
                                    visible: globalBloc!.subscriptionType !=
                                        AppType.PAID,
                                    child: SvgPicture.asset(
                                        IconsSVG.icPremiumFeature,
                                        height: 20,
                                        width: 20))
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: Text("${occupationList[index].occName}",
                                  style: AppTextStyle.detailsMedium(context,
                                      AppColorStyle.textWhite(context)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Visibility(
                              visible: skillColorList.length > 0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(StringHelper.skillLevelText,
                                            style: AppTextStyle.captionRegular(
                                                context,
                                                AppColorStyle.textWhite(
                                                    context))),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          )
        : const SizedBox();
  }
}

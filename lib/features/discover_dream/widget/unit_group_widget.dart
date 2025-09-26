import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_model.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';
import 'package:occusearch/features/discover_dream/widget/discover_dream_widget_shimmer.dart';
import 'package:occusearch/features/discover_dream/widget/unit_group_shimmer.dart';

class UnitGroupWidget extends StatelessWidget {
  final UnitGroupBloc unitGroupBloc;
  final GlobalBloc? globalBloc;

  const UnitGroupWidget(
      {Key? key, required this.unitGroupBloc, this.globalBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColorStyle.backgroundVariant(context),
          padding: const EdgeInsets.only(
              left: Constants.commonPadding,
              right: Constants.commonPadding,
              top: 20,
              bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(StringHelper.unitGroups,
                    style: AppTextStyle.titleSemiBold(
                        context, AppColorStyle.text(context))),
                const SizedBox(width: 10),
                Visibility(
                    visible: globalBloc!.subscriptionType != AppType.PAID,
                    child: SvgPicture.asset(IconsSVG.icPremiumFeature,
                        height: 20, width: 20)),
              ]),
              InkWellWidget(
                onTap: () {
                  if (globalBloc!.subscriptionType == AppType.PAID) {
                    GoRoutesPage.go(
                      mode: NavigatorMode.push,
                      moveTo: RouteName.unitGroupListScreen,
                    );
                  } else {
                    GoRoutesPage.go(
                      mode: NavigatorMode.push,
                      moveTo: RouteName.subscription,
                    );
                  }
                },
                child: Text(StringHelper.viewAllText,
                    style: AppTextStyle.detailsRegular(
                        context, AppColorStyle.primaryVariant2(context))),
              ),
            ],
          ),
        ),
        StreamBuilder(
          stream: unitGroupBloc.occupationUnitGroupSubject,
          builder: (_, snapshot) {
            return (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data != [])
                ? Container(
                    color: AppColorStyle.backgroundVariant(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length > 5
                                  ? 5
                                  : snapshot.data!.length,
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  occupationUnitGroupListView(
                                      context, snapshot.data!, index)),
                        ),
                      ],
                    ),
                  )
                :
                //UNIT-GROUP SHIMMER
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: UnitGroupShimmer(1),
                  );
          },
        ),
      ],
    );
  }

  Widget occupationUnitGroupListView(
      BuildContext context, List<UnitGroupListData> unitGroupList, int index) {
    //SHIMMER FOR RECENT SEARCH COURSE
    if (unitGroupList.isEmpty) {
      return const RecentSearchShimmer();
    }
    return Padding(
      padding: EdgeInsets.only(
          top: 5,
          left: index == 0 ? 5 : 15,
          right: index == 2 ? 5 : 0,
          bottom: 20),
      child: InkWellWidget(
        onTap: () {
          if (globalBloc!.subscriptionType == AppType.PAID) {
            GoRoutesPage.go(
                mode: NavigatorMode.push,
                moveTo: RouteName.labourInsightUnitGroupScreen,
                param: unitGroupList[index].ugCode);
          } else {
            GoRoutesPage.go(
                mode: NavigatorMode.push, moveTo: RouteName.subscription);
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
                  // width: MediaQuery.of(context).size.width * 0.90,
                  // constraints: const BoxConstraints(minHeight: 50.0),
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
                occuUnitGroupListItem(context, unitGroupList, index),
              ],
            )),
      ),
    );
  }

  Widget occuUnitGroupListItem(
      BuildContext context, List<UnitGroupListData> unitGroupList, int index) {
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
                    "${StringHelper.unitCodeText} ${unitGroupList[index].ugCode}",
                    style: AppTextStyle.subTitleSemiBold(
                        context, AppColorStyle.textWhite(context))),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("${unitGroupList[index].name}",
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
            child: Text(
                "Occupations: ${unitGroupList[index].occupation?.length ?? 0}",
                style: AppTextStyle.captionMedium(
                    context, AppColorStyle.textWhite(context))),
          ),
        ],
      ),
    );
  }
}

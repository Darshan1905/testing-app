import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_occupation_table.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_bloc.dart';

class OccupationRecentSearchWidget extends StatelessWidget {
  final OccupationListBloc occupationBloc;
  final GlobalBloc? globalBloc;

  const OccupationRecentSearchWidget(
      {Key? key, required this.occupationBloc, this.globalBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColorStyle.backgroundVariant(context),
          padding: const EdgeInsets.only(bottom: 20),
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
              StreamBuilder(
                  stream: occupationBloc.occupationRecentUpdateStream,
                  builder: (context, snapshot) {
                    return (snapshot.hasData && snapshot.data != null)
                        ? SizedBox(
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
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    OccupationRecentSearchListviewWidget(
                                      recentOccupationList: snapshot.data!,
                                      index: index,
                                    )),
                          )
                        : const SizedBox();
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class OccupationRecentSearchListviewWidget extends StatelessWidget {
  final List<RecentOccupationTable> recentOccupationList;
  final int index;

  const OccupationRecentSearchListviewWidget(
      {Key? key, required this.recentOccupationList, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 5,
          left: index == 0 ? 5 : 15,
          right: index == 2 ? 5 : 0,
          bottom: 20),
      child: InkWellWidget(
        onTap: () {
          OccupationRowData? occupationRowData;
          RecentOccupationTable convertedData = recentOccupationList[index];
          occupationRowData = OccupationRowData(
              id: convertedData.occuID.toString(),
              mainId: convertedData.occuMainID,
              name: convertedData.occuName);
          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.occupationSearchScreen,
              param: occupationRowData);
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
                RecentOccupationSearchListItem(
                    recentOccupationList: recentOccupationList, index: index)
              ],
            )),
      ),
    );
  }
}

class RecentOccupationSearchListItem extends StatelessWidget {
  final List<RecentOccupationTable> recentOccupationList;
  final int index;

  const RecentOccupationSearchListItem(
      {Key? key, required this.recentOccupationList, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var skillColorList =
        Utility.getSkillLevelColor(recentOccupationList[index].skillLevel ?? 0);
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
                    "${StringHelper.anzscoText} ${recentOccupationList[index].occuID}",
                    style: AppTextStyle.subTitleSemiBold(
                        context, AppColorStyle.textWhite(context))),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("${recentOccupationList[index].occuName}",
                  style: AppTextStyle.detailsMedium(
                      context, AppColorStyle.textWhite(context)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Padding(
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
                    Visibility(
                      visible: skillColorList.length > 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var item in skillColorList)
                            Row(
                              children: [
                                Container(
                                  width: 25,
                                  height: 5,
                                  color: item,
                                  // color: ThemeConstant.redVariantTemp,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                              ],
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

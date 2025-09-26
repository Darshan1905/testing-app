import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';

class MostVisitedOccupationWidget extends StatelessWidget {
  final bool isFromOccupationTab;

  const MostVisitedOccupationWidget(
      {Key? key, required this.isFromOccupationTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalBloc = RxBlocProvider.of<GlobalBloc>(context);

    return StreamBuilder(
        stream: globalBloc.mostVisitedCountOccupationStream.stream,
        builder: (context, snapshot) {
          return snapshot.data != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Constants.commonPadding,
                          right: Constants.commonPadding,
                          bottom: 10,
                          top: 20),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: StringHelper.mostVisited,
                              style: AppTextStyle.titleSemiBold(
                                context,
                                AppColorStyle.text(context),
                              ),
                            ),
                            TextSpan(
                              text: isFromOccupationTab
                                  ? StringHelper.occupation
                                  : "on ${StringHelper.occuSearch}",
                              style: AppTextStyle.titleSemiBold(
                                context,
                                AppColorStyle.primary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: List.generate(
                        globalBloc.subscriptionType == AppType.PAID
                            ? snapshot.data!.length
                            : snapshot.data!.length >= 3
                                ? 3
                                : snapshot.data!.length,
                        (index) => MostVisitedListView(
                          mostVisitedList: snapshot.data!,
                          index: index,
                          globalBloc: globalBloc,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox();
        });
  }
}

class MostVisitedListView extends StatelessWidget {
  final List<OccupationRowData> mostVisitedList;
  final int index;
  final GlobalBloc globalBloc;

  const MostVisitedListView(
      {Key? key,
      required this.mostVisitedList,
      required this.index,
      required this.globalBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onTap: () {
        if (NetworkController.isInternetConnected) {
          if (globalBloc.subscriptionType != AppType.PAID) {
            GoRoutesPage.go(
                mode: NavigatorMode.push, moveTo: RouteName.subscription);
            return;
          } else {
            OccupationRowData convertedData = mostVisitedList[index];
            OccupationRowData occupationRowData = OccupationRowData(
                id: convertedData.id.toString(),
                mainId: convertedData.mainId,
                name: convertedData.name);
            GoRoutesPage.go(
                mode: NavigatorMode.push,
                moveTo: RouteName.occupationSearchScreen,
                param: occupationRowData);
          }
        } else {
          Toast.show(context,
              message: StringHelper.internetConnection,
              gravity: Toast.toastTop,
              duration: 3,
              type: Toast.toastError);
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
                  horizontal: Constants.commonPadding, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("${mostVisitedList[index].id}",
                                style: AppTextStyle.detailsSemiBold(
                                    context, AppColorStyle.primary(context))),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                  color:
                                      AppColorStyle.primarySurfaceWithOpacity(
                                          context),
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: Text(
                                "Occupation",
                                style: AppTextStyle.captionMedium(
                                    context, AppColorStyle.primary(context)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Visibility(
                                visible:
                                    globalBloc.subscriptionType != AppType.PAID,
                                child: SvgPicture.asset(IconsSVG.icPremiumFeature,
                                    height: 20, width: 20))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("${mostVisitedList[index].name}",
                            style: AppTextStyle.detailsRegular(
                                context, AppColorStyle.text(context))),
                      ],
                    ),
                  ),
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
            ),
            index ==
                    (mostVisitedList.length > 5 ? 5 : mostVisitedList.length) -
                        1
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(left: Constants.commonPadding),
                    child: Divider(
                        color: AppColorStyle.borderColors(context),
                        thickness: 0.5),
                  ),
            SizedBox(
                height: index ==
                        (mostVisitedList.length > 5
                                ? 5
                                : mostVisitedList.length) -
                            1
                    ? 10
                    : 0)
          ],
        ),
      ),
    );
  }
}

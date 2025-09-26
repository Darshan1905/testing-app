import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/unit_group_and_general_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';

//Related Occupation Widget
class RelatedOccupationWidget extends StatelessWidget {
  final GlobalBloc? globalBloc;

  const RelatedOccupationWidget({Key? key, this.globalBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOccupationBloc =
        RxBlocProvider.of<OccupationDetailBloc>(context);
    return (searchOccupationBloc.isLoadingSubject.value)
        ? SoUnitGroupAndGeneralShimmer.relatedOccupationShimmer(context)
        : searchOccupationBloc.getRelatedOccupationList != null &&
                searchOccupationBloc.getRelatedOccupationList!.isNotEmpty
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
                        const SizedBox(width: 20),
                        Text(
                          StringHelper.occupationMainRelatedOccupations,
                          style: AppTextStyle.titleSemiBold(
                              context, AppColorStyle.text(context)),
                        ),
                      ],
                    ),
                    ListView.builder(
                        itemCount: globalBloc!.subscriptionType == AppType.PAID
                            ? searchOccupationBloc
                                .getRelatedOccupationList!.length
                            : searchOccupationBloc
                                        .getRelatedOccupationList!.length >=
                                    3
                                ? 3
                                : searchOccupationBloc
                                    .getRelatedOccupationList!.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          RelatedOccupation relatedOccupation =
                              searchOccupationBloc
                                  .getRelatedOccupationList![index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWellWidget(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0,
                                        bottom: (searchOccupationBloc
                                                        .getRelatedOccupationList!
                                                        .length -
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
                                              Row(children: [
                                                Text(
                                                  relatedOccupation
                                                          .occupationCode ??
                                                      '',
                                                  style: AppTextStyle
                                                      .detailsSemiBold(
                                                          context,
                                                          AppColorStyle.primary(
                                                              context)),
                                                ),
                                                const SizedBox(width: 5),
                                                SvgPicture.asset(
                                                  IconsSVG.icPremiumFeature,
                                                  height: 20,
                                                  width: 20,
                                                )
                                              ]),
                                              const SizedBox(height: 8),
                                              Text(
                                                relatedOccupation
                                                        .occupationName ??
                                                    '',
                                                style:
                                                    AppTextStyle.detailsRegular(
                                                        context,
                                                        AppColorStyle.text(
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
                                    if (globalBloc!.subscriptionType ==
                                        AppType.PAID) {
                                      OccupationRowData occupationData =
                                          OccupationRowData();
                                      occupationData.id =
                                          relatedOccupation.occupationCode;
                                      occupationData.mainId =
                                          relatedOccupation.mainOccupationCode;
                                      occupationData.name =
                                          relatedOccupation.occupationName;
                                      occupationData.isAdded = false;

                                      GoRoutesPage.go(
                                          mode: NavigatorMode.replace,
                                          moveTo:
                                              RouteName.occupationSearchScreen,
                                          param: occupationData);
                                    } else {
                                      GoRoutesPage.go(
                                          mode: NavigatorMode.push,
                                          moveTo: RouteName.subscription);
                                      return;
                                    }
                                  }),
                              (searchOccupationBloc.getRelatedOccupationList!
                                              .length -
                                          1 !=
                                      index)
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Divider(
                                          color: AppColorStyle.disableVariant(
                                              context),
                                          thickness: 0.5),
                                    )
                                  : Container(),
                            ],
                          );
                        }),
                  ],
                ),
              )
            : const SizedBox();
  }
}

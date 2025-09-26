import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_shimmer.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOccupationBloc =
        RxBlocProvider.of<OccupationDetailBloc>(context);

    return (searchOccupationBloc.isLoadingSubject.value)
        ? SoUnitGroupAndGeneralShimmer.relatedOccupationShimmer(context)
        : (searchOccupationBloc.getOccupationOtherInfoData.ugDescription !=
                    null &&
                searchOccupationBloc
                    .getOccupationOtherInfoData.ugDescription!.isNotEmpty &&
                searchOccupationBloc.getOccupationOtherInfoData.ugDescription !=
                    null &&
                searchOccupationBloc
                    .getOccupationOtherInfoData.ugDescription!.isNotEmpty)
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.only(top: 20, bottom: 10.0),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringHelper.description,
                          style: AppTextStyle.titleSemiBold(
                              context, AppColorStyle.text(context)),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        InkWellWidget(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: SvgPicture.asset(
                                IconsSVG.linkIcon,
                                colorFilter: ColorFilter.mode(
                                  AppColorStyle.primary(context),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            onTap: () {
                              Utility.launchURL(searchOccupationBloc
                                      .getOccupationOtherInfoData.sourceLink ??
                                  "");
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    searchOccupationBloc
                                    .getOccupationOtherInfoData.ugDescription !=
                                null &&
                            searchOccupationBloc.getOccupationOtherInfoData
                                .ugDescription!.isNotEmpty
                        ? Text(
                            searchOccupationBloc
                                .getOccupationOtherInfoData.ugDescription!,
                            style: AppTextStyle.detailsRegular(
                                context, AppColorStyle.textDetail(context)),
                          )
                        : Container(),
                    SizedBox(
                      height: (searchOccupationBloc.getOccupationOtherInfoData
                                      .ugDescription !=
                                  null &&
                              searchOccupationBloc.getOccupationOtherInfoData
                                  .ugDescription!.isNotEmpty)
                          ? 10.0
                          : 0.0,
                    ),
                    searchOccupationBloc
                                    .getOccupationOtherInfoData.description !=
                                null &&
                            searchOccupationBloc.getOccupationOtherInfoData
                                .description!.isNotEmpty
                        ? Text(
                            searchOccupationBloc
                                .getOccupationOtherInfoData.description!,
                            style: AppTextStyle.detailsRegular(
                                context, AppColorStyle.textDetail(context)),
                          )
                        : Container(),
                    SizedBox(
                      height: (searchOccupationBloc
                                      .getOccupationOtherInfoData.description !=
                                  null &&
                              searchOccupationBloc.getOccupationOtherInfoData
                                  .description!.isNotEmpty)
                          ? 8.0
                          : 0.0,
                    ),
                  ],
                ),
              )
            : const SizedBox();
  }
}

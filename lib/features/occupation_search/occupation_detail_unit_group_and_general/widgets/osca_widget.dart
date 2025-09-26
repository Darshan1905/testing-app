import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_shimmer.dart';

//OSCA Widget
class OSCAWidget extends StatelessWidget {
  const OSCAWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOccupationBloc = RxBlocProvider.of<OccupationDetailBloc>(context);

    return (searchOccupationBloc.isLoadingSubject.value)
        ? SoUnitGroupAndGeneralShimmer.otherInformationShimmer(context)
        : (searchOccupationBloc.getOccupationOtherInfoData.oscaOccupationCode != null)
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColorStyle.background(context),
                ),
                padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            StringHelper.occupationOSCA,
                            style: AppTextStyle.titleSemiBold(context, AppColorStyle.text(context)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColorStyle.primarySurface2(context),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                          child: Text(
                            searchOccupationBloc.getOccupationOtherInfoData.oscaOccupationCode ??
                                "",
                            style: AppTextStyle.captionMedium(
                              context,
                              AppColorStyle.primary(context),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    InkWellWidget(
                      onTap: () {
                        if (searchOccupationBloc.getOccupationOtherInfoData.oscaLink != null &&
                            searchOccupationBloc.getOccupationOtherInfoData.oscaLink != "") {
                          Utility.launchURL(
                              searchOccupationBloc.getOccupationOtherInfoData.oscaLink ?? "");
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              searchOccupationBloc.getOccupationOtherInfoData.oscaOccupationName ??
                                  "",
                              style: AppTextStyle.detailsMedium(
                                  context, AppColorStyle.text(context)),
                            ),
                          ),
                          const SizedBox(width: 5),
                          (searchOccupationBloc.getOccupationOtherInfoData.oscaLink != null &&
                                  searchOccupationBloc.getOccupationOtherInfoData.oscaLink != "")
                              ? SvgPicture.asset(
                                  IconsSVG.linkIcon,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox();
  }
}

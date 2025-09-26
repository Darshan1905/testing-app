import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_shimmer.dart';

//Specialisation Widget
class SpecializationWidget extends StatelessWidget {
  const SpecializationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOccupationBloc =
        RxBlocProvider.of<OccupationDetailBloc>(context);

    return (searchOccupationBloc.isLoadingSubject.value)
        ? SoUnitGroupAndGeneralShimmer.otherInformationShimmer(context)
        : (searchOccupationBloc.getSpecialisationList.isNotEmpty)
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
                    Text(
                      StringHelper.occupationMainSpecialisation,
                      style: AppTextStyle.titleSemiBold(
                          context, AppColorStyle.text(context)),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.builder(
                      itemCount:
                          searchOccupationBloc.getSpecialisationList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 0),
                      itemBuilder: (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWellWidget(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: (searchOccupationBloc
                                                    .getSpecialisationList
                                                    .length -
                                                1 !=
                                            index)
                                        ? 15.0
                                        : 5.0,
                                    right: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        searchOccupationBloc
                                            .getSpecialisationList[index].title
                                            .toString(),
                                        style: AppTextStyle.detailsRegular(
                                            context,
                                            AppColorStyle.text(context)),
                                      ),
                                    ),
                                    (OccupationType.SPECIALISATION ==
                                            OccupationType.ACCESSING_AUTHORITY)
                                        ? SvgPicture.asset(
                                            IconsSVG.arrowHalfRight,
                                            colorFilter: ColorFilter.mode(
                                              AppColorStyle.text(context),
                                              BlendMode.srcIn,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              onTap: () {}),
                          (searchOccupationBloc.getSpecialisationList.length -
                                      1 !=
                                  index)
                              ? Divider(
                                  color: AppColorStyle.disableVariant(context),
                                  thickness: 0.5)
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

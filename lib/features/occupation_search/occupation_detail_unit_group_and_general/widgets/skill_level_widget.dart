// ignore_for_file: must_be_immutable

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_shimmer.dart';

//Skill Level Widget
class SkillLevelWidget extends StatelessWidget {
  String? skillSubTitle = "";
  String? skillDescription = "";

  SkillLevelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOccupationBloc =
        RxBlocProvider.of<OccupationDetailBloc>(context);

    if (searchOccupationBloc
                .getOccupationOtherInfoData.ugIndicativeSkillLevel !=
            null &&
        searchOccupationBloc
            .getOccupationOtherInfoData.ugIndicativeSkillLevel!.isNotEmpty &&
        searchOccupationBloc.getOccupationOtherInfoData.ugIndicativeSkillLevel!
            .contains(":")) {
      skillSubTitle = searchOccupationBloc
          .getOccupationOtherInfoData.ugIndicativeSkillLevel!
          .substring(
              0,
              searchOccupationBloc
                      .getOccupationOtherInfoData.ugIndicativeSkillLevel!
                      .indexOf(":") +
                  1);
      skillDescription = searchOccupationBloc
          .getOccupationOtherInfoData.ugIndicativeSkillLevel!
          .substring(
              searchOccupationBloc
                      .getOccupationOtherInfoData.ugIndicativeSkillLevel!
                      .indexOf(":") +
                  1,
              searchOccupationBloc
                  .getOccupationOtherInfoData.ugIndicativeSkillLevel!.length);
    }

    return (searchOccupationBloc.isLoadingSubject.value)
        ? SoUnitGroupAndGeneralShimmer.skillLevelShimmer(context)
        : (skillSubTitle != "" &&
                skillSubTitle!.isNotEmpty &&
                skillDescription != "" &&
                skillDescription!.isNotEmpty)
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColorStyle.background(context),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: AppColorStyle.primarySurface2(context),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Text(
                          "Skill Level: ${searchOccupationBloc.getOccupationOtherInfoData.skillLevel ?? 0}",
                          style: AppTextStyle.titleSemiBold(
                              context, AppColorStyle.primary(context)),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (skillSubTitle!.isNotEmpty && skillSubTitle != "")
                              ? Text(
                                  skillSubTitle!,
                                  style: AppTextStyle.titleSemiBold(
                                      context, AppColorStyle.text(context)),
                                )
                              : Container(),
                          const SizedBox(
                            height: 8,
                          ),
                          (skillDescription!.isNotEmpty &&
                                  skillDescription != "")
                              ? Text(
                                  skillDescription!.trim(),
                                  style: AppTextStyle.detailsRegular(context,
                                      AppColorStyle.textDetail(context)),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox();
  }
}

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/unit_group_and_general_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';

// List Widget for Caveats
class CaveatsInfoListWidget extends StatelessWidget {
  const CaveatsInfoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOccupationBloc =
        RxBlocProvider.of<OccupationDetailBloc>(context);
    return (searchOccupationBloc.getCaveatsInfoList!=null && searchOccupationBloc.getCaveatsInfoList!.isNotEmpty)
        ? showCaveatsHeaderInSheet(
            context: context,
            headerTitle: StringHelper.occupationMainCaveats,
            childRowData: searchOccupationBloc.getCaveatsInfoList!,
            type: OccupationType.CAVEATS)
        : const SizedBox();
  }

  //Bottom Sheet for Caveats
  static showCaveatsHeaderInSheet(
      {required BuildContext context,
      required String headerTitle,
      required List<CaveatNotes> childRowData,
      required OccupationType type}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColorStyle.background(context),
      ),
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWellWidget(
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      headerTitle,
                      style: AppTextStyle.titleSemiBold(
                          context, AppColorStyle.text(context)),
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      IconsSVG.linkIcon,
                    ),
                  ],
                ),
              ),
              onTap: () {
                Utility.launchURL(
                    StringHelper.homeAffairsSkillOccupationListUrl);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
                children: List<Widget>.generate(
              childRowData.length,
              (index) => Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\u2022 ",
                      style: AppTextStyle.captionSemiBold(
                        context,
                        AppColorStyle.text(context),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        childRowData[index].notes!,
                        style: AppTextStyle.detailsRegular(
                            context, AppColorStyle.text(context)),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

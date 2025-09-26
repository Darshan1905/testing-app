import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_invitation_cut_off_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';

class SoInvitationCutOffDetailWidget {
  static Widget headerWidget(
      BuildContext context, OccupationDetailBloc searchOccupationBloc) {
    return Row(
      children: [
        InkWellWidget(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SvgPicture.asset(
              IconsSVG.arrowBack,
              width: 16.0,
              height: 16.0,
              colorFilter: ColorFilter.mode(
                AppColorStyle.red(context),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: AppColorStyle.backgroundVariant(context),
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: Row(
              children: [
                Text(
                  searchOccupationBloc.selectedOccupationID,
                  style: AppTextStyle.detailsBold(
                      context, AppColorStyle.primary(context)),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Text(
                    searchOccupationBloc.selectedOccupationName,
                    style: AppTextStyle.detailsSemiBold(
                        context, AppColorStyle.text(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static List<Widget> invitationCutOffHeaderWidget(
      BuildContext context, List<InvitationCutOffRow> childRowData) {
    return List<Widget>.generate(
      childRowData.length,
      (index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          index == 0
              ? Divider(
                  color: AppColorStyle.disableVariant(context), thickness: 0.5)
              : Container(),
          childRowInvitationCutOffWidget(
              context, childRowData[index], index, (index % 2)),
          Divider(color: AppColorStyle.disableVariant(context), thickness: 0.5),
          index == childRowData.length - 1
              ? const SizedBox(
                  height: 20.0,
                )
              : Container(),
          index == childRowData.length - 1
              ? Text(
                  'Point scores and the dates of effect cut off for the pro rata occupations',
                  style: AppTextStyle.captionRegular(
                      context, AppColorStyle.text(context)),
                )
              : Container(),
        ],
      ),
    );
  }

  static Widget childRowInvitationCutOffWidget(BuildContext context,
      InvitationCutOffRow childRowData, int index, int odd) {
    return Container(
      color: odd == 0
          ? AppColorStyle.backgroundVariant(context)
          : AppColorStyle.background(context),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                childRowData.months == "Year"
                    ? "Year"
                    : "${childRowData.months}",
                style: AppTextStyle.captionSemiBold(
                    context,
                    childRowData.months == "Year"
                        ? AppColorStyle.primary(context)
                        : AppColorStyle.text(context)),
              ),
            ),
          ),
          Container(
            height: 10,
            width: 1.0,
            color: AppColorStyle.textHint(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                childRowData.months == "Year"
                    ? "Point Score"
                    : "${childRowData.pointScore}",
                style: AppTextStyle.captionSemiBold(
                    context,
                    childRowData.months == "Year"
                        ? AppColorStyle.primary(context)
                        : AppColorStyle.text(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

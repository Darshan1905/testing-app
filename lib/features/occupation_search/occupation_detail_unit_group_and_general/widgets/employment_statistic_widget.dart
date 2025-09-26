import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/unit_group_and_general_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_shimmer.dart';

class EmploymentStatisticsWidget extends StatelessWidget {
  const EmploymentStatisticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOccupationBloc =
        RxBlocProvider.of<OccupationDetailBloc>(context);

    return (searchOccupationBloc.isLoadingSubject.value)
        ? SoUnitGroupAndGeneralShimmer.employmentStatisticShimmer(context)
        : (searchOccupationBloc.getEmployeeStatisticList.isNotEmpty)
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColorStyle.background(context),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 20, left: 20, right: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  StringHelper
                                      .occupationMainEmployeeStatistic,
                                  style: AppTextStyle.titleSemiBold(
                                      context, AppColorStyle.text(context)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWellWidget(
                                onTap: () {
                                  String ugCode = searchOccupationBloc
                                          .getOccupationOtherInfoData.ugCode ??
                                      '';
                                  Utility.launchURL(
                                      "${Constants.jobOutLookDomain}$ugCode");
                                },
                                child: SvgPicture.asset(
                                  IconsSVG.linkIcon,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 10),
                              child:
                                  searchOccupationBloc
                                                  .getUnitGroupAndGeneralDetail
                                                  .data!
                                                  .weeklyEarning !=
                                              null &&
                                          searchOccupationBloc
                                              .getUnitGroupAndGeneralDetail
                                              .data!
                                              .weeklyEarning!
                                              .isNotEmpty &&
                                          searchOccupationBloc
                                                  .getUnitGroupAndGeneralDetail
                                                  .data!
                                                  .weeklyEarning![0]
                                                  .earning !=
                                              0
                                      ? Row(
                                          children: [
                                            Text(
                                              StringHelper.weeklyEarning,
                                              style:
                                                  AppTextStyle.captionRegular(
                                                      context,
                                                      AppColorStyle.text(
                                                          context)),
                                            ),
                                            Text(
                                              "\$${searchOccupationBloc.getUnitGroupAndGeneralDetail.data!.weeklyEarning![0].earning}",
                                              style:
                                                  AppTextStyle.captionRegular(
                                                      context,
                                                      AppColorStyle.text(
                                                          context)),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            InkWellWidget(
                                              onTap: () {
                                                String occupationCode =
                                                    searchOccupationBloc
                                                            .getOccupationOtherInfoData
                                                            .occupationCode ??
                                                        '';
                                                printLog(
                                                    "${Constants.jobOutLookDomain}$occupationCode");

                                                Utility.launchURL(
                                                    "${Constants.jobOutLookDomain}$occupationCode");
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3,
                                                    bottom: 3,
                                                    right: 3),
                                                child: SvgPicture.asset(
                                                  IconsSVG.linkIcon,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColorStyle.primary(context),
                                    width: 0.2),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0)),
                                      color: AppColorStyle.primary(context),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              StringHelper.year,
                                              style:
                                                  AppTextStyle.subTitleSemiBold(
                                                      context,
                                                      AppColorStyle.textWhite(
                                                          context)),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              StringHelper.noOfWorkers,
                                              style:
                                                  AppTextStyle.subTitleSemiBold(
                                                      context,
                                                      AppColorStyle.textWhite(
                                                          context)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Table widget of Employment Statistics
                                  Column(
                                      children: List<Widget>.generate(
                                    searchOccupationBloc
                                        .getEmployeeStatisticList.length,
                                    (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        child: childRowForEmpStatisticsWidget(
                                            context,
                                            searchOccupationBloc
                                                    .getEmployeeStatisticList[
                                                index],
                                            (index % 2),
                                            searchOccupationBloc
                                                        .getEmployeeStatisticList
                                                        .length -
                                                    1 >
                                                index)),
                                  )),
                                  const SizedBox(
                                    height: 10.0,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringHelper.source,
                                  style: AppTextStyle.captionMedium(
                                      context, AppColorStyle.text(context)),
                                ),
                                Expanded(
                                  child: Text(
                                    StringHelper
                                        .basedOnDataAvailableOnSite,
                                    style: AppTextStyle.captionRegular(
                                        context, AppColorStyle.text(context)),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox();
  }

  //Table widget of Employment Statistics
  static Widget childRowForEmpStatisticsWidget(BuildContext context,
      EmploymentStatistics childRowData, int odd, bool isLastData) {
    return Container(
      color: odd == 0
          ? AppColorStyle.background(context)
          : AppColorStyle.backgroundVariant(context),
      height: 40.0,
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "${childRowData.year}",
                style: AppTextStyle.detailsMedium(
                    context,
                    childRowData.esId == "0"
                        ? AppColorStyle.primary(context)
                        : AppColorStyle.text(context)),
              ),
            ),
          ),
// Container(
//   height: 40,
//   width: childRowData.workers!.isNotEmpty ? 1.0 : 0.0,
//   color: AppColorStyle.textHint(context),
// ),
          childRowData.workers!.isNotEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      Utility.getFormattedNumber(
                          int.parse(childRowData.workers ?? "0.0")),
                      style: AppTextStyle.detailsMedium(
                          context,
                          childRowData.esId == "0"
                              ? AppColorStyle.primary(context)
                              : AppColorStyle.text(context)),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

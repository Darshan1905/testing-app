import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';
import 'package:occusearch/features/labour_insights/model/labour_insight_chart_model.dart';
import 'package:occusearch/features/labour_insights/widgets/labour_insight_chart_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class UnitGroupEarningsChart extends StatelessWidget {
  final UnitGroupBloc unitGroupBloc = UnitGroupBloc();
  final UnitGroupDetailData unitGroupDetailData;
  final List<EarningChartModel> chartModel = [];

  UnitGroupEarningsChart({Key? key, required this.unitGroupDetailData})
      : super(key: key);

  TooltipBehavior? tooltip = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    int fullTimeEarnOccupation = 0;
    try {
      fullTimeEarnOccupation =
          int.parse(unitGroupDetailData.fullTimeEarnOccupation ?? "0");
    } catch (e) {
      fullTimeEarnOccupation = 0;
    }
    chartModel.add(EarningChartModel(
        name: unitGroupDetailData.name, totalEarn: fullTimeEarnOccupation));
    chartModel.add(EarningChartModel(
        name: StringHelper.jobs,
        totalEarn: unitGroupDetailData.fullTimeEarnJobAvg ?? 0));
    if (fullTimeEarnOccupation == 0 &&
        (unitGroupDetailData.fullTimeEarnJobAvg ?? 0) == 0) {
      return const SizedBox();
    } else {
      return StreamBuilder(
        stream: unitGroupBloc.viewEarningsMode.stream,
        builder: (_, snapshot) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: StringHelper.weeklyEarningBeforeTax,
                                style: AppTextStyle.titleSemiBold(
                                    context, AppColorStyle.text(context)),
                                children: [
                                  WidgetSpan(
                                    child: Visibility(
                                      visible: (unitGroupDetailData
                                                  .earningsHoursSources !=
                                              null &&
                                          unitGroupDetailData
                                              .earningsHoursSources!
                                              .isNotEmpty),
                                      child: InkWellWidget(
                                        onTap: () {
                                          WidgetHelper.showAlertDialog(
                                            context,
                                            contentText: unitGroupDetailData
                                                    .earningsHoursSources ??
                                                "",
                                            isHTml: true,
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: SvgPicture.asset(
                                            IconsSVG.fundBulb,
                                            width: 20,
                                            height: 20,
                                            colorFilter: ColorFilter.mode(
                                              AppColorStyle.primary(context),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LabourInsightChartWidget.viewModeWidget(
                                  context,
                                  unitGroupBloc,
                                  UnitGroupChartDataType.EARNINGS),
                            ],
                          )
                        ],
                      ),
                    ),
                    // const SizedBox(height: 10.0),
                    (snapshot.data != null && snapshot.data == false)
                        //chart data for weekly earnings
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Theme(
                              data: ThemeData(),
                              child: SfCartesianChart(
                                tooltipBehavior: tooltip,
                                plotAreaBorderWidth: 0,
                                // title: ChartTitle(text: 'Weekly Earning Graph'),
                                primaryXAxis: CategoryAxis(
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  //labelRotation: 45,
                                  autoScrollingMode: AutoScrollingMode.start,
                                ),
                                primaryYAxis: NumericAxis(
                                    axisLine: const AxisLine(width: 0),
                                    labelFormat: '{value}',
                                    majorTickLines:
                                        const MajorTickLines(size: 0)),
                                series: _getDefaultColumnSeries(),
                              ),
                            ),
                          )
                        :
                        //Table widget for weekly earning
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 5.0),
                                  decoration: BoxDecoration(
                                      color: AppColorStyle.primary(context),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0))),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "${unitGroupDetailData.name}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style:
                                                  AppTextStyle.detailsSemiBold(
                                                      context,
                                                      AppColorStyle.textWhite(
                                                          context)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              StringHelper.jobs,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style:
                                                  AppTextStyle.detailsSemiBold(
                                                      context,
                                                      AppColorStyle.textWhite(
                                                          context)),
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                                Container(
                                  height: 45.0,
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColorStyle.disableVariant(
                                              context))),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              (unitGroupDetailData
                                                              .fullTimeEarnOccupation ==
                                                          "" ||
                                                      unitGroupDetailData
                                                              .fullTimeEarnOccupation ==
                                                          'n/a')
                                                  ? "N/A"
                                                  : unitGroupDetailData
                                                      .fullTimeEarnOccupation!
                                                      .toUpperCase(),
                                              style: AppTextStyle.detailsMedium(
                                                  context,
                                                  AppColorStyle.text(context)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              (unitGroupDetailData
                                                              .fullTimeEarnJobAvg ==
                                                          "" ||
                                                      unitGroupDetailData
                                                              .fullTimeEarnJobAvg ==
                                                          'n/a')
                                                  ? "N/A"
                                                  : unitGroupDetailData
                                                      .fullTimeEarnJobAvg!
                                                      .toString()
                                                      .toUpperCase(),
                                              style: AppTextStyle.detailsMedium(
                                                  context,
                                                  AppColorStyle.text(context)),
                                            ),
                                          ),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          )
                  ],
                ),
              ),
              Container(
                  height: 5.0, color: AppColorStyle.backgroundVariant(context)),
              const SizedBox(height: 15.0),
            ],
          );
        },
      );
    }
  }

  /// Get default column series
  List<ColumnSeries<EarningChartModel, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<EarningChartModel, String>>[
      ColumnSeries<EarningChartModel, String>(
          dataSource: chartModel,
          xValueMapper: (EarningChartModel sales, _) => sales.name as String,
          yValueMapper: (EarningChartModel sales, _) => sales.totalEarn,
          dataLabelSettings: const DataLabelSettings(
              isVisible: true, textStyle: TextStyle(fontSize: 9)),
          name: StringHelper.weeklyEarnings)
    ];
  }
}

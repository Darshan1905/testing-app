// ignore_for_file: must_be_immutable

import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/labour_insights/model/labour_insight_chart_model.dart';
import 'package:occusearch/features/labour_insights/widgets/labour_insight_chart_widget.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UnitGroupWorkersChart extends StatelessWidget {
  List<NumberOfWorker> workerList = [];
  final UnitGroupDetailData unitGroupDetailData;
  List<LabourInsightChartModel> chartModel = [];
  UnitGroupBloc unitGroupBloc = UnitGroupBloc();

  UnitGroupWorkersChart({Key? key, required this.unitGroupDetailData})
      : super(key: key);

  final TooltipBehavior? tooltip = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    workerList = unitGroupDetailData.numberOfWorker ?? [];
    if (workerList.isNotEmpty) {
      for (NumberOfWorker workers in workerList) {
        chartModel.add(LabourInsightChartModel(
            year: workers.year.toString(),
            workersEmployment: double.parse(workers.employment.toString())));
      }

      return StreamBuilder(
        stream: unitGroupBloc.viewWorkersChartMode,
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
                                text: StringHelper.numberOfWorkers,
                                style: AppTextStyle.titleSemiBold(
                                    context, AppColorStyle.text(context)),
                                children: [
                                  WidgetSpan(
                                    child: Visibility(
                                      visible: (unitGroupDetailData
                                                  .numberOfWorkersSource !=
                                              null &&
                                          unitGroupDetailData
                                              .numberOfWorkersSource!
                                              .isNotEmpty),
                                      child: InkWellWidget(
                                        onTap: () {
                                          WidgetHelper.showAlertDialog(
                                            context,
                                            contentText: unitGroupDetailData
                                                    .numberOfWorkersSource ??
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
                              LabourInsightChartWidget.viewModeWidget(context,
                                  unitGroupBloc, UnitGroupChartDataType.WORKERS)
                            ],
                          )
                        ],
                      ),
                    ),
                    // const SizedBox(height: 20.0),
                    (snapshot.data != null && snapshot.data == false)
                        ?
                        //CHART DATA
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Theme(
                              data: ThemeData(),
                              child: SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                // title: ChartTitle(text: 'Numbers of Workers Graph'),
                                legend: Legend(
                                    isVisible: false,
                                    position: LegendPosition.bottom,
                                    overflowMode: LegendItemOverflowMode.wrap),
                                tooltipBehavior: tooltip,
                                primaryXAxis: CategoryAxis(
                                  majorGridLines: const MajorGridLines(width: 0),
                                  labelRotation: 45,
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
                        : //Table widget for worker data
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
                                              "Year",
                                              maxLines: 2,
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
                                              "Employment",
                                              maxLines: 2,
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
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColorStyle.disableVariant(
                                              context))),
                                  child: Column(
                                      children: List<Widget>.generate(
                                    workerList.length,
                                    (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        child: childRowForWorkersGraph(
                                            context,
                                            workerList[index],
                                            (index % 2),
                                            workerList.length - 1 > index)),
                                  )),
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
    return Container();
  }

//Table widget of Workers details
  static Widget childRowForWorkersGraph(BuildContext context,
      NumberOfWorker childRowData, int odd, bool isLastData) {
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
                    childRowData.year == "0"
                        ? AppColorStyle.primary(context)
                        : AppColorStyle.text(context)),
              ),
            ),
          ),
          childRowData.year!.isNotEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      Utility.getFormattedNumber(childRowData.employment ?? 0),
                      style: AppTextStyle.detailsMedium(
                          context,
                          childRowData.employment == null || childRowData.employment == 0
                              ? AppColorStyle.primary(context)
                              : AppColorStyle.text(context)),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  /// Get default column series
  List<ColumnSeries<LabourInsightChartModel, String>>
      _getDefaultColumnSeries() {
    return <ColumnSeries<LabourInsightChartModel, String>>[
      ColumnSeries<LabourInsightChartModel, String>(
          dataSource: chartModel,
          xValueMapper: (LabourInsightChartModel sales, _) =>
              sales.year as String,
          yValueMapper: (LabourInsightChartModel sales, _) =>
              sales.workersEmployment,
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          name: StringHelper.employment)
    ];
  }
}

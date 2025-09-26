import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/labour_insights/model/labour_insight_chart_model.dart';
import 'package:occusearch/features/labour_insights/widgets/labour_insight_chart_widget.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UnitGroupAgeProfileChart extends StatelessWidget {
  final UnitGroupDetailData unitGroupDetailData;
  final List<AgeProfileModel> chartModel = [];
  final UnitGroupBloc unitGroupBloc = UnitGroupBloc();
  final TooltipBehavior? tooltip = TooltipBehavior(enable: true);

  UnitGroupAgeProfileChart({Key? key, required this.unitGroupDetailData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final legendText = [
      unitGroupDetailData.name ?? '',
      StringHelper.allJobAverage
    ];
    final legendColors = [
      ThemeConstant.legendPrimary,
      ThemeConstant.legendSecondary
    ];

    if (unitGroupDetailData.ageProfile != null &&
        unitGroupDetailData.ageProfile != []) {
      for (AgeProfile ageProfile in unitGroupDetailData.ageProfile ?? []) {
        chartModel.add(AgeProfileModel(
          ageBracket: ageProfile.ageBracket.toString(),
          occupation: ageProfile.occupationJob?.toDouble(),
          avg: ageProfile.allJobAvg?.toDouble(),
        ));
      }

      if (unitGroupDetailData.profileAgeInYear != null &&
          unitGroupDetailData.profileAllJobsAvg != null) {
        double age = 0.0;
        try {
          age = double.parse(unitGroupDetailData.profileAgeInYear ?? "0.0");
        } catch (e) {
          age = 0.0;
        }
        chartModel.add(AgeProfileModel(
          ageBracket: "Median Age",
          occupation: age,
          avg: unitGroupDetailData.profileAllJobsAvg?.toDouble(),
        ));
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: StreamBuilder(
              stream: unitGroupBloc.viewAgeMode.stream,
              builder: (_, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                text: StringHelper.ageProfile,
                                style: AppTextStyle.titleSemiBold(
                                    context, AppColorStyle.text(context)),
                                children: [
                                  WidgetSpan(
                                    child: Visibility(
                                      visible: (unitGroupDetailData
                                                  .workersProfileSource !=
                                              null &&
                                          unitGroupDetailData
                                              .workersProfileSource!
                                              .isNotEmpty),
                                      child: InkWellWidget(
                                        onTap: () {
                                          WidgetHelper.showAlertDialog(
                                            context,
                                            contentText: unitGroupDetailData
                                                    .workersProfileSource ??
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
                                  UnitGroupChartDataType.AGEPROFILE),
                            ],
                          )
                        ],
                      ),
                    ),
                    // const SizedBox(height: 20.0),
                    (snapshot.data != null && snapshot.data == false)
                        ?
                        //chart data for age profile
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Theme(
                              data: ThemeData(),
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  labelRotation: 45,
                                ),
                                legend: Legend(
                                    isResponsive: true,
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    toggleSeriesVisibility: true,
                                    legendItemBuilder: (String name,
                                        dynamic series,
                                        dynamic point,
                                        int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: SvgPicture.asset(
                                                IconsSVG.legendChartIcon,
                                                colorFilter: ColorFilter.mode(
                                                  legendColors[index],
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                            Text(legendText[index],
                                                style:
                                                    AppTextStyle.captionRegular(
                                                  context,
                                                  AppColorStyle.textDetail(
                                                      context),
                                                ),
                                                overflow: TextOverflow.fade),
                                          ],
                                        ),
                                      );
                                    },
                                    orientation:
                                        (unitGroupDetailData.name ?? "")
                                                    .length >
                                                100
                                            ? LegendItemOrientation.vertical
                                            : LegendItemOrientation.horizontal,
                                    shouldAlwaysShowScrollbar: true,
                                    position: LegendPosition.bottom),
                                primaryYAxis: NumericAxis(
                                    axisLine: AxisLine(width: 0),
                                    labelFormat: '{value}',
                                    majorTickLines:
                                        MajorTickLines(size: 0)),
                                tooltipBehavior: tooltip,
                                series: <CartesianSeries<AgeProfileModel, String>>[
                                  // Renders column chart
                                  ColumnSeries<AgeProfileModel, String>(
                                    dataSource: chartModel,
                                    xValueMapper: (AgeProfileModel sales, _) =>
                                        sales.ageBracket as String,
                                    yValueMapper: (AgeProfileModel sales, _) =>
                                        sales.occupation,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: false,
                                        textStyle: TextStyle(fontSize: 9)),
                                    name: "${unitGroupDetailData.name}",
                                  ),
                                  ColumnSeries<AgeProfileModel, String>(
                                    dataSource: chartModel,
                                    xValueMapper: (AgeProfileModel sales, _) =>
                                        sales.ageBracket as String,
                                    yValueMapper: (AgeProfileModel sales, _) =>
                                        sales.avg,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: false,
                                        textStyle: TextStyle(fontSize: 9)),
                                    name: StringHelper.allJobAvg,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : //Table data for age profile
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
                                              StringHelper.ageBracket,
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
                                              StringHelper.allJobAvg,
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
                                      chartModel.length,
                                      (index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0),
                                          child: childRowForAgeProfileTable(
                                              context,
                                              chartModel[index],
                                              (index % 2),
                                              chartModel.length - 1 > index)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
          Container(
              height: 5.0, color: AppColorStyle.backgroundVariant(context)),
          const SizedBox(height: 15.0),
        ],
      );
    }
    return Container();
  }

  //Table widget of Age Profile
  static Widget childRowForAgeProfileTable(BuildContext context,
      AgeProfileModel childRowData, int odd, bool isLastData) {
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
                "${childRowData.ageBracket}",
                style: AppTextStyle.detailsMedium(
                    context, AppColorStyle.text(context)),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                childRowData.occupation.toString(),
                style: AppTextStyle.detailsMedium(
                    context, AppColorStyle.text(context)),
              ),
            ),
          ),
          childRowData.avg != null && childRowData.avg!.isFinite
              ? Expanded(
                  child: Center(
                    child: Text(
                      childRowData.avg.toString(),
                      style: AppTextStyle.detailsMedium(
                          context, AppColorStyle.text(context)),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

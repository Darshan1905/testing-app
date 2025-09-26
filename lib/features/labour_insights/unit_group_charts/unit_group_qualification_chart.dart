import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/labour_insights/model/labour_insight_chart_model.dart';
import 'package:occusearch/features/labour_insights/widgets/labour_insight_chart_widget.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class UnitGroupQualificationChart extends StatelessWidget {
  final UnitGroupDetailData unitGroupDetailData;
  List<QualificationModel> chartModel = [];
  UnitGroupBloc unitGroupBloc = UnitGroupBloc();

  UnitGroupQualificationChart({Key? key, required this.unitGroupDetailData})
      : super(key: key);

  TooltipBehavior? tooltip = TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    List<HighestLevelEducation> educationList =
        unitGroupDetailData.highestLevelEducation ?? [];
    for (HighestLevelEducation education
        in unitGroupDetailData.highestLevelEducation ?? []) {
      chartModel.add(QualificationModel(
        type: education.qualificationType.toString(),
        share: education.occupationShare?.toDouble(),
        avg: education.allJobAvg?.toDouble(),
      ));
    }

    final legendText = [
      unitGroupDetailData.name ?? '',
      StringHelper.allJobAverage
    ];
    final legendColors = [
      ThemeConstant.legendPrimary,
      ThemeConstant.legendSecondary
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: StreamBuilder(
        stream: unitGroupBloc.viewEducationMode.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Column(
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
                          text: StringHelper.qualification,
                          style: AppTextStyle.titleSemiBold(
                              context, AppColorStyle.text(context)),
                          children: [
                            WidgetSpan(
                              child: Visibility(
                                visible: (unitGroupDetailData
                                            .employeePathwaysSourse !=
                                        null &&
                                    unitGroupDetailData
                                        .employeePathwaysSourse!.isNotEmpty),
                                child: InkWellWidget(
                                  onTap: () {
                                    WidgetHelper.showAlertDialog(
                                      context,
                                      contentText: unitGroupDetailData
                                              .employeePathwaysSourse ??
                                          "",
                                      isHTml: true,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
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
                            unitGroupBloc, UnitGroupChartDataType.EDUCATION),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              (snapshot.data != null && snapshot.data == false)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Theme(
                        data: ThemeData(),
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            maximumLabelWidth: 60,
                            labelRotation: 45,
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                          legend: Legend(
                              isResponsive: true,
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              toggleSeriesVisibility: true,
                              legendItemBuilder: (String name, dynamic series,
                                  dynamic point, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: SvgPicture.asset(
                                          IconsSVG.legendChartIcon,
                                          colorFilter: ColorFilter.mode(
                                            legendColors[index],
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        legendText[index],
                                        style: AppTextStyle.captionRegular(
                                            context,
                                            AppColorStyle.textDetail(context)),
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              orientation:
                                  (unitGroupDetailData.name ?? "").length > 100
                                      ? LegendItemOrientation.vertical
                                      : LegendItemOrientation.horizontal,
                              shouldAlwaysShowScrollbar: true,
                              position: LegendPosition.bottom),
                          primaryYAxis: NumericAxis(
                              axisLine: const AxisLine(width: 0),
                              labelFormat: '{value}',
                              majorTickLines: const MajorTickLines(size: 0)),
                          tooltipBehavior: tooltip,
                          series: <CartesianSeries<QualificationModel, String>>[
                            // Renders column chart
                            ColumnSeries<QualificationModel, String>(
                              dataSource: chartModel,
                              xValueMapper: (QualificationModel sales, _) =>
                                  sales.type as String,
                              yValueMapper: (QualificationModel sales, _) =>
                                  sales.share,
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: false,
                                  textStyle: TextStyle(
                                      fontSize: 9,
                                      color:
                                          AppColorStyle.textDetail(context))),
                              name: "${unitGroupDetailData.name}",
                              width: 0.8,
                            ),
                            ColumnSeries<QualificationModel, String>(
                              dataSource: chartModel,
                              xValueMapper: (QualificationModel sales, _) =>
                                  sales.type as String,
                              yValueMapper: (QualificationModel sales, _) =>
                                  sales.avg,
                              name: StringHelper.allJobAvg,
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: false,
                                  textStyle: TextStyle(
                                      fontSize: 9, color: Colors.red)),
                              width: 0.8,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Qualification",
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.detailsSemiBold(
                                          context,
                                          AppColorStyle.textWhite(context)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "${unitGroupDetailData.name}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.detailsSemiBold(
                                            context,
                                            AppColorStyle.textWhite(context)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        StringHelper.allJobAvg,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.detailsSemiBold(
                                            context,
                                            AppColorStyle.textWhite(context)),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        AppColorStyle.disableVariant(context))),
                            child: Column(
                              children: List<Widget>.generate(
                                educationList.length,
                                (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: childRowForEducationDetails(
                                        context,
                                        educationList[index],
                                        (index % 2),
                                        educationList.length - 1 > index)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  //Table widget of Workers details
  static Widget childRowForEducationDetails(BuildContext context,
      HighestLevelEducation childRowData, int odd, bool isLastData) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: odd == 0
          ? AppColorStyle.background(context)
          : AppColorStyle.backgroundVariant(context),
      // height: 40.0,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                "${childRowData.qualificationType}",
                style: AppTextStyle.detailsMedium(
                    context, AppColorStyle.text(context)),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                childRowData.occupationShare.toString(),
                style: AppTextStyle.detailsMedium(
                    context, AppColorStyle.text(context)),
              ),
            ),
          ),
          childRowData.allJobAvg!.isFinite
              ? Expanded(
                  child: Center(
                    child: Text(
                      childRowData.allJobAvg.toString(),
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

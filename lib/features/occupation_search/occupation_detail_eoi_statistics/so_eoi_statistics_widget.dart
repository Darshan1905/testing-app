import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/app_style/theme/theme_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_eoi_statistics_chart_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_eoi_statistics_model.dart';
import 'package:occusearch/utility/common_animation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'so_eoi_statistics_bloc.dart';

class SoEOIStatisticsWidget {
  static Widget datePickerWidget(
      BuildContext context, SoEOIStatisticsBloc dBloc) {
    return InkWellWidget(
      onTap: () {
        showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildDateTimePicker(context, dBloc);
            });
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColorStyle.background(context),
            border: Border.all(
                color: AppColorStyle.borderColors(context), width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            children: [
              RotatedBox(
                quarterTurns: 1,
                child: SvgPicture.asset(
                  IconsSVG.arrowHalfRight,
                  colorFilter: ColorFilter.mode(
                    AppColorStyle.primary(context),
                    BlendMode.srcIn,
                  ),
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                    "${dBloc.getSelectedMonth}  ${dBloc.getSelectedYear}",
                    style: AppTextStyle.detailsSemiBold(
                        context, AppColorStyle.text(context))),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDateTimePicker(
      BuildContext context, SoEOIStatisticsBloc dBloc) {
    String selectedMonth = dBloc.strMonthSelectedName;
    String selectedYear = dBloc.strYearSelectedValue;
    int monthIndex = dBloc.monthList.indexOf(dBloc.getSelectedMonth);
    int yearIndex = dBloc.yearList.indexOf(dBloc.getSelectedYear);
    return Material(
      child: Container(
        height: 260,
        color: AppColorStyle.background(context),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWellWidget(
                    onTap: () {
                      context.close(context);
                    },
                    child: Text(
                      StringHelper.cancel,
                      style: AppTextStyle.subHeadlineMedium(
                          context, AppColorStyle.redVariant1(context)),
                    ),
                  ),
                  InkWellWidget(
                    onTap: () {
                      context.close(context);
                      dBloc.setMonth = selectedMonth;
                      dBloc.setYear = selectedYear;
                      dBloc.callEOIStatisticsCountList();
                    },
                    child: Text(
                      StringHelper.doneText,
                      style: AppTextStyle.subHeadlineMedium(
                          context, AppColorStyle.primary(context)),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 200,
                  child: CupertinoPicker(
                    onSelectedItemChanged: (int value) {
                      selectedMonth = dBloc.monthList[value];
                      printLog(value);
                    },
                    itemExtent: 40,
                    scrollController:
                        FixedExtentScrollController(initialItem: monthIndex),
                    children: [
                      for (String month in dBloc.monthList)
                        Center(
                          child: Text(
                            month,
                            style: AppTextStyle.detailsMedium(
                                context, AppColorStyle.text(context)),
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 200,
                  child: CupertinoPicker(
                    onSelectedItemChanged: (int value) {
                      selectedYear = dBloc.yearList[value];
                      printLog(value);
                    },
                    itemExtent: 40,
                    scrollController:
                        FixedExtentScrollController(initialItem: yearIndex),
                    children: [
                      for (String year in dBloc.yearList)
                        Center(
                          child: Text(
                            year,
                            style: AppTextStyle.detailsMedium(
                                context, AppColorStyle.text(context)),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget dotAnimation(
      List<EOIData> eoiDataList, BuildContext context, int currentPage) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
            eoiDataList.length,
            (index) => animatedPageDot(context, currentPage,
                index: index, isBgBlue: true)),
      ),
    );
  }

  static Widget statisticsTableViewWidget(
      BuildContext context,
      List<EOIStatisticsDetailData> currentEOIStatistics,
      ThemeBloc themeBloc,
      SoEOIStatisticsBloc soEOIStatisticsBloc) {
    return currentEOIStatistics.isEmpty
        ? Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.only(top: 70),
            child: NetworkController.isInternetConnected == true
                ? Column(
                    children: [
                      SvgPicture.asset(
                        (themeBloc.currentTheme
                            ? IconsSVG.icNoDataAvailableDark
                            : IconsSVG.icNoDataAvailable),
                        height: 190,
                        width: 180,
                      ),
                      Text(
                        StringHelper.statisticsDataNotAvailable,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.captionRegular(
                          context,
                          AppColorStyle.text(context),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(height: 25.0),
                      SvgPicture.asset(
                        IconsSVG.noInternetIcon,
                        height: 190,
                        width: 180,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        NetworkAPIConstant.noInternetConnection,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.captionRegular(
                          context,
                          AppColorStyle.text(context),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      InkWellWidget(
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                                color: AppColorStyle.primary(context),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            child: Text(
                              "Retry",
                              style: AppTextStyle.detailsMedium(
                                context,
                                AppColorStyle.textWhite(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            soEOIStatisticsBloc.setEOIStatisticsCountData = [];
                            soEOIStatisticsBloc.setMonthYearData();
                            soEOIStatisticsBloc.callEOIStatisticsCountList();
                          })
                    ],
                  ),
          )
        : Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: AppColorStyle.primary(context), width: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height -
                    (currentEOIStatistics.length < 5
                        ? 300
                        : (MediaQuery.of(context).size.height - 200))),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Column(
                children: [
                  Container(
                    height: 50.0,
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
                              StringHelper.point,
                              maxLines: 1,
                              style: AppTextStyle.subTitleSemiBold(
                                context,
                                AppColorStyle.textWhite(context),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              StringHelper.count,
                              maxLines: 1,
                              style: AppTextStyle.subTitleSemiBold(
                                context,
                                AppColorStyle.textWhite(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: currentEOIStatistics.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 0),
                    shrinkWrap: true,
                    itemBuilder: (context, cIndex) {
                      final point = currentEOIStatistics[cIndex].point;
                      final count =
                          "${currentEOIStatistics[cIndex].prefix}${currentEOIStatistics[cIndex].eOICount}";
                      return Container(
                        color: cIndex % 2 == 0
                            ? AppColorStyle.background(context)
                            : AppColorStyle.surface(context),
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  '$point',
                                  style: AppTextStyle.detailsMedium(
                                      context, AppColorStyle.text(context)),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 0.5,
                              color: AppColorStyle.disableVariant(context),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  count,
                                  style: AppTextStyle.detailsMedium(
                                      context, AppColorStyle.text(context)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  static Widget statisticsChartViewWidget(
      BuildContext context,
      List<EOIStatisticsDetailData> currentEOIStatistics,
      TooltipBehavior? tooltip,
      ThemeBloc themeBloc,
      SoEOIStatisticsBloc soEOIStatisticsBloc) {
    return currentEOIStatistics.isEmpty
        ? Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.only(top: 100),
            child: NetworkController.isInternetConnected == true
                ? Column(
                    children: [
                      SvgPicture.asset(
                        (themeBloc.currentTheme
                            ? IconsSVG.icNoDataAvailableDark
                            : IconsSVG.icNoDataAvailable),
                        height: 190,
                        width: 180,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        StringHelper.statisticsDataNotAvailable,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.captionRegular(
                          context,
                          AppColorStyle.text(context),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const SizedBox(height: 25.0),
                      SvgPicture.asset(
                        IconsSVG.noInternetIcon,
                        height: 190,
                        width: 180,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        NetworkAPIConstant.noInternetConnection,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.captionRegular(
                          context,
                          AppColorStyle.text(context),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      InkWellWidget(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColorStyle.primary(context),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          child: Text("Retry",
                              style: AppTextStyle.detailsMedium(
                                context,
                                AppColorStyle.textWhite(context),
                              ),
                              textAlign: TextAlign.center),
                        ),
                        onTap: () {
                          soEOIStatisticsBloc.setEOIStatisticsCountData = [];
                          soEOIStatisticsBloc.setMonthYearData();
                          soEOIStatisticsBloc.callEOIStatisticsCountList();
                        },
                      ),
                    ],
                  ),
          )
        : Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.height - 300)),
            child: _buildDefaultDoughnutChart(
                tooltip, currentEOIStatistics, context),
          );
  }

  /// Return the circular chart with default doughnut series.
  static Theme _buildDefaultDoughnutChart(TooltipBehavior? tooltip,
      List<EOIStatisticsDetailData> data, BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: SfCircularChart(
        margin:
            const EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
        title: ChartTitle(
            text: '10', textStyle: const TextStyle(color: Colors.transparent)),
        legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            textStyle: AppTextStyle.captionRegular(
                context, AppColorStyle.text(context)),
            overflowMode: LegendItemOverflowMode.wrap),
        series: _getDefaultDoughnutSeries(context, data),
        tooltipBehavior: tooltip,
      ),
    );
  }

  /// Returns the doughnut series which need to be render.
  static List<DoughnutSeries<EOIChartData, String>> _getDefaultDoughnutSeries(
      BuildContext context, List<EOIStatisticsDetailData> data) {
    // Total sum of eoi statistics count
    int sumOfCount = 0;
    for (var eoi in data) {
      sumOfCount = sumOfCount + int.parse(eoi.eOICount ?? '0');
    }

    List<EOIChartData> countData = [];
    for (var eoi in data) {
      countData
          .add(EOIChartData(x: eoi.point, y: int.parse(eoi.eOICount.toString())
              // y: int.parse(eoi.eOICount ?? '0') / sumOfCount,
              /* text: eoi.eOICount*/));
    }

    return <DoughnutSeries<EOIChartData, String>>[
      DoughnutSeries<EOIChartData, String>(
        radius: '100%',
        explode: true,
        explodeOffset: '10%',
        dataSource: countData,
        xValueMapper: (EOIChartData data, _) => data.x as String,
        yValueMapper: (EOIChartData data, _) => data.y,
        dataLabelMapper: (EOIChartData data, _) => data.text,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle:
              AppTextStyle.captionRegular(context, AppColorStyle.text(context)),
        ),
      )
    ];
  }

  static Widget viewModeWidget(
      BuildContext context, SoEOIStatisticsBloc? osEOIBloc) {
    return StreamBuilder<bool>(
        stream: osEOIBloc?.viewMode,
        builder: (context, snapshot) {
          return InkWellWidget(
              onTap: () {
                osEOIBloc.setViewMode();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppColorStyle.whiteTextColor(context),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                width: 54,
                height: 28,
                /*  width: 54,
              height: 30,*/
                // padding: const EdgeInsets.all(1),
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      width: osEOIBloc!.getViewMode ? 26.0 : 80.0,
                      height: 26,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                      child: SvgPicture.asset(
                        osEOIBloc.getViewMode
                            ? IconsSVG.tableViewIcon
                            : IconsSVG.chartViewIcon,
                        /*  width: 20.0,
                      height: 20.0,*/
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}

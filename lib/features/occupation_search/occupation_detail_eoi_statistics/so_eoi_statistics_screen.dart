import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/expandablepageview/expandable_page_view.dart';
import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_eoi_statistics/so_eoi_statistics_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_eoi_statistics/so_eoi_statistics_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_eoi_statistics/so_eoi_statistics_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_eoi_statistics_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SoEOIStatisticsScreen extends BaseApp {
  const SoEOIStatisticsScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _SoEOIStatisticsScreenState();
}

class _SoEOIStatisticsScreenState extends BaseState
    with SingleTickerProviderStateMixin {
  PreferredSizeWidget? appBar() => null;

  late TooltipBehavior _tooltip;

  final PageController _pageController =
      PageController(initialPage: 0, keepPage: false);

  TabController? _tabController;

  SoEOIStatisticsBloc? soEOIStatisticsBloc;
  OccupationDetailBloc? searchOccupationBloc;
  bool descTextShowFlag = false;

  int messageLength = 80; //false = half text, true = full text

  DateTime dateTime = DateTime.now();

  @override
  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  initData() {
    searchOccupationBloc = searchOccupationBloc ??
        RxBlocProvider.of<OccupationDetailBloc>(context);
    soEOIStatisticsBloc?.setBloc(searchOccupationBloc);
    _tooltip =
        TooltipBehavior(enable: true, format: 'Point:point.x - Count:point.y');
    _tabController = TabController(length: 4, vsync: this);
    soEOIStatisticsBloc?.setEOIStatisticsCountData = [];
    soEOIStatisticsBloc?.setMonthYearData();
    soEOIStatisticsBloc?.callEOIStatisticsCountList();
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    soEOIStatisticsBloc ??= RxBlocProvider.of<SoEOIStatisticsBloc>(context);
    return RxBlocProvider(
        create: (_) => soEOIStatisticsBloc!,
        child: Container(
          color: AppColorStyle.background(context),
          child: StreamBuilder<List<EOIData>>(
              stream: soEOIStatisticsBloc?.eOIStatisticsDataStream,
              builder: (context, snapshot) {
                List<EOIData> ediDataList = snapshot.data ?? [];
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: DefaultTabController(
                            length: 4,
                            child: TabBar(
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              controller: _tabController,
                              onTap: (position) {
                                switch (position) {
                                  //Danger: do not change/correct below constant strings
                                  case 0:
                                    soEOIStatisticsBloc?.setType(
                                        "SUBMITTED", 0);
                                    break;
                                  case 1:
                                    soEOIStatisticsBloc?.setType("LODGED", 1);
                                    break;
                                  case 2:
                                    soEOIStatisticsBloc?.setType("HOLD", 2);
                                    break;
                                  case 3:
                                    soEOIStatisticsBloc?.setType("INVITED", 3);
                                    break;
                                }
                              },
                              indicatorColor: Colors.transparent,
                              unselectedLabelColor:
                                  AppColorStyle.textDetail(context),
                              labelColor: AppColorStyle.primary(context),
                              indicatorWeight: double.minPositive,
                              indicator: const BoxDecoration(),
                              dividerColor: Colors.transparent,
                              indicatorPadding: EdgeInsets.zero,
                              unselectedLabelStyle: AppTextStyle.detailsRegular(
                                  context, AppColorStyle.textDetail(context)),
                              labelStyle: AppTextStyle.detailsSemiBold(
                                  context, AppColorStyle.textDetail(context)),
                              isScrollable: true,
                              tabs: const [
                                //Danger: do not change/correct below constant strings
                                Text(
                                  'Submitted',
                                ),
                                Text(
                                  'Lodged',
                                ),
                                Text(
                                  'Held',
                                ),
                                Text(
                                  'Invited',
                                )
                              ],
                              indicatorSize: TabBarIndicatorSize.tab,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                          color: AppColorStyle.borderColors(context),
                          thickness: 1),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              //padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                  color: AppColorStyle.background(context),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: StreamBuilder<int>(
                                        stream: soEOIStatisticsBloc
                                            ?.pageViewPositionIndex,
                                        builder: (context, snapshot) {
                                          int currentPage = snapshot.data ?? 0;
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "Your Category",
                                                      style: AppTextStyle
                                                          .subHeadlineSemiBold(
                                                        context,
                                                        AppColorStyle.text(
                                                            context),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWellWidget(
                                                    onTap: () {
                                                      WidgetHelper.showAlertDialog(
                                                          context,
                                                          contentText:
                                                              soEOIStatisticsBloc!
                                                                  .noteMsg);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: SvgPicture.asset(
                                                        IconsSVG.fundBulb,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          AppColorStyle
                                                              .primaryVariant2(
                                                                  context),
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, bottom: 10),
                                                child: Text(
                                                  ediDataList.isNotEmpty &&
                                                          ediDataList.length >
                                                              currentPage &&
                                                          currentPage >= 0
                                                      ? soEOIStatisticsBloc
                                                          ?.getEOIVisaTitle(
                                                              currentPage)
                                                      : "-",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.left,
                                                  style: AppTextStyle
                                                      .captionRegular(
                                                    context,
                                                    AppColorStyle.text(context),
                                                  ),
                                                ),
                                              ),
                                              SoEOIStatisticsWidget
                                                  .dotAnimation(ediDataList,
                                                      context, currentPage),
                                            ],
                                          );
                                        }),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 5),
                                      SoEOIStatisticsWidget.viewModeWidget(
                                          context, soEOIStatisticsBloc),
                                      const SizedBox(height: 30),
                                      SoEOIStatisticsWidget.datePickerWidget(
                                          context, soEOIStatisticsBloc!),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            StreamBuilder<bool>(
                                stream: soEOIStatisticsBloc?.viewMode,
                                builder: (context, snapshot) {
                                  return StreamBuilder<bool>(
                                      stream: soEOIStatisticsBloc?.loading,
                                      builder: (context, snapshot) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20),
                                          child: (soEOIStatisticsBloc!
                                                  .getLoadingValue)
                                              ? (soEOIStatisticsBloc!
                                                      .getViewMode)
                                                  ? const SOEoiStatisticsShimmer()
                                                  : SOEoiStatisticsShimmer
                                                      .graphShimmer(
                                                          context) // Table Shimmer
                                              : ediDataList.isEmpty
                                                  ?
                                                  // Data not found widget
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          NetworkController
                                                                      .isInternetConnected ==
                                                                  true
                                                              ? Column(
                                                                  children: [
                                                                    SvgPicture
                                                                        .asset(
                                                                      (themeBloc!.currentTheme
                                                                          ? IconsSVG
                                                                              .icNoDataAvailableDark
                                                                          : IconsSVG
                                                                              .icNoDataAvailable),
                                                                      height:
                                                                          190,
                                                                      width:
                                                                          180,
                                                                    ),
                                                                    Text(
                                                                      StringHelper
                                                                          .statisticsDataNotAvailable,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: AppTextStyle
                                                                          .captionRegular(
                                                                        context,
                                                                        AppColorStyle.text(
                                                                            context),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Column(
                                                                  children: [
                                                                    const SizedBox(
                                                                        height:
                                                                            25.0),
                                                                    SvgPicture
                                                                        .asset(
                                                                      IconsSVG
                                                                          .noInternetIcon,
                                                                      height:
                                                                          190,
                                                                      width:
                                                                          180,
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            20.0),
                                                                    Text(
                                                                      NetworkAPIConstant
                                                                          .noInternetConnection,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: AppTextStyle
                                                                          .captionRegular(
                                                                        context,
                                                                        AppColorStyle.text(
                                                                            context),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            20.0),
                                                                    InkWellWidget(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100,
                                                                          decoration: BoxDecoration(
                                                                              color: AppColorStyle.primary(context),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 8.0,
                                                                              horizontal: 10.0),
                                                                          child: Text(
                                                                              "Retry",
                                                                              style: AppTextStyle.detailsMedium(
                                                                                context,
                                                                                AppColorStyle.textWhite(context),
                                                                              ),
                                                                              textAlign: TextAlign.center),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          soEOIStatisticsBloc?.setEOIStatisticsCountData =
                                                                              [];
                                                                          soEOIStatisticsBloc
                                                                              ?.setMonthYearData();
                                                                          soEOIStatisticsBloc
                                                                              ?.callEOIStatisticsCountList();
                                                                          //initData();
                                                                        }),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    )
                                                  : soEOIStatisticsBloc!
                                                          .getViewMode
                                                      ?
                                                      // Table view mode
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 50),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: [
                                                              ExpandablePageView
                                                                  .builder(
                                                                      physics:
                                                                          const BouncingScrollPhysics(),
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      controller:
                                                                          _pageController,
                                                                      onPageChanged:
                                                                          (value) {
                                                                        soEOIStatisticsBloc?.setPagePosition =
                                                                            value;
                                                                      },
                                                                      itemCount:
                                                                          ediDataList
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        // Here we process to show statistics count on current page...
                                                                        List<EOIStatisticsDetailData>
                                                                            currentEOIStatistics =
                                                                            soEOIStatisticsBloc?.getCurrentStatisticsCountList(index);
                                                                        // Table view mode
                                                                        if (soEOIStatisticsBloc!
                                                                            .getLoadingValue) {
                                                                          return const SOEoiStatisticsShimmer();
                                                                        } else {
                                                                          return SoEOIStatisticsWidget.statisticsTableViewWidget(
                                                                              context,
                                                                              currentEOIStatistics,
                                                                              themeBloc!,
                                                                              soEOIStatisticsBloc!);
                                                                        }
                                                                      }),
                                                              const SizedBox(
                                                                height: 10.0,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      :
                                                      // Chart view mode
                                                      Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            const SizedBox(
                                                              height: 20.0,
                                                            ),
                                                            ExpandablePageView
                                                                .builder(
                                                                    physics:
                                                                        const BouncingScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    controller:
                                                                        _pageController,
                                                                    onPageChanged:
                                                                        (value) {
                                                                      soEOIStatisticsBloc
                                                                              ?.setPagePosition =
                                                                          value;
                                                                    },
                                                                    itemCount:
                                                                        ediDataList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      _tooltip = TooltipBehavior(
                                                                          enable:
                                                                              true,
                                                                          format:
                                                                              'Point:point.x - Count:point.y');
                                                                      // Here we process to show statistics count on current page...
                                                                      List<EOIStatisticsDetailData>
                                                                          currentEOIStatistics =
                                                                          soEOIStatisticsBloc
                                                                              ?.getCurrentStatisticsCountList(index);
                                                                      // Chart view mode
                                                                      return SoEOIStatisticsWidget.statisticsChartViewWidget(
                                                                          context,
                                                                          currentEOIStatistics,
                                                                          _tooltip,
                                                                          themeBloc!,
                                                                          soEOIStatisticsBloc!);
                                                                    }),
                                                            const SizedBox(
                                                              height: 20.0,
                                                            ),
                                                          ],
                                                        ),
                                        );
                                      });
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ));
  }

  @override
  void dispose() {
    _tabController?.dispose();
    soEOIStatisticsBloc?.reInitialize();
    super.dispose();
  }
}

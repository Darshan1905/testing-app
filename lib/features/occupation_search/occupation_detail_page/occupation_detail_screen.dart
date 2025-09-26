// ignore_for_file: use_build_context_synchronously

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/labour_insights/labour_insight_bloc.dart';
import 'package:occusearch/features/labour_insights/labour_insight_occupation_screen.dart';
import 'package:occusearch/features/labour_insights/widgets/labour_insight_screen_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_all_visa_type/so_all_visa_type_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_all_visa_type/so_all_visa_type_screen.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_eoi_statistics/so_eoi_statistics_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_eoi_statistics/so_eoi_statistics_screen.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/occupations_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/so_state_eligibility_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/so_state_eligibility_screen.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_screen.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:occusearch/utility/TooltipShape.dart';
import 'package:occusearch/utility/rating/dynamic_rating_bloc.dart';

class SearchOccupationScreen extends BaseApp {
  const SearchOccupationScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _SearchOccupationScreenState();
}

class _SearchOccupationScreenState extends BaseState
    with SingleTickerProviderStateMixin {
  OccupationDetailBloc searchOccupationBloc = OccupationDetailBloc();
  SoAllVisaTypeBloc soAllVisaTypeBloc = SoAllVisaTypeBloc();
  SoStateEligibilityBloc soStateEligibilityBloc = SoStateEligibilityBloc();
  SoEOIStatisticsBloc soEOIStatisticsBloc = SoEOIStatisticsBloc();
  SoUnitGroupAndGeneralBloc soUnitGroupBloc = SoUnitGroupAndGeneralBloc();
  LabourInsightBloc soLabourInsightBloc = LabourInsightBloc();
  OccupationRowData? occupationRowData;
  GlobalBloc? _globalBloc;
  UserInfoData? info;
  late TabController _tabController;

  @override
  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  initData() async {
    _tabController = TabController(
        length: 5,
        vsync: this);
    _tabController.animateTo(2);
    occupationRowData = widget.arguments;
    try {
      info = await _globalBloc?.getUserInfo(context);
      await searchOccupationBloc.setOccupationSelection(
          occID: occupationRowData?.id ?? "",
          occMainID: occupationRowData?.mainId ?? "",
          occName: occupationRowData?.name ?? "",
          isAdded: occupationRowData?.isAdded ?? false);
      searchOccupationBloc.setBuildContextForBloc(context);
      // Here we set the current page context to show exit app toast message...
      searchOccupationBloc.initialAPICalling(occupationRowData?.id ?? '');

      DynamicRatingCalculation.updateRatingLocalCountByModuleName(
          SharedPreferenceConstants.occupationDetail);

      //To add when there is free trial plan, so that the bookmark count will increase
      if (globalBloc?.subscriptionType != AppType.PAID &&
          occupationRowData != null &&
          occupationRowData!.isAdded == false) {
        // Calling API to add new course
        OccupationData data = OccupationData();
        data.id = searchOccupationBloc.selectedOccupationID;
        data.mainId = searchOccupationBloc.selectedOccupationMainID;
        data.name = searchOccupationBloc.selectedOccupationName;
        searchOccupationBloc.addOccupation(data, info!.userId ?? 0, false);
      }
    } catch (e) {
      printLog(e);
    }
  }

  @override
  onResume() {}

  @override
  void dispose() {
    soLabourInsightBloc.isViewMoreSubject.close();
    super.dispose();
  }

// silver app bar rough work
  @override
  Widget body(BuildContext context) {
    occupationRowData = widget.arguments;
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return RxMultiBlocProvider(
      providers: [
        RxBlocProvider<OccupationDetailBloc>(
            create: (context) => searchOccupationBloc),
        RxBlocProvider<SoAllVisaTypeBloc>(
            create: (context) => soAllVisaTypeBloc),
        RxBlocProvider<SoStateEligibilityBloc>(
            create: (context) => soStateEligibilityBloc),
        RxBlocProvider<SoEOIStatisticsBloc>(
            create: (context) => soEOIStatisticsBloc),
        RxBlocProvider<SoUnitGroupAndGeneralBloc>(
            create: (context) => soUnitGroupBloc),
        RxBlocProvider<LabourInsightBloc>(
            create: (context) => soLabourInsightBloc),
      ],
      // create: (_) => searchOccupationBloc,
      child: Container(
        color: AppColorStyle.primary(context),
        child: SafeArea(
          bottom: false,
          child: StreamBuilder(
            stream: searchOccupationBloc.unitGroupAndGeneralDetailStream,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                //store recentOccupation details
                searchOccupationBloc.storeRecentOccupationDetails(
                    occupationRowData,
                    searchOccupationBloc.getOccupationOtherInfoData);
              }

              String occupationName =
                  searchOccupationBloc.selectedOccupationName;
              bool occupationIsAdded =
                  searchOccupationBloc.selectedOccupationIsAdded;

              bool isShowAlternateTitle =
                  searchOccupationBloc.occupationOtherInfoDataStream.hasValue &&
                      searchOccupationBloc
                              .getOccupationOtherInfoData.alternativeTitle !=
                          null &&
                      searchOccupationBloc.getOccupationOtherInfoData
                          .alternativeTitle!.isNotEmpty;
              return DefaultTabController(
                length: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        StreamBuilder<bool>(
                          stream:
                              searchOccupationBloc.occuAddRemoveLoaderStream,
                          builder: (context, snapshot) {
                            bool loading = snapshot.data ?? false;
                            occupationName =
                                searchOccupationBloc.selectedOccupationName;
                            occupationIsAdded =
                                searchOccupationBloc.selectedOccupationIsAdded;
                            return SliverOverlapAbsorber(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                              sliver: SliverSafeArea(
                                top: false,
                                sliver: SliverAppBar(
                                    expandedHeight: 160,
                                    backgroundColor:
                                        AppColorStyle.primary(context),
                                    floating: true,
                                    elevation: 0,
                                    toolbarHeight: 50,
                                    pinned: true,
                                    automaticallyImplyLeading: false,
                                    leadingWidth: 50,
                                    leading: InkWellWidget(
                                      onTap: () {
                                        context.pop();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: Constants.commonPadding),
                                        child: SvgPicture.asset(
                                          IconsSVG.arrowBack,
                                          colorFilter: ColorFilter.mode(
                                            AppColorStyle.textWhite(context),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 30,
                                        margin: const EdgeInsets.only(
                                            right: Constants.commonPadding,
                                            top: 10,
                                            bottom: 10),
                                        decoration: BoxDecoration(
                                            color: AppColorStyle.textWhite(
                                                context),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(40.0))),
                                        child: InkWellWidget(
                                          onTap: () {
                                            if (globalBloc?.subscriptionType ==
                                                AppType.PAID) {
                                              if (searchOccupationBloc
                                                  .selectedOccupationIsAdded) {
                                                // Calling API to remove added course
                                                searchOccupationBloc
                                                    .deleteOccupation(
                                                        searchOccupationBloc
                                                            .selectedOccupationID,
                                                        info!.userId
                                                            .toString());
                                              } else {
                                                if (searchOccupationBloc
                                                    .selectedOccupationName
                                                    .isNotEmpty) {
                                                  // Calling API to add new course
                                                  OccupationData data =
                                                      OccupationData();
                                                  data.id = searchOccupationBloc
                                                      .selectedOccupationID;
                                                  data.mainId = searchOccupationBloc
                                                      .selectedOccupationMainID;
                                                  data.name = searchOccupationBloc
                                                      .selectedOccupationName;
                                                  searchOccupationBloc
                                                      .addOccupation(
                                                          data,
                                                          info!.userId ?? 0,
                                                          true);
                                                }
                                              }
                                            } else {
                                              GoRoutesPage.go(
                                                  mode: NavigatorMode.push,
                                                  moveTo:
                                                      RouteName.subscription);
                                            }
                                          },
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3.5,
                                                      horizontal: 5),
                                              child: loading
                                                  ? SizedBox(
                                                      height: 15,
                                                      width: 15,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1.5,
                                                        color: AppColorStyle
                                                            .primary(context),
                                                      ),
                                                    )
                                                  : SvgPicture.asset(
                                                      occupationIsAdded
                                                          ? IconsSVG
                                                              .bookmarkSelected
                                                          : IconsSVG
                                                              .bookmarkUnselected,
                                                    )),
                                        ),
                                      )
                                    ],
                                    title:
                                        // innerBoxIsScrolled ?
                                        Text(
                                            "${StringHelper.anzscoText} ${searchOccupationBloc.selectedOccupationMainID}",
                                            style: AppTextStyle.subTitleMedium(
                                                context,
                                                AppColorStyle.textWhite(
                                                    context)))
                                    // : const SizedBox(),
                                    ,
                                    centerTitle: false,
                                    flexibleSpace: flexibleTitleBar(context,
                                        title: occupationName,
                                        isShowAlternateTitle:
                                            isShowAlternateTitle,
                                        innerBoxIsScrolled:
                                            innerBoxIsScrolled)),
                              ),
                            );
                          },
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                                    unselectedLabelColor:
                                        AppColorStyle.primaryVariant2(context),
                                    labelColor:
                                        AppColorStyle.textWhite(context),
                                    indicatorColor:
                                        AppColorStyle.yellow(context),
                                    indicatorWeight: 3,
                                    //labelPadding: const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
                                    labelStyle: AppTextStyle.detailsMedium(
                                        context, AppColorStyle.text(context)),
                                    isScrollable: true,
                                    onTap: (index) {
                                      if (index == 4 && globalBloc?.subscriptionType != AppType.PAID) {
                                        GoRoutesPage.go(
                                            mode: NavigatorMode.push,
                                            moveTo: RouteName.subscription);
                                      }
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Constants.commonPadding),
                                    tabs: <Widget>[
                                      const Text(
                                        StringHelper.allVisaType,
                                      ),
                                      const Text(
                                        StringHelper.stateEligibility,
                                      ),
                                      const Text(
                                        StringHelper.eoiStatistics,
                                      ),
                                      const Text(
                                        StringHelper.unitGroupAndGeneral,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            StringHelper.labourInsights,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          globalBloc?.subscriptionType == AppType.PAID
                                              ? Container()
                                              : SvgPicture.asset(
                                                  IconsSVG.icPremiumFeature,
                                                  width: 20,
                                                  height: 20,
                                                )
                                        ],
                                      ),
                                    ],
                                    indicatorSize: TabBarIndicatorSize.label,
                                  ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                            physics: globalBloc?.subscriptionType == AppType.PAID ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
                            // physics: const NeverScrollableScrollPhysics(),
                            children: [
                              // All Visa Type
                              SoAllVisaTypeScreen(
                                arguments: widget.arguments,
                              ),
                              // State Eligibility
                              const SoStateEligibilityScreen(),
                              // EOI Statistics
                              const SoEOIStatisticsScreen(),
                              // Unit Group and General Tab
                              const SoUnitGroupAndGeneralScreen(),
                              //Labour Insights Tab
                              globalBloc?.subscriptionType == AppType.PAID ? LabourInsightOccupationScreen(
                                  arguments: occupationRowData!.id) : const LabourInsightScreenShimmer(
                                isActionBarShow: false,
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double get maxHeight => 80 + MediaQuery.of(context).padding.top;

  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  Widget flexibleTitleBar(BuildContext context,
      {String? title, bool? isShowAlternateTitle, bool? innerBoxIsScrolled}) {
    double calculateExpandRatio(BoxConstraints constraints) {
      var expandRatio =
          (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
      if (expandRatio > 1.0) expandRatio = 1.0;
      if (expandRatio < 0.0) expandRatio = 0.0;
      return expandRatio;
    }

    Widget buildTitle(Animation<double> animation) {
      return Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          innerBoxIsScrolled == true
              ? const SizedBox()
              : Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: SvgPicture.asset(
                    IconsSVG.headerBg,
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5),
                      BlendMode.srcIn,
                    ),
                    //color: AppColorStyle.primarySurface1(context),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(
                left: Constants.commonPadding,
                right: Constants.commonPadding,
                top: 65),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  innerBoxIsScrolled == false
                      ? title!.isNotEmpty
                          ? RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: title,
                                style: AppTextStyle.titleBold(
                                    context, AppColorStyle.textWhite(context)),
                                children: [
                                  WidgetSpan(
                                    child: isShowAlternateTitle == true
                                        ? PopupMenuButton(
                                            offset: const Offset(0, 40),
                                            icon: SvgPicture.asset(
                                              IconsSVG.icInfo,
                                              colorFilter: ColorFilter.mode(
                                                AppColorStyle.textWhite(
                                                    context),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                                bottom: 15),
                                            color: AppColorStyle.background(
                                                context),
                                            shape: const TooltipShape(),
                                            itemBuilder:
                                                (BuildContext context) => [
                                                      PopupMenuItem(
                                                          //  padding: EdgeInsets.all(5),
                                                          child: Text(
                                                        searchOccupationBloc
                                                            .getOccupationOtherInfoData
                                                            .alternativeTitle
                                                            .toString(),
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle
                                                                    .textDetail(
                                                                        context)),
                                                      )),
                                                    ])
                                        : const SizedBox(),
                                    alignment: PlaceholderAlignment.top,
                                  ),
                                ],
                              ),
                            )
                          : const OccupationDetailShimmer()
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final expandRatio = calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);
        return buildTitle(animation);
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => 40;

  @override
  double get maxExtent => 40;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 40,
      color: AppColorStyle.primary(context),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

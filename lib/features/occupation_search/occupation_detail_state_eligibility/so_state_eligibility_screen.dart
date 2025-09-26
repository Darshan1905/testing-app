import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/no_internet_screen.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_se_visa_type_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_state_eligibility_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_state_eligibility_statewise_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/so_state_eligibility_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/so_state_eligibility_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/so_state_eligibility_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/widget/circle_painter.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_state_eligibility/widget/so_state_eligibility_detail_widget.dart';

class SoStateEligibilityScreen extends BaseApp {
  const SoStateEligibilityScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _SoStateEligibilityScreenState();
}

class _SoStateEligibilityScreenState extends BaseState
    with TickerProviderStateMixin {
  SoStateEligibilityBloc? soStateEligibilityBloc;
  OccupationDetailBloc? searchOccupationBloc;
  bool isLoading = false;
  late AnimationController _animationController;

  @override
  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  initData() async {
    searchOccupationBloc = searchOccupationBloc ??
        RxBlocProvider.of<OccupationDetailBloc>(context);
    soStateEligibilityBloc?.setBloc(context);
    await soStateEligibilityBloc!
        .callVisaList(searchOccupationBloc?.selectedOccupationID ?? "0");
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    soStateEligibilityBloc ??=
        RxBlocProvider.of<SoStateEligibilityBloc>(context);
    return RxBlocProvider(
      create: (_) => soStateEligibilityBloc!,
      child: Container(
        color: AppColorStyle.background(context),
        child: StreamBuilder<List<VisaTypeData>>(
          stream: soStateEligibilityBloc?.visaTypeListStream,
          builder: (context, snapshot) {
            final List<VisaTypeData> visaTypeList = snapshot.data ?? [];
            return (visaTypeList.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: AppColorStyle.background(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: SoStateEligibilityWidget.tabWidget(
                              context,
                              soStateEligibilityBloc!,
                              searchOccupationBloc?.selectedOccupationID ?? '',
                              visaTypeList),
                        ),
                      ),
                      Container(
                        height: 0.5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset:
                                  Offset(5, 5), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<List<StateEligibilityDetailRowData>>(
                        stream: soStateEligibilityBloc?.soStateListStream,
                        builder: (context, snapshot) {
                          List<StateEligibilityDetailRowData> seStateList =
                              snapshot.data ?? [];
                          if (soStateEligibilityBloc!.loading) {
                            return Expanded(
                                child: SoStateEligibilityShimmer
                                    .stateEligibilityDetailsShimmer(context));
                          }
                          return Expanded(
                            child: ListView.builder(
                              key: Key(
                                  'builder ${soStateEligibilityBloc?.firstIndexToOpen.toString()}'),
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: seStateList.length,
                              itemBuilder: (context, stateIndex) {
                                final StateEligibilityDetailRowData stateData =
                                    seStateList[stateIndex];
                                final Color textColor = SoStateEligibilityWidget
                                    .getStateStatusColor(stateData.classColor!,
                                        stateData.isOpen!, context);
                                final Color bgColor = SoStateEligibilityWidget
                                    .getStateStatusBgColor(
                                        stateData.classColor!,
                                        stateData.isOpen!,
                                        context);
                                final bool isDamaTab = (visaTypeList[
                                            soStateEligibilityBloc
                                                ?.getTabSelectedIndex]
                                        .visaType
                                        .toString() ==
                                    "291");
                                final bool isLinkShow =
                                    ((stateData.stateCondition == null ||
                                            (stateData.stateCondition != null &&
                                                stateData.stateCondition!
                                                    .isEmpty)) &&
                                        (stateData.link != null &&
                                            stateData.link != ""));
                                return Stack(
                                  children: [
                                    Visibility(
                                      visible:
                                          stateIndex != seStateList.length - 1,
                                      child: Positioned(
                                        top: stateIndex == 0 ? 20 : 0,
                                        bottom: 0,
                                        right: 19,
                                        width: 1,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: stateData.isExpanded
                                                  ? 0.0
                                                  : 10,
                                              top: stateData.isExpanded
                                                  ? 0.0
                                                  : 10),
                                          color:
                                              AppColorStyle.textHint(context),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 5,
                                      width: 30,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          stateIndex == seStateList.length - 1
                                              ? Container(
                                                  height: 20,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 1.0),
                                                  child: VerticalDivider(
                                                    thickness: 1.0,
                                                    color:
                                                        AppColorStyle.textHint(
                                                            context),
                                                  ),
                                                )
                                              : const SizedBox(
                                                  height: 20,
                                                ),
                                          seStateList[stateIndex]
                                                          .stateCondition !=
                                                      null &&
                                                  seStateList[stateIndex]
                                                      .stateCondition!
                                                      .isNotEmpty
                                              ? CustomPaint(
                                                  painter: CirclePainter(
                                                    _animationController,
                                                    color:
                                                        AppColorStyle.primary(
                                                            context),
                                                  ),
                                                  child: Center(
                                                    child: Container(
                                                      height: 22,
                                                      width: 24,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: AppColorStyle
                                                            .primary(context),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Text(
                                                        (seStateList[stateIndex]
                                                                    .state!
                                                                    .length >
                                                                3)
                                                            ? seStateList[
                                                                    stateIndex]
                                                                .state!
                                                                .substring(0, 3)
                                                                .toUpperCase()
                                                            : seStateList[
                                                                    stateIndex]
                                                                .state
                                                                .toString(),
                                                        style: AppTextStyle
                                                            .extraSmallMedium(
                                                                context,
                                                                AppColorStyle
                                                                    .textWhite(
                                                                        context)),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height: 26,
                                                  width: 26,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          AppColorStyle.surface(
                                                              context)),
                                                  child: Center(
                                                    child: Text(
                                                      (seStateList[stateIndex]
                                                                  .state!
                                                                  .length >
                                                              3)
                                                          ? seStateList[
                                                                  stateIndex]
                                                              .state!
                                                              .substring(0, 3)
                                                              .toUpperCase()
                                                          : seStateList[
                                                                  stateIndex]
                                                              .state
                                                              .toString(),
                                                      style: AppTextStyle
                                                          .smallMedium(
                                                              context,
                                                              AppColorStyle
                                                                  .textDetail(
                                                                      context)),
                                                    ),
                                                  )),
                                        ],
                                      ),
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        childrenPadding: EdgeInsets.zero,
                                        expandedCrossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        initiallyExpanded: stateIndex ==
                                            soStateEligibilityBloc
                                                ?.firstIndexToOpen,
                                        tilePadding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: Constants.commonPadding,
                                            top: 20),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Utility.getFullNameOfAUState(
                                                  stateData.state ?? ''),
                                              style: AppTextStyle.titleSemiBold(
                                                  context,
                                                  AppColorStyle.text(context)),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: (stateData
                                                                    .classColor! ==
                                                                "check-green" &&
                                                            stateData.isOpen! ==
                                                                1)
                                                        ? bgColor
                                                            .withOpacity(0.1)
                                                        : bgColor,
                                                  ),
                                                  child: Text(
                                                    SoStateEligibilityWidget
                                                        .getStateStatusClass(
                                                            stateData
                                                                .classColor!,
                                                            stateData.isOpen!),
                                                    style: AppTextStyle
                                                        .smallMedium(
                                                            context, textColor),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                isLinkShow
                                                    ? SvgPicture.asset(
                                                        IconsSVG.linkIcon,
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: const SizedBox(),
                                        onExpansionChanged: ((isExpand) {
                                          if (isLinkShow) {
                                            Utility.launchURL(
                                                stateData.link ?? "");
                                          }
                                          if (stateData.stateCondition !=
                                                  null &&
                                              stateData
                                                  .stateCondition!.isNotEmpty) {
                                            setState(() {
                                              stateIndex ==
                                                      soStateEligibilityBloc
                                                          ?.firstIndexToOpen
                                                  ? soStateEligibilityBloc
                                                      ?.firstIndexToOpen = -1
                                                  : soStateEligibilityBloc
                                                          ?.firstIndexToOpen =
                                                      stateIndex;
                                            });
                                          }
                                        }),
                                        collapsedIconColor:
                                            AppColorStyle.primary(context),
                                        children: [
                                          ListView.builder(
                                            itemCount: stateData
                                                .stateCondition?.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemBuilder:
                                                (context, stateConditionIndex) {
                                              StateCondition?
                                                  stateConditionData =
                                                  stateData.stateCondition![
                                                      stateConditionIndex];
                                              StateEligibilityDetailModel?
                                                  stateDetailsData =
                                                  stateConditionData
                                                      .stateEligibilityDetailModel;
                                              if (!isDamaTab) {
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0, top: 15.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: SoStateEligibilityDetailWidget
                                                            .otherFactorEligibilityRequirement(
                                                          context: context,
                                                          stateConditionList:
                                                              stateData
                                                                  .stateCondition!,
                                                          stateConditionIndex:
                                                              stateConditionIndex,
                                                          occupationCode:
                                                              searchOccupationBloc
                                                                      ?.selectedOccupationID ??
                                                                  '',
                                                          isGeneralEligibilityChangeListener:
                                                              (stateConditionData) {
                                                            stateData.stateCondition![
                                                                    stateConditionIndex] =
                                                                stateConditionData;
                                                            soStateEligibilityBloc
                                                                    ?.setSoStateList =
                                                                seStateList;
                                                          },
                                                          isSpecialRequirementChangeListener:
                                                              (stateConditionData) {
                                                            stateData.stateCondition![
                                                                    stateConditionIndex] =
                                                                stateConditionData;
                                                            soStateEligibilityBloc
                                                                    ?.setSoStateList =
                                                                seStateList;
                                                          },
                                                          isOccRequirementChangeListener:
                                                              (stateConditionData) {
                                                            stateData.stateCondition![
                                                                    stateConditionIndex] =
                                                                stateConditionData;
                                                            soStateEligibilityBloc
                                                                    ?.setSoStateList =
                                                                seStateList;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return SoStateEligibilityDetailWidget
                                                    .otherOccupationsDetailDAMA(
                                                        context,
                                                        stateDetailsData?.data,
                                                        stateDetailsData
                                                                ?.region ??
                                                            "");
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : NetworkController.isInternetConnected
                    ? SoStateEligibilityShimmer
                        .stateEligibilityDetailsShimmer(context)
                    : NoInternetScreen(
                        onRetry: () {
                          setState(
                            () {
                              initData();
                            },
                          );
                        },
                      );
          },
        ),
      ),
    );
  }

  Widget sectionFooterWidget() {
    final double bottomSafeArea = MediaQuery.of(context).viewPadding.bottom;
    return Padding(
      padding: EdgeInsets.only(
          left: Constants.commonPadding,
          right: Constants.commonPadding,
          bottom: bottomSafeArea > 0 ? bottomSafeArea : 20),
      child: Column(
        children: [
          Divider(color: AppColorStyle.borderColors(context), thickness: 1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status:",
                style: AppTextStyle.detailsMedium(
                    context, AppColorStyle.textDetail(context)),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    IconsSVG.icCheckGreen,
                    width: 16.0,
                    height: 16.0,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    StringHelper.highEligibility,
                    style: AppTextStyle.captionMedium(
                        context, AppColorStyle.text(context)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 10),
                    child: SvgPicture.asset(
                      IconsSVG.redCrossIcon,
                      width: 16.0,
                      height: 16.0,
                    ),
                  ),
                  Text(
                    StringHelper.lowEligibility,
                    style: AppTextStyle.captionMedium(
                        context, AppColorStyle.text(context)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget trailingStateWiseWidget(StateCondition stateConditionData) {
    return stateConditionData.isExpanded
        ? SvgPicture.asset(
            IconsSVG.arrowUpIcon,
            colorFilter: ColorFilter.mode(
              AppColorStyle.primary(context),
              BlendMode.srcIn,
            ),
          )
        : SvgPicture.asset(
            IconsSVG.arrowHalfRight,
            colorFilter: ColorFilter.mode(
              AppColorStyle.primary(context),
              BlendMode.srcIn,
            ),
          );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

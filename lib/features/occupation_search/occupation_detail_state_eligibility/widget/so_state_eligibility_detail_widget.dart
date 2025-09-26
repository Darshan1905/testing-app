import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_state_eligibility_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_state_eligibility_statewise_model.dart';

class SoStateEligibilityDetailWidget {
  // [OTHER FACTOR WIDGET]
  static otherFactorEligibilityRequirement(
      {required BuildContext context,
      required List<StateCondition> stateConditionList,
      required int stateConditionIndex,
      required String occupationCode,
      required Function isGeneralEligibilityChangeListener,
      required Function isSpecialRequirementChangeListener,
      required Function isOccRequirementChangeListener}) {
    StateCondition? stateCondition = stateConditionList[stateConditionIndex];

    SEDData stateEligibilityData =
        stateCondition.stateEligibilityDetailModel!.data!;
    String regionName =
        stateCondition.stateEligibilityDetailModel?.region ?? '';
    // Employee (%Share)
    String empShare = "";
    if (stateEligibilityData.empShare != null &&
        stateEligibilityData.empShare!.isNotEmpty) {
      empShare =
          "${stateEligibilityData.empShare![0].occupationName ?? ''}: ${stateEligibilityData.empShare![0].acrm ?? ''}% \nAll Jobs ${stateEligibilityData.empShare![0].alljobs ?? ''}%";
    }

    // Application Mode
    String applicationMode = "";
    if (stateEligibilityData.region != null &&
        stateEligibilityData.region!.isNotEmpty) {
      applicationMode = stateEligibilityData.region![0].applicationMode ?? '';
    }

    // Processing Time
    String processingTime = "";
    if (stateEligibilityData.region != null &&
        stateEligibilityData.region!.isNotEmpty) {
      processingTime = stateEligibilityData.region![0].processingTime ?? '';
    }

    // Fees
    String fees = "";
    if (stateEligibilityData.region != null &&
        stateEligibilityData.region!.isNotEmpty) {
      fees = stateEligibilityData.region![0].fees ?? '';
    }

    // Employee Currently submitted
    String eOISubmitted = "";
    if (stateEligibilityData.eoistatecount != null &&
        stateEligibilityData.eoistatecount!.isNotEmpty) {
      eOISubmitted =
          "${stateEligibilityData.eoistatecount![0].prefix ?? ''} ${stateEligibilityData.eoistatecount![0].eOICount ?? ''}";
    }

    // Source
    String source = "";
    if (stateEligibilityData.region != null &&
        stateEligibilityData.region!.isNotEmpty &&
        stateEligibilityData.region![0].state != null &&
        stateEligibilityData.region![0].region != null) {
      source =
          "Based on data/information available on ${stateEligibilityData.region![0].state} (${stateEligibilityData.region![0].region}) state nomination authority website and Job outlook website.";
    }

    //link
    String link = "";
    if (stateEligibilityData.region != null &&
        stateEligibilityData.region!.isNotEmpty &&
        stateEligibilityData.region![0].link != null &&
        stateEligibilityData.region![0].link!.isNotEmpty &&
        stateEligibilityData.region![0].link != "undefined") {
      link = stateEligibilityData.region![0].link!;
    }

    int processingWords =
        processingTime.isNotEmpty ? processingTime.split(' ').length : 0;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: AppColorStyle.primarySurface2(context),
            ),
          ),
        ),
        Column(
          children: [
            if (stateEligibilityData.region != null &&
                stateEligibilityData.region!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  stateConditionList[stateConditionIndex]
                                          .region ??
                                      '',
                                  style: AppTextStyle.subTitleSemiBold(
                                      context, AppColorStyle.text(context))),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    StringHelper.processingTime,
                                    style: AppTextStyle.captionRegular(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                  (stateEligibilityData
                                              .region![0].link!.isNotEmpty &&
                                          stateEligibilityData
                                                  .region![0].link !=
                                              "undefined")
                                      ? InkWellWidget(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: SvgPicture.asset(
                                              IconsSVG.linkIcon,
                                              height: 18,
                                              width: 18,
                                            ),
                                          ),
                                          onTap: () {
                                            Utility.launchURL(
                                                stateEligibilityData
                                                        .region![0].link ??
                                                    "");
                                          })
                                      : Container(),
                                ],
                              ),
                              processingTime.isNotEmpty
                                  ? processingWords < 3
                                      ? Text(
                                          processingTime,
                                          style: AppTextStyle.detailsMedium(
                                              context,
                                              AppColorStyle.text(context)),
                                        )
                                      : Text(
                                          processingTime,
                                          style: AppTextStyle.detailsMedium(
                                              context,
                                              AppColorStyle.primary(context)),
                                        )
                                  : Text(
                                      StringHelper.notAvailable,
                                      style: AppTextStyle.captionRegular(
                                          context,
                                          AppColorStyle.primary(context)),
                                    ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                StringHelper.applicationMode,
                                style: AppTextStyle.captionRegular(
                                    context, AppColorStyle.textDetail(context)),
                              ),
                              if (applicationMode.isNotEmpty)
                                Text(
                                  applicationMode,
                                  style: AppTextStyle.detailsMedium(
                                      context, AppColorStyle.text(context)),
                                )
                              else
                                Text(
                                  "N/A",
                                  style: AppTextStyle.captionRegular(
                                      context, AppColorStyle.primary(context)),
                                ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              if (empShare.isNotEmpty)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          StringHelper.employeeShare,
                                          style: AppTextStyle.captionRegular(
                                              context,
                                              AppColorStyle.textDetail(
                                                  context)),
                                        ),
                                        if (empShare.isNotEmpty &&
                                            empShare != "undefined")
                                          InkWellWidget(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: SvgPicture.asset(
                                                  IconsSVG.linkIcon,
                                                  height: 18,
                                                  width: 18,
                                                ),
                                              ),
                                              onTap: () {
                                                Utility.launchURL(Constants
                                                    .jobOutLookDomainOccupation);
                                              }),
                                      ],
                                    ),
                                    empShare.isNotEmpty
                                        ? Text(
                                            empShare,
                                            style: AppTextStyle.detailsMedium(
                                                context,
                                                AppColorStyle.text(context)),
                                          )
                                        : Text(
                                            StringHelper.notAvailable,
                                            style: AppTextStyle.captionRegular(
                                                context,
                                                AppColorStyle.text(context)),
                                          ),
                                  ],
                                ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                StringHelper.eoiSubmitted,
                                style: AppTextStyle.captionRegular(
                                    context, AppColorStyle.textDetail(context)),
                              ),
                              if (eOISubmitted.isNotEmpty)
                                Text(
                                  eOISubmitted.trim(),
                                  style: AppTextStyle.detailsMedium(
                                      context, AppColorStyle.text(context)),
                                )
                              else
                                Text(
                                  "N/A",
                                  style: AppTextStyle.captionRegular(
                                      context, AppColorStyle.primary(context)),
                                ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    StringHelper.outstandingFees,
                                    style: AppTextStyle.captionRegular(context,
                                        AppColorStyle.textDetail(context)),
                                  ),
                                  if (stateEligibilityData
                                          .region![0].feesLink!.isNotEmpty &&
                                      stateEligibilityData
                                              .region![0].feesLink !=
                                          "undefined")
                                    InkWellWidget(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: SvgPicture.asset(
                                          IconsSVG.linkIcon,
                                          height: 18,
                                          width: 18,
                                        ),
                                      ),
                                      onTap: () {
                                        Utility.launchURL(stateEligibilityData
                                                .region![0].feesLink ??
                                            "");
                                      },
                                    ),
                                ],
                              ),
                              if (fees.isNotEmpty)
                                Text(
                                  fees,
                                  style: AppTextStyle.detailsMedium(
                                      context, AppColorStyle.text(context)),
                                )
                              else
                                Text(
                                  StringHelper.notAvailable,
                                  style: AppTextStyle.captionRegular(
                                      context, AppColorStyle.primary(context)),
                                ),
                              const SizedBox(height: 30),
                              if (source.isNotEmpty)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                            text: StringHelper.source,
                                            style: AppTextStyle.captionSemiBold(
                                                context,
                                                AppColorStyle.textDetail(
                                                    context)),
                                            children: [
                                              TextSpan(
                                                  text: source,
                                                  style: AppTextStyle
                                                      .captionRegular(
                                                          context,
                                                          AppColorStyle
                                                              .textDetail(
                                                                  context))),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, right: 4.0),
                        child: dotWidget(true, context),
                      )
                    ],
                  ),
                ],
              )
            else
              const Text(StringHelper.dataNotAvailable),
            const SizedBox(height: 15),
            generalEligibilityRequirement(
              context: context,
              stateConditionList: stateConditionList,
              stateConditionIndex: stateConditionIndex,
              onExpanded: isGeneralEligibilityChangeListener,
            ),
            specialRequirementWidget(
              context,
              stateCondition,
              isSpecialRequirementChangeListener,
            ),
            englishRequirementWidget(
              context,
              stateCondition,
              isOccRequirementChangeListener,
            ),
            InkWellWidget(
              onTap: () {
                Utility.launchURL(link);
              },
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, right: 20, left: 10),
                  child: RichText(
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: regionName,
                      style: TextStyle(
                          fontSize: 14, color: AppColorStyle.primary(context)),
                      children: [
                        WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: SvgPicture.asset(IconsSVG.linkIcon),
                            ),
                            alignment: PlaceholderAlignment.middle),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  static Widget generalEligibilityRequirement(
      {required BuildContext context,
      required List<StateCondition> stateConditionList,
      required int stateConditionIndex,
      required Function onExpanded}) {
    List<StaterequirementG> stateRequirementG =
        stateConditionList[stateConditionIndex]
                .stateEligibilityDetailModel
                ?.data
                ?.staterequirementG ??
            [];
    return (stateRequirementG.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 25.0),
                child: Divider(
                    color: AppColorStyle.borderColors(context),
                    thickness: 0.5),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${stateConditionList[stateConditionIndex].state ?? ''} ${StringHelper.generalEligibility}",
                            style: AppTextStyle.detailsMedium(
                                context, AppColorStyle.primary(context)),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              children: List.generate(
                                  stateRequirementG.length,
                                  (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              stateRequirementG[index]
                                                      .condition ??
                                                  "",
                                              style:
                                                  AppTextStyle.captionSemiBold(
                                                context,
                                                AppColorStyle.text(context),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "\u2022  ",
                                                  style: AppTextStyle
                                                      .detailsSemiBold(
                                                          context,
                                                          AppColorStyle
                                                              .textDetail(
                                                                  context)),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: (stateRequirementG
                                                                        .length -
                                                                    1 !=
                                                                index)
                                                            ? 8.0
                                                            : 0.0),
                                                    child: Text(
                                                        stateRequirementG[index]
                                                                .cvalue ??
                                                            "",
                                                        style: AppTextStyle
                                                            .captionRegular(
                                                                context,
                                                                AppColorStyle
                                                                    .textDetail(
                                                                        context))),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0, top: 8.0),
                    child: dotWidget(false, context),
                  ),
                ],
              ),
            ],
          )
        : const SizedBox();
  }

  static Widget specialRequirementWidget(BuildContext context,
      StateCondition stateCondition, Function onExpanded) {
    List<StaterequirementSpe> stateRequirementSpe =
        stateCondition.stateEligibilityDetailModel?.data?.staterequirementSpe ??
            [];
    return (stateRequirementSpe.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 25.0),
                child: Divider(
                    color: AppColorStyle.borderColors(context),
                    thickness: 0.5),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringHelper.skillRequirement,
                            //[bug:AAMA-1346] stateName + " Special Requirement",
                            style: AppTextStyle.detailsMedium(
                                context, AppColorStyle.primary(context)),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              children: List.generate(
                                  stateRequirementSpe.length,
                                  (index) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: (stateRequirementSpe
                                                                .length -
                                                            1 !=
                                                        index)
                                                    ? 15.0
                                                    : 0.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "\u2022  ",
                                                  style: AppTextStyle
                                                      .detailsSemiBold(
                                                          context,
                                                          AppColorStyle
                                                              .textDetail(
                                                                  context)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      stateRequirementSpe[index]
                                                              .cvalue ??
                                                          "",
                                                      style: AppTextStyle
                                                          .captionRegular(
                                                              context,
                                                              AppColorStyle
                                                                  .textDetail(
                                                                      context))),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0, top: 8.0),
                    child: dotWidget(false, context),
                  ),
                ],
              ),
            ],
          )
        : Container();
  }

  static Widget englishRequirementWidget(BuildContext context,
      StateCondition stateCondition, Function onExpanded) {
    List<EngReq> englishTTS =
        stateCondition.stateEligibilityDetailModel?.data?.engReq ?? [];
    List<EngReqENS> englishENS =
        stateCondition.stateEligibilityDetailModel?.data?.engReqEns ?? [];
    return (englishTTS.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 25.0),
                child: Divider(
                    color: AppColorStyle.borderColors(context),
                    thickness: 0.5),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${stateCondition.state ?? ''}  ${StringHelper.occupationRequirement}",
                            style: AppTextStyle.detailsMedium(
                                context, AppColorStyle.primary(context)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 20, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 15, right: 10),
                                  child: Text(
                                    englishENS.isNotEmpty
                                        ? "TSS"
                                        : "English Requirement",
                                    maxLines: 1,
                                    style: AppTextStyle.captionSemiBold(
                                        context, AppColorStyle.text(context)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                if (englishTTS.isNotEmpty)
                                  englishReqModifiedTSSTable(
                                      context, englishTTS),
                                SizedBox(
                                  height: englishENS.isNotEmpty ? 25.0 : 0.0,
                                ),
                                if (englishENS.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 5),
                                          child: Text(
                                            "ENS",
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            style: AppTextStyle.captionSemiBold(
                                                context,
                                                AppColorStyle.text(context)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (englishENS.isNotEmpty)
                                  englishReqModifiedENSTable(
                                      context, englishENS),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0, top: 8.0),
                    child: dotWidget(false, context),
                  ),
                ],
              ),
            ],
          )
        : Container();
  }

  //DAMA(291)
  static Widget otherOccupationsDetailDAMA(
      BuildContext context, SEDData? selectedRegionData, String regionName) {
    return (selectedRegionData != null &&
            selectedRegionData.region != null &&
            selectedRegionData.region![0].link != null &&
            selectedRegionData.region![0].link!.isNotEmpty &&
            selectedRegionData.region![0].link != "undefined")
        ? Container(
            margin: const EdgeInsets.only(top: 20, left: 0, right: 00),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColorStyle.background(context)),
            child: InkWellWidget(
              onTap: () {
                Utility.launchURL(selectedRegionData.region![0].link ?? "");
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(regionName,
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColorStyle.primary(context))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: SvgPicture.asset(IconsSVG.linkIcon),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  // [DAMA(291) - OTHER FACTOR WIDGET]
  static otherFactorEligibilityRequirementDAMA(BuildContext context,
      SEDData stateEligibilityData, String occupationCode, String visaType) {
    int ageConcession = 0;
    String ageConcessionLink = "";
    int tSMIT = 0;
    String tsmitLink = "";
    int prPathway = 0;
    String prPathwayLink = "";
    int skillWorkExperience = 0;
    String skillWorkExperienceLink = "";
    if (stateEligibilityData.eligibilityReq != null &&
        stateEligibilityData.eligibilityReq!.isNotEmpty) {
      ageConcession =
          stateEligibilityData.eligibilityReq![0].ageConcession ?? 0;
      tSMIT = stateEligibilityData.eligibilityReq![0].tSMITConcession ?? 0;
      prPathway = stateEligibilityData.eligibilityReq![0].prPathway ?? 0;
      skillWorkExperience =
          stateEligibilityData.eligibilityReq![0].workExperienceConcession ?? 0;
    }

    // Source
    String source = "";
    if (stateEligibilityData.region != null &&
        stateEligibilityData.region![0].state != null &&
        stateEligibilityData.region![0].region != null) {
      source =
          "${StringHelper.basedOnDataInformation} ${stateEligibilityData.region![0].state} (${stateEligibilityData.region![0].region}) ${StringHelper.nominationAuthorityText}";
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColorStyle.backgroundVariant(context),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      ageConcession == 0
                          ? IconsSVG.icCrossMark
                          : IconsSVG.icCheckMark,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: InkWellWidget(
                        onTap: () {
                          if (ageConcessionLink.isNotEmpty) {
                            Utility.launchURL(ageConcessionLink);
                          }
                        },
                        child: Text.rich(
                          TextSpan(
                              text: StringHelper.ageConcessionAvailable,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context)),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: ageConcessionLink.isNotEmpty
                                      ? SvgPicture.asset(
                                          IconsSVG.linkIcon,
                                        )
                                      : Container(),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                    color: AppColorStyle.borderColors(context),
                    thickness: 0.5),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      tSMIT == 0
                          ? IconsSVG.icCrossMark
                          : IconsSVG.icCheckMark,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: InkWellWidget(
                        onTap: () {
                          if (tsmitLink.isNotEmpty) {
                            Utility.launchURL(tsmitLink);
                          }
                        },
                        child: Text.rich(
                          TextSpan(
                              text: StringHelper.tsmitConcessionsAvailable,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context)),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: tsmitLink.isNotEmpty
                                      ? SvgPicture.asset(
                                          IconsSVG.linkIcon,
                                        )
                                      : Container(),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                    color: AppColorStyle.borderColors(context),
                    thickness: 0.5),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      prPathway == 0
                          ? IconsSVG.icCrossMark
                          : IconsSVG.icCheckMark,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: InkWellWidget(
                        onTap: () {
                          if (prPathwayLink.isNotEmpty) {
                            Utility.launchURL(prPathwayLink);
                          }
                        },
                        child: Text.rich(
                          TextSpan(
                              text: StringHelper.prPathway,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context)),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: prPathwayLink.isNotEmpty
                                      ? SvgPicture.asset(
                                          IconsSVG.linkIcon,
                                        )
                                      : Container(),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                    color: AppColorStyle.borderColors(context),
                    thickness: 0.5),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      skillWorkExperience == 0
                          ? IconsSVG.icCrossMark
                          : IconsSVG.icCheckMark,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: InkWellWidget(
                        onTap: () {
                          if (skillWorkExperienceLink.isNotEmpty) {
                            Utility.launchURL(skillWorkExperienceLink);
                          }
                        },
                        child: Text.rich(
                          TextSpan(
                              text: StringHelper.skillExperienceConcession,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context)),
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: (skillWorkExperienceLink.isNotEmpty)
                                      ? SvgPicture.asset(
                                          IconsSVG.linkIcon,
                                        )
                                      : Container(),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        source.isNotEmpty
            ? Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                          text: StringHelper.source,
                          style: AppTextStyle.captionSemiBold(
                              context, AppColorStyle.text(context)),
                          children: [
                            TextSpan(
                                text: source,
                                style: AppTextStyle.captionRegular(
                                    context, AppColorStyle.text(context))),
                          ]),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  /// ---------- English TSS Table -------------------------------------

  static Row englishReqModifiedTSSTable(
      BuildContext context, List<EngReq> childRowData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTSSTableCells(context, childRowData),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: _buildTSSTableRows(context, childRowData),
          ),
        )
      ],
    );
  }

  static List<Widget> _buildTSSTableCells(
      BuildContext context, List<EngReq> childRowData) {
    return List.generate(
      childRowData.length,
      (index) => Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 4.8,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: index == 0
              ? const BorderRadius.only(topLeft: Radius.circular(10))
              : index == childRowData.length - 1
                  ? const BorderRadius.only(bottomLeft: Radius.circular(10))
                  : BorderRadius.zero,
          color: index != 0
              ? AppColorStyle.primary(context)
              : AppColorStyle.backgroundVariant1(context),
        ),
        child: Text(
          childRowData[index].examType ?? "",
          style: AppTextStyle.captionSemiBold(
              context,
              index != 0
                  ? AppColorStyle.textWhite(context)
                  : AppColorStyle.text(context)),
        ),
      ),
    );
  }

  static List<Widget> _buildTSSTableRows(
      BuildContext context, List<EngReq> childRowData) {
    return List.generate(
      childRowData.length - 1,
      (index) => Column(
        children: _buildTSSTableRowData(context, childRowData, index),
      ),
    );
  }

  static List<Widget> _buildTSSTableRowData(
      BuildContext context, List<EngReq> childRowData, int pos) {
    return List.generate(
      childRowData.length,
      (index) => Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 8.5,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: (index == 0 && pos == 4)
              ? const BorderRadius.only(topRight: Radius.circular(10))
              : (index == childRowData.length - 1 && pos == 4)
                  ? const BorderRadius.only(bottomRight: Radius.circular(10))
                  : BorderRadius.zero,
          color: index == 0
              ? AppColorStyle.backgroundVariant1(context)
              : index % 2 == 0
                  ? AppColorStyle.backgroundVariant1(context)
                  : AppColorStyle.background(context),
        ),
        child: tableTSSData(childRowData, index, pos, context),
      ),
    );
  }

  static tableTSSData(
      List<EngReq> childRowData, int index, int pos, BuildContext context) {
    if (pos == 0) {
      return childRowData[index].listening == "Listening"
          ? SvgPicture.asset(IconsSVG.listeningIcon)
          : Text(
              "${childRowData[index].listening}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    } else if (pos == 1) {
      return childRowData[index].reading == "Reading"
          ? SvgPicture.asset(IconsSVG.readingIcon)
          : Text(
              "${childRowData[index].reading}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    } else if (pos == 2) {
      return childRowData[index].writing == "Writing"
          ? SvgPicture.asset(IconsSVG.writingIcon)
          : Text(
              "${childRowData[index].writing}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    } else if (pos == 3) {
      return childRowData[index].speaking == "Speaking"
          ? SvgPicture.asset(IconsSVG.speakingIcon)
          : Text(
              "${childRowData[index].speaking}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    } else if (pos == 4) {
      return childRowData[index].overall == "Overall"
          ? SvgPicture.asset(IconsSVG.overallIcon)
          : Text(
              "${childRowData[index].overall}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    }
  }

  // ---------- ---------------- -------------------------------------

  // ---------- English Ens Table -------------------------------------
  static Row englishReqModifiedENSTable(
      BuildContext context, List<EngReqENS> childRowData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildENSTableCells(context, childRowData),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: _buildENSTableRows(context, childRowData),
          ),
        )
      ],
    );
  }

  static List<Widget> _buildENSTableCells(
      BuildContext context, List<EngReqENS> childRowData) {
    return List.generate(
      childRowData.length,
      (index) => Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 4.8,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: index == 0
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))
              : index == childRowData.length - 1
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))
                  : BorderRadius.zero,
          color: index != 0
              ? AppColorStyle.primary(context)
              : AppColorStyle.surfaceVariant(context),
        ),
        child: Text(
          childRowData[index].examType ?? "",
          style: AppTextStyle.captionSemiBold(
              context,
              index != 0
                  ? AppColorStyle.textWhite(context)
                  : AppColorStyle.text(context)),
        ),
      ),
    );
  }

  static List<Widget> _buildENSTableRows(
      BuildContext context, List<EngReqENS> childRowData) {
    return List.generate(
      childRowData.length - 1,
      (index) => Column(
        children: _buildENSTableRowData(context, childRowData, index),
      ),
    );
  }

  static List<Widget> _buildENSTableRowData(
      BuildContext context, List<EngReqENS> childRowData, int pos) {
    return List.generate(
      childRowData.length,
      (index) => Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 8.5,
        height: 50.0,
        color: index == 0
            ? AppColorStyle.surface(context)
            : index % 2 == 0
                ? AppColorStyle.background(context)
                : AppColorStyle.backgroundVariant(context),
        child: tableENSData(childRowData, index, pos, context),
      ),
    );
  }

  static tableENSData(
      List<EngReqENS> childRowData, int index, int pos, BuildContext context) {
    if (pos == 0) {
      return childRowData[index].listening == "Listening"
          ? SvgPicture.asset(IconsSVG.listeningIcon)
          : Text(
              "${childRowData[index].listening}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    } else if (pos == 1) {
      return childRowData[index].reading == "Reading"
          ? SvgPicture.asset(IconsSVG.readingIcon)
          : Text(
              "${childRowData[index].reading}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    } else if (pos == 2) {
      return childRowData[index].writing == "Writing"
          ? SvgPicture.asset(IconsSVG.writingIcon)
          : Text(
              "${childRowData[index].writing}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    } else if (pos == 3) {
      return childRowData[index].speaking == "Speaking"
          ? SvgPicture.asset(IconsSVG.speakingIcon)
          : Text(
              "${childRowData[index].speaking}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    } else if (pos == 4) {
      return childRowData[index].overall == "Overall"
          ? SvgPicture.asset(IconsSVG.overallIcon)
          : Text(
              "${childRowData[index].overall}",
              style: AppTextStyle.captionSemiBold(
                  context, AppColorStyle.text(context)),
            );
    }
  }

  static Widget dotWidget(bool bigSize, BuildContext context) {
    return Container(
      height: bigSize ? 10.0 : 6.0,
      width: bigSize ? 10.0 : 6.0,
      margin: const EdgeInsets.only(left: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: AppColorStyle.primary(context)),
    );
  }
}

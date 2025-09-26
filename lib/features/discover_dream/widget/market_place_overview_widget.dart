// ignore_for_file: must_be_immutable

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_list/model/employment_insights_australia.dart';
import 'package:occusearch/features/discover_dream/discover_dream_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_list/employee_insigns_au_shimmer.dart';

class MarketPlaceOverviewWidget extends StatelessWidget {
  MarketPlaceOverviewWidget(this.theme, {Key? key}) : super(key: key);

  bool theme;

  @override
  Widget build(BuildContext context) {
    final discoverDreamBloc = RxBlocProvider.of<DiscoverDreamBloc>(context);
    return StreamBuilder(
        stream: discoverDreamBloc.marketPlaceDataStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.hasData) {
            // int? empIndustryLength = discoverDreamBloc.projectedEmpGrowthByIndustryStream.value!.length;
            // int? largestEmpOccuLength = discoverDreamBloc.largestEmployeeOccuListStream.value!.length;
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.commonPadding),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Market view of",
                            style: AppTextStyle.titleSemiBold(
                              context,
                              AppColorStyle.text(context),
                            ),
                          ),
                          TextSpan(
                            text: " Australia",
                            style: AppTextStyle.titleSemiBold(
                              context,
                              AppColorStyle.primary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Constants.commonPadding),
                  //working age and employed
                  IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.commonPadding),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme ? ThemeConstant.blueVariantDark : ThemeConstant.blueVariant,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: SvgPicture.asset(
                                          IconsSVG.workingPopulationIcon,
                                          width: 24,
                                          height: 24,
                                        ),
                                      )),
                                  const SizedBox(height: 10.0),
                                  Text(StringHelper.workingAgePopulation,
                                      style: AppTextStyle.captionRegular(
                                          context,
                                          AppColorStyle.textDetail(context))),
                                  const SizedBox(height: 10.0),
                                  if (discoverDreamBloc.marketPlaceDataStream
                                      .value!.workingAgePopulation!.isNotEmpty)
                                    Text(
                                        Utility.getIntAmountFormat(
                                            amount: int.parse(discoverDreamBloc
                                                .marketPlaceDataStream
                                                .value!
                                                .workingAgePopulation
                                                .toString())),
                                        softWrap: true,
                                        style: AppTextStyle.titleSemiBold(
                                            context,
                                            AppColorStyle.text(context)))
                                ]),
                          ),
                          const SizedBox(width: 15.0),
                          VerticalDivider(
                            color: AppColorStyle.borderColors(context),
                            thickness: 1.0,
                          ),
                          const SizedBox(width: 15.0),
                          Expanded(
                            child: Center(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: theme ? ThemeConstant.yellowVariantDark : ThemeConstant.yellowVariant,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: SvgPicture.asset(
                                            IconsSVG.employedIcon,
                                            width: 24,
                                            height: 24,
                                          ),
                                        )),
                                    const SizedBox(height: 10.0),
                                    Text(StringHelper.employed,
                                        style: AppTextStyle.captionRegular(
                                            context,
                                            AppColorStyle.textDetail(context))),
                                    const SizedBox(height: 10.0),
                                    if (discoverDreamBloc.marketPlaceDataStream
                                        .value!.employed!.isNotEmpty)
                                      Text(
                                          Utility.getIntAmountFormat(
                                              amount: int.parse(
                                                  discoverDreamBloc
                                                      .marketPlaceDataStream
                                                      .value!
                                                      .employed!
                                                      .toString())),
                                          softWrap: true,
                                          style: AppTextStyle.titleSemiBold(
                                              context,
                                              AppColorStyle.text(context)))
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Constants.commonPadding),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.commonPadding),
                        child: Container(
                          color: AppColorStyle.borderColors(context),
                          height: 1.0,
                        ),
                      ),
                      Container(
                        color: AppColorStyle.background(context),
                        width: 50.0,
                        height: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: Constants.commonPadding),
                  //employee rate and unemployed rate
                  IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.commonPadding),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme ? ThemeConstant.greenVariantDark : ThemeConstant.greenVariant,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: SvgPicture.asset(
                                          IconsSVG.employedRateIcon,
                                          width: 24,
                                          height: 24,
                                        ),
                                      )),
                                  const SizedBox(height: 10.0),
                                  Text(StringHelper.employmentRate,
                                      style: AppTextStyle.captionRegular(
                                          context,
                                          AppColorStyle.textDetail(context))),
                                  const SizedBox(height: 10.0),
                                  if (discoverDreamBloc.marketPlaceDataStream
                                      .value!.employmentRate!.isNotEmpty)
                                    Text(
                                        ('${discoverDreamBloc.marketPlaceDataStream.value!.employmentRate!}%'),
                                        softWrap: true,
                                        style: AppTextStyle.titleSemiBold(
                                            context,
                                            AppColorStyle.text(context)))
                                ]),
                          ),
                          const SizedBox(width: 15.0),
                          VerticalDivider(
                            color: AppColorStyle.borderColors(context),
                            thickness: 1.0,
                          ),
                          const SizedBox(width: 15.0),
                          Expanded(
                            child: Center(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: theme ? ThemeConstant.pinkVariantDark : ThemeConstant.pinkVariant,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: SvgPicture.asset(
                                            IconsSVG.unemployedRateIcon,
                                            width: 24,
                                            height: 24,
                                          ),
                                        )),
                                    const SizedBox(height: 10.0),
                                    Text(StringHelper.unEmploymentRate,
                                        style: AppTextStyle.captionRegular(
                                            context,
                                            AppColorStyle.textDetail(context))),
                                    const SizedBox(height: 10.0),
                                    Text(
                                        ('${discoverDreamBloc.marketPlaceDataStream.value!.unemploymentRate!}%'),
                                        softWrap: true,
                                        style: AppTextStyle.titleSemiBold(
                                            context,
                                            AppColorStyle.text(context)))
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                      height: 5.0,
                      color: AppColorStyle.backgroundVariant(context)),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.commonPadding),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Projected Employment growth by Industry in",
                            style: AppTextStyle.subTitleSemiBold(
                              context,
                              AppColorStyle.text(context),
                            ),
                          ),
                          TextSpan(
                            text: " 5 years",
                            style: AppTextStyle.subTitleSemiBold(
                              context,
                              AppColorStyle.primary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: discoverDreamBloc
                            .projectedEmpGrowthByIndustryStream.value!.length,
                        itemBuilder: (context, index) {
                          final ProjectedEmpGrowthByIndustry universityList =
                              discoverDreamBloc
                                  .projectedEmpGrowthByIndustryStream
                                  .value![index];
                          return Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.all(15.0),
                            margin: EdgeInsets.only(
                                left: Constants.commonPadding,
                                right: index ==
                                        discoverDreamBloc
                                                .projectedEmpGrowthByIndustryStream
                                                .value!
                                                .length -
                                            1
                                    ? Constants.commonPadding
                                    : 0.0),
                            decoration: BoxDecoration(
                              color: universityList.randomColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  universityList.label!,
                                  maxLines: 2,
                                  style: AppTextStyle.detailsRegular(
                                      context, AppColorStyle.textDetail(context)),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  Utility.getIntAmountFormat(
                                      amount: int.parse(
                                          universityList.value ?? '0')),
                                  style: AppTextStyle.titleSemiBold(
                                      context, AppColorStyle.text(context)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  const SizedBox(height: Constants.commonPadding),
                  Container(
                      height: 5.0,
                      color: AppColorStyle.backgroundVariant(context)),
                  const SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.commonPadding),
                    child: Text(StringHelper.largestEmployingOccupation,
                        softWrap: true,
                        style: AppTextStyle.subTitleSemiBold(
                            context, AppColorStyle.text(context))),
                  ),
                  const SizedBox(height: 15.0),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: discoverDreamBloc
                            .largestEmployeeOccuListStream.value!.length,
                        itemBuilder: (context, index) {
                          final LargestEmployingOccupations universityList =
                              discoverDreamBloc
                                  .largestEmployeeOccuListStream.value![index];
                          return Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.all(15.0),
                            margin: EdgeInsets.only(
                                left: Constants.commonPadding,
                                right: index ==
                                        discoverDreamBloc
                                                .largestEmployeeOccuListStream
                                                .value!
                                                .length -
                                            1
                                    ? Constants.commonPadding
                                    : 0.0),
                            decoration: BoxDecoration(
                              color:universityList.randomColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  universityList.occupationName!,
                                  maxLines: 2,
                                  style: AppTextStyle.detailsRegular(
                                      context, AppColorStyle.textDetail(context)),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  Utility.getIntAmountFormat(
                                      amount: int.parse(
                                          universityList.employed ?? '0')),
                                  style: AppTextStyle.titleSemiBold(
                                      context, AppColorStyle.text(context)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            );
          }else if (discoverDreamBloc.isLoadingSubject.value) {
            return const EmployeeInsightsForAuShimmer();
          }else {
            return Container();
          }
        });
  }
}

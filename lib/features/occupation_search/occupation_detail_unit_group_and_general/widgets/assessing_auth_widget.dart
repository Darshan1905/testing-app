import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_accessing_auth_details/so_accessing_auth_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_accessing_auth_details/so_accessing_auth_detail_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_accessing_auth_details/so_accessing_authority_shimmer.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_accessing_auth_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_shimmer.dart';

//Assessing Authority Widget
class AssessingAuthorityWidget extends StatelessWidget {
  const AssessingAuthorityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchOccupationBloc =
        RxBlocProvider.of<OccupationDetailBloc>(context);
    final soAccessingAuthDetailBloc =
        RxBlocProvider.of<SoAccessingAuthDetailBloc>(context);

    return (searchOccupationBloc.isLoadingSubject.value)
        ? SoUnitGroupAndGeneralShimmer.otherInformationShimmer(context)
        : StreamBuilder<List<AccessingAuthModel>>(
            stream: soAccessingAuthDetailBloc.accessingAuthModelStream,
            builder: (context, snapshot) {
              List<AccessingAuthModel> accessingAuthList = snapshot.data ?? [];
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColorStyle.background(context),
                  ),
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 10, left: 20, right: 20),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        StringHelper.occupationMainAssessingAuthority,
                        style: AppTextStyle.titleSemiBold(
                            context, AppColorStyle.text(context)),
                      ),
                      ListView.builder(
                        itemCount: accessingAuthList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 20),
                        itemBuilder: (context, index) {
                          AccessingAuthModel accessingAuthData =
                              accessingAuthList[index];
                          return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color:
                                      AppColorStyle.backgroundVariant(context),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (soAccessingAuthDetailBloc.loading)
                                      ? SoAccessingAuthorityShimmer
                                          .titleShimmer(context)
                                      : Text(
                                          accessingAuthData.fullName ?? "",
                                          style: AppTextStyle.detailsSemiBold(
                                              context,
                                              AppColorStyle.primary(context)),
                                        ),
                                  // Applicable Fees
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 20),
                                    child: Text(
                                      StringHelper.applicableFees,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.captionRegular(
                                          context,
                                          AppColorStyle.textDetail(context)),
                                    ),
                                  ),
                                  (soAccessingAuthDetailBloc.loading)
                                      ? SoAccessingAuthorityShimmer
                                          .titleShimmer(context)
                                      : Text(
                                          accessingAuthData.applicableFees ??
                                              "",
                                          softWrap: true,
                                          style: AppTextStyle.captionSemiBold(
                                              context,
                                              AppColorStyle.text(context)),
                                        ),
                                  // Processing Time
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Text(
                                      StringHelper.processingTimeText,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.captionRegular(
                                          context,
                                          AppColorStyle.textDetail(context)),
                                    ),
                                  ),
                                  (soAccessingAuthDetailBloc.loading)
                                      ? SoAccessingAuthorityShimmer
                                          .titleShimmer(context)
                                      : Text(
                                          accessingAuthData.processingTime ??
                                              "",
                                          style: AppTextStyle.captionSemiBold(
                                              context,
                                              AppColorStyle.text(context)),
                                        ),
                                  // Mode Of Application
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Text(
                                      StringHelper.modeOfApplication,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.captionRegular(
                                          context,
                                          AppColorStyle.textDetail(context)),
                                    ),
                                  ),
                                  (soAccessingAuthDetailBloc.loading)
                                      ? SoAccessingAuthorityShimmer
                                          .titleShimmer(context)
                                      : Text(
                                          accessingAuthData.modeOfApplication ??
                                              "",
                                          style: AppTextStyle.captionSemiBold(
                                              context,
                                              AppColorStyle.text(context)),
                                        ),
                                  const SizedBox(
                                    height: 40.0,
                                  ),
                                  (soAccessingAuthDetailBloc.loading)
                                      ? SoAccessingAuthorityShimmer
                                          .feesLinkShimmer(context)
                                      : Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  IconsSVG.dollarIcon,
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  StringHelper.feesLink,
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyle
                                                      .detailsMedium(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)),
                                                ),
                                                const Spacer(),
                                                InkWellWidget(
                                                    child: SvgPicture.asset(
                                                      IconsSVG.linkIcon,
                                                    ),
                                                    onTap: () {
                                                      Utility.launchURL(
                                                          accessingAuthData
                                                                  .feesLink ??
                                                              "");
                                                    }),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Divider(
                                                thickness: 0.5,
                                                color: AppColorStyle
                                                    .surfaceVariant(context),
                                              ),
                                            )
                                          ],
                                        ),
                                  (soAccessingAuthDetailBloc.loading)
                                      ? SoAccessingAuthorityShimmer
                                          .feesLinkShimmer(context)
                                      : Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  IconsSVG.guidelineIcon,
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  StringHelper.guideline,
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyle
                                                      .detailsMedium(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)),
                                                ),
                                                const Spacer(),
                                                InkWellWidget(
                                                    child: SvgPicture.asset(
                                                      IconsSVG.linkIcon,
                                                    ),
                                                    onTap: () {
                                                      Utility.launchURL(
                                                          accessingAuthData
                                                                  .guideline ??
                                                              "");
                                                    }),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Divider(
                                                thickness: 0.5,
                                                color: AppColorStyle
                                                    .surfaceVariant(context),
                                              ),
                                            )
                                          ],
                                        ),

                                  (soAccessingAuthDetailBloc.loading)
                                      ? SoAccessingAuthorityShimmer
                                          .feesLinkShimmer(context)
                                      : Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  IconsSVG.icChecklist,
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  StringHelper.checkList,
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyle
                                                      .detailsMedium(
                                                          context,
                                                          AppColorStyle.text(
                                                              context)),
                                                ),
                                                const Spacer(),
                                                InkWellWidget(
                                                    child: SvgPicture.asset(
                                                      IconsSVG.linkIcon,
                                                    ),
                                                    onTap: () {
                                                      Utility.launchURL(
                                                          accessingAuthData
                                                                  .checkList ??
                                                              "");
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                  accessingAuthData.englishTest != null &&
                                          accessingAuthData
                                              .englishTest!.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50, bottom: 10),
                                              child: Text(
                                                StringHelper.engTest,
                                                style:
                                                    AppTextStyle.captionMedium(
                                                        context,
                                                        AppColorStyle
                                                            .textDetail(
                                                                context)),
                                              ),
                                            ),
                                            SoAccessingAuthDetailWidget
                                                .englishTestModifiedTableWidget(
                                                    context, accessingAuthData)
                                          ],
                                        )
                                      : Container()
                                ],
                              ));
                        },
                      )
                    ],
                  ),
                );
              }
              return const SizedBox();
            });
  }
}

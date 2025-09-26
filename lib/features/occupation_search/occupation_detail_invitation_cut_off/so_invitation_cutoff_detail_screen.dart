import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';

import 'so_invitation_cutoff_detail_bloc.dart';
import 'so_invitation_cutoff_detail_widget.dart';

class SoInvitationCutOffDetailScreen extends BaseApp {
  const SoInvitationCutOffDetailScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _SoInvitationCutOffDetailScreenState();
}

class _SoInvitationCutOffDetailScreenState extends BaseState {
  PreferredSizeWidget? appBar() => null;

  SoInvitationCutOffDetailBloc soInvitationCutOffDetailBloc =
      SoInvitationCutOffDetailBloc();
  OccupationDetailBloc searchOccupationBloc = OccupationDetailBloc();

  @override
  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  initData() async {
    final paramAgrs = ModalRoute.of(context)?.settings.arguments as Map;
    soInvitationCutOffDetailBloc.setType = paramAgrs["type"];
    printLog(paramAgrs);
    soInvitationCutOffDetailBloc.callInvitationCutOffDetail(
        paramAgrs["type"], paramAgrs["ugCode"]);
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider(
        create: (_) => soInvitationCutOffDetailBloc,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: AppColorStyle.backgroundVariant(context),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.only(
                    top: 30, left: 30, right: 30, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SoInvitationCutOffDetailWidget.headerWidget(
                        context, searchOccupationBloc),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWellWidget(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'Subclass ${soInvitationCutOffDetailBloc.type}',
                                    style: AppTextStyle.detailsSemiBold(
                                        context,
                                        AppColorStyle.primary(context))),
                                WidgetSpan(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 3),
                                  child: SvgPicture.asset(
                                    IconsSVG.linkIcon,
                                    width: 15.0,
                                    height: 15.0,
                                    colorFilter: ColorFilter.mode(
                                      AppColorStyle.primary(context),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )),
                              ],
                            )),
                      ),
                      onTap: () {
                        Utility.launchURL(
                            "https://immi.homeaffairs.gov.au/visas/working-in-australia/skillselect/invitation-rounds");
                      },
                    ),
                    Container(
                      width: double.maxFinite,
                      constraints: const BoxConstraints(minHeight: 350.0),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: AppColorStyle.background(context),
                          border: Border.all(
                              color: AppColorStyle.grayColor(context)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: SoInvitationCutOffDetailWidget
                            .invitationCutOffHeaderWidget(
                                context,
                                soInvitationCutOffDetailBloc
                                    .invitationCutOffsList),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Note : ',
                                style: AppTextStyle.captionBold(
                                    context, AppColorStyle.text(context)),
                              ),
                              TextSpan(
                                  text:
                                      'There were no invitations issued for some occupation in the invitation round conducted in May and June For more ',
                                  style: AppTextStyle.captionRegular(
                                      context, AppColorStyle.text(context))),
                              WidgetSpan(
                                  child: InkWellWidget(
                                child: Text(StringHelper.clickHere,
                                    style: AppTextStyle.captionMedium(context,
                                        AppColorStyle.primary(context))),
                                onTap: () {
                                  Utility.launchURL(
                                      "https://immi.homeaffairs.gov.au/visas/working-in-australia/skillselect/invitation-rounds");
                                },
                              ))
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Source : ',
                            style: AppTextStyle.captionBold(
                                context, AppColorStyle.text(context)),
                          ),
                          Expanded(
                            child: Text(
                              'Based on data available on DHA website.',
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    soInvitationCutOffDetailBloc.clearProviderData();
  }
}

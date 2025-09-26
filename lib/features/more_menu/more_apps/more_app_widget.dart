import 'dart:io';

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/more_menu/model/more_app_model.dart';
import 'package:occusearch/features/more_menu/more_apps/more_apps_shimmer.dart';
import 'package:occusearch/features/more_menu/more_menu_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MoreAppWidget extends StatelessWidget {
  const MoreAppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moreMenuBloc = RxBlocProvider.of<MoreMenuBloc>(context);

    return Expanded(
      child: StreamBuilder(
          stream: moreMenuBloc.getMoreAppListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return MoreAppItem(item: item);
                  });
            } else {
              return const MoreAppListShimmer();
            }
          }),
    );
  }
}

class MoreAppItem extends StatelessWidget {
  final ApplicationList item;

  const MoreAppItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      decoration: BoxDecoration(color: AppColorStyle.background(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWellWidget(
            onTap: () async {
              //firebase tracking
              FirebaseAnalyticLog.shared.eventTracking(
                  screenName: RouteName.home,
                  actionEvent: item.appTitle ?? "",
                  sectionName: FBSectionEvent.fbSectionMoreApps);

              if (Platform.isIOS) {
                // for iOS phone only
                if (await canLaunchUrlString(item.iPhoneURL!)) {
                  await launchUrlString(
                      item.iPhoneURL! /*, forceSafariVC: false*/,
                      mode: LaunchMode.externalApplication);
                }
              } else if (Platform.isAndroid) {
                // android , web
                if (await canLaunchUrlString(item.androidUrl!)) {
                  await launchUrlString(item.androidUrl!,
                      mode: LaunchMode.externalApplication);
                }
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: FittedBox(
                          child: Card(
                            shadowColor: AppColorStyle.primaryVariant1(context),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            child: SizedBox(
                              height: 70,
                              width: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Utility.imageCache(
                                    item.images ?? '', context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "${item.appTitle}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.detailsSemiBold(
                                    context, AppColorStyle.text(context)),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "${item.appDiscription}",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.captionRegular(
                                    context, AppColorStyle.text(context)),
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "  Let's join",
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.captionSemiBold(
                    context, AppColorStyle.primaryVariant1(context)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                height: 15.0,
                width: 2,
                color: AppColorStyle.text(context),
              ),
              Expanded(
                child: Wrap(children: <Widget>[
                  // facebook
                  (item.getFacebookURL != null && item.getFacebookURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialFacebook,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getFacebookURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionFacebook);

                            await launchUrlString(item.getFacebookURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // instagram
                  (item.getInstagramURL != null && item.getInstagramURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: Image.asset(
                              IconsWEBP.socialInstagram,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getInstagramURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionInstagram);

                            await launchUrlString(item.getInstagramURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // youtube
                  (item.getYoutubeURL != null && item.getYoutubeURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialYoutube,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getYoutubeURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionYoutube);

                            await launchUrlString(item.getYoutubeURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // linkedin
                  (item.getLinkedinURL != null && item.getLinkedinURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialLinkedin,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getLinkedinURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionLinkedin);

                            await launchUrlString(item.getLinkedinURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // twitter
                  (item.getTwitterURL != null && item.getTwitterURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialTwitter,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getTwitterURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionTwitter);

                            await launchUrlString(item.getTwitterURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // telegram
                  (item.getTelegramURL != null && item.getTelegramURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialTelegram,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getTelegramURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionTelegram);

                            await launchUrlString(item.getTelegramURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MoreAppWidgets {
  static Widget moreAppItem(BuildContext context, ApplicationList item) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      decoration: BoxDecoration(
          color: AppColorStyle.backgroundVariant(context),
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWellWidget(
            onTap: () async {
              //firebase tracking
              FirebaseAnalyticLog.shared.eventTracking(
                  screenName: RouteName.home,
                  actionEvent: item.appTitle ?? "",
                  sectionName: FBSectionEvent.fbSectionMoreApps);

              if (Platform.isIOS) {
                // for iOS phone only
                if (await canLaunchUrlString(item.iPhoneURL!)) {
                  await launchUrlString(
                      item.iPhoneURL! /*, forceSafariVC: false*/,
                      mode: LaunchMode.externalApplication);
                }
              } else if (Platform.isAndroid) {
                // android , web
                if (await canLaunchUrlString(item.androidUrl!)) {
                  await launchUrlString(item.androidUrl!,
                      mode: LaunchMode.externalApplication);
                }
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.appTitle}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.detailsSemiBold(
                      context, AppColorStyle.text(context)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: FittedBox(
                          child: Card(
                            shadowColor: AppColorStyle.primaryVariant1(context),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            child: SizedBox(
                              height: 70,
                              width: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child:
                                    // Image(image:
                                    Utility.imageCache(
                                        item.images ?? '', context),
                                // fit: BoxFit.fill,),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "${item.appDiscription}",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.captionRegular(
                                    context, AppColorStyle.text(context)),
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "  Let's join",
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.captionSemiBold(
                    context, AppColorStyle.primary(context)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                height: 15.0,
                width: 2,
                color: AppColorStyle.text(context),
              ),
              Expanded(
                child: Wrap(children: <Widget>[
                  // facebook
                  (item.getFacebookURL != null && item.getFacebookURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialFacebook,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getFacebookURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionFacebook);

                            await launchUrlString(item.getFacebookURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // instagram
                  (item.getInstagramURL != null && item.getInstagramURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: Image.asset(
                              IconsWEBP.socialInstagram,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getInstagramURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionInstagram);

                            await launchUrlString(item.getInstagramURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // youtube
                  (item.getYoutubeURL != null && item.getYoutubeURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialYoutube,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getYoutubeURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionYoutube);

                            await launchUrlString(item.getYoutubeURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // linkedin
                  (item.getLinkedinURL != null && item.getLinkedinURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialLinkedin,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getLinkedinURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionLinkedin);

                            await launchUrlString(item.getLinkedinURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // twitter
                  (item.getTwitterURL != null && item.getTwitterURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialTwitter,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getTwitterURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionTwitter);

                            await launchUrlString(item.getTwitterURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                  // telegram
                  (item.getTelegramURL != null && item.getTelegramURL != "")
                      ? InkWellWidget(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: SvgPicture.asset(
                              IconsSVG.icSocialTelegram,
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          onTap: () async {
                            //firebase tracking
                            FirebaseAnalyticLog.shared.eventTracking(
                                screenName: RouteName.home,
                                actionEvent: item.getTelegramURL ?? "",
                                sectionName:
                                    FBSectionEvent.fbSectionMoreApps,
                                subSectionName: FBSubSectionEvent
                                    .fbSubSectionDashboardMoreAppSectionTelegram);

                            await launchUrlString(item.getTelegramURL ?? "",
                                mode: LaunchMode.externalApplication);
                          })
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}

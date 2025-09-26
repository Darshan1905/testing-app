import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/dashboard/recent_updates/generate_pdf_for_recent_updates.dart';
import 'package:occusearch/features/dashboard/recent_updates/model/recent_update_model.dart';
import 'package:occusearch/features/dashboard/recent_updates/recent_update_list_shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecentUpdateWidget {
  static Widget updateWidgetBlock(BuildContext context, int index,
      Recordset data, int length, AnimationController controller) {
    late final dateFormat = DateFormat('dd MMMM yyyy');
    late final utcFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final date = utcFormat.parse(data.createdDate ?? '');
    final latestUpdateDate = dateFormat.format(date);

    return InkWellWidget(
      onTap: () {
        FirebaseAnalyticLog.shared.eventTracking(
            screenName: RouteName.recentUpdateScreen,
            actionEvent: data.title!,
            sectionName: FBSectionEvent.fbSectionLatestUpdate);
        showRecentUpdateInSheet(context, data, 50, controller);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: index == 0 ? 10 : 20.0, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  data.title == null ? "" : data.title ?? "",
                  style: AppTextStyle.detailsSemiBold(
                    context,
                    AppColorStyle.text(context),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  data.subTitle == null ? "" : data.subTitle ?? "",
                  style: AppTextStyle.detailsRegular(
                      context, AppColorStyle.textDetail(context)),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    SvgPicture.asset(
                      IconsSVG.icCalenderRecentUpdate,
                      height: 15,
                      width: 15,
                      colorFilter: ColorFilter.mode(
                        AppColorStyle.primary(context),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 7.0),
                    Text(
                      data.createdDate == null ? "" : latestUpdateDate,
                      style: AppTextStyle.captionRegular(
                        context,
                        AppColorStyle.primaryVariant1(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: AppColorStyle.borderColors(context), thickness: 0.5),
          SizedBox(
            height: index == (length - 1) ? 120 : 0,
            child: RecentUpdateListShimmer(1),
          )
        ],
      ),
    );
  }

  static showRecentUpdateInSheet(BuildContext context, Recordset data,
      double topMargin, AnimationController animationController) {
    //WidgetsToImageController controller = WidgetsToImageController();
    late final dateFormat = DateFormat('dd MMMM yyyy');
    late final utcFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final date = utcFormat.parse(data.createdDate ?? '');
    final latestUpdateDate = dateFormat.format(date);

    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      context: context,
      barrierColor: AppColorStyle.backgroundVariant(context),
      transitionAnimationController: animationController,
      backgroundColor: AppColorStyle.backgroundVariant(context),
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top),
      builder: (context) {
        bool loading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, left: 20.0, top: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWellWidget(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          IconsSVG.arrowBack,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.text(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        StringHelper.updateDetails,
                        style: AppTextStyle.titleBold(
                          context,
                          AppColorStyle.text(context),
                        ),
                      ),
                      const Spacer(),
                      loading
                          ? SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColorStyle.primary(context),
                                  strokeWidth: 1.5,
                                ),
                              ),
                            )
                          : InkWellWidget(
                              onTap: () async {
                                if (NetworkController.isInternetConnected ==
                                    false) {
                                  Toast.show(context,
                                      message: StringHelper.internetConnection,
                                      type: Toast.toastError);
                                  return;
                                }

                                try {
                                  setState(() {
                                    loading = true;
                                  });
                                  // CONVERT [HTML] TO [PDF]
                                  final String recentUpdatePdf =
                                      await createDocument(
                                          data.title ?? "",
                                          data.subTitle ?? '',
                                          data.createdDate,
                                          data.comment ?? '');

                                  setState(() {
                                    loading = false;
                                  });
                                  final result = await Share.shareXFiles(
                                      [XFile(recentUpdatePdf)],
                                      text: Constants.recentUpdatePDFName);

                                  if (result.status ==
                                      ShareResultStatus.success) {
                                    printLog(
                                        'Recent update pdf path: $recentUpdatePdf');
                                  }
                                  /*await Printing.sharePdf(
                                    bytes: await generatePDFForRecentUpdates(
                                        data.title,
                                        data.subTitle,
                                        data.comment,
                                        data.recentChangesId),
                                    filename: Constants.recentUpdatePDFName,
                                  );*/
                                } catch (e) {
                                  printLog(e);
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                              child: SvgPicture.asset(
                                IconsSVG.shareIcon,
                                height: 24.0,
                                width: 24.0,
                                colorFilter: ColorFilter.mode(
                                  AppColorStyle.primaryVariant1(context),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Divider(
                  thickness: 0.5,
                  color: AppColorStyle.borderColors(context),
                  height: 0.0,
                ),
                Container(
                  color: AppColorStyle.primary(context),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title ?? "",
                        maxLines: 2,
                        style: AppTextStyle.subTitleSemiBold(
                          context,
                          AppColorStyle.textWhite(context),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        data.subTitle ?? "",
                        maxLines: 2,
                        style: AppTextStyle.detailsMedium(
                          context,
                          AppColorStyle.whiteTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          SvgPicture.asset(
                            IconsSVG.icCalenderRecentUpdate,
                            height: 14,
                            width: 14,
                            colorFilter: ColorFilter.mode(
                              AppColorStyle.whiteTextColor(context),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            latestUpdateDate,
                            maxLines: 2,
                            style: AppTextStyle.captionRegular(
                              context,
                              AppColorStyle.whiteTextColor(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColorStyle.backgroundVariant(context),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10.0),
                            HtmlWidget(
                              "${data.comment}",
                              customStylesBuilder: (element) {
                                if (element.localName == 'table' ||
                                    element.localName == 'Table' ||
                                    element.localName == 'TABLE') {
                                  return {
                                    'border': '1px solid black',
                                    'border-collapse': 'collapse'
                                  };
                                }
                                if (element.localName == 'td' ||
                                    element.localName == 'Td' ||
                                    element.localName == 'TD') {
                                  return {
                                    'border': '1px solid black',
                                    'border-collapse': 'collapse'
                                  };
                                }
                                if (element.localName == 'th' ||
                                    element.localName == 'Th' ||
                                    element.localName == 'TH') {
                                  return {
                                    'border': '1px solid black',
                                    'border-collapse': 'collapse'
                                  };
                                }
                                return null;
                              },
                              textStyle: AppTextStyle.detailsRegular(
                                context,
                                AppColorStyle.text(context),
                              ),
                              onTapUrl: (url) async => openUrl(url),
                              renderMode: RenderMode.column,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /*static showSocialMediaPlatformForShare(BuildContext context,
      AnimationController animationController, Recordset data) {
    showModalBottomSheet(
      isScrollControlled: false,
      enableDrag: true,
      useSafeArea: true,
      context: context,
      barrierColor: Colors.transparent,
      transitionAnimationController: animationController,
      backgroundColor: AppColorStyle.background(context),
      */ /*constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top),*/ /*
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(Constants.commonPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    StringHelper.share,
                    style: AppTextStyle.titleBold(
                      context,
                      AppColorStyle.text(context),
                    ),
                  ),
                  InkWellWidget(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      IconsSVG.roundedCloseIcon,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    InkWellWidget(
                      onTap: () {
                        String package = "com.instagram.android";

                        PlatformChannels.shareContentWithDynamicLink(
                            data.bannerImage.toString(), package);
                      },
                      child: Image.asset(
                        IconsWEBP.socialInstagram,
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWellWidget(
                      onTap: () {
                        String package = "com.facebook.katana";
                        PlatformChannels.shareContentWithDynamicLink(
                            data.bannerImage.toString(), package);
                      },
                      child: SvgPicture.asset(
                        IconsSVG.icSocialFacebook,
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWellWidget(
                      onTap: () {
                        String package = "com.linkedin.android";
                        PlatformChannels.shareContentWithDynamicLink(
                            data.bannerImage.toString(), package);
                      },
                      child: SvgPicture.asset(
                        IconsSVG.icSocialLinkedin,
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWellWidget(
                      onTap: () {
                        String package = "org.telegram.messenger";

                        PlatformChannels.shareContentWithDynamicLink(
                            data.bannerImage.toString(), package);
                      },
                      child: SvgPicture.asset(
                        IconsSVG.icSocialTelegram,
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWellWidget(
                      onTap: () {
                        Utility.shareRecentUpdatePostLinkWithImageURl(
                            title: data.title.toString(),
                            subTitle: data.subTitle.toString(),
                            imageUrl: data.bannerImage.toString(),
                            recentChangesId: data.recentChangesId ?? "0");
                        //String package = "com.whatsapp";
                        //PlatformChannels.shareContentWithDynamicLink(data.bannerImage.toString(), package);
                      },
                      child: SvgPicture.asset(
                        IconsSVG.icSocialWhatsapp,
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }*/

  static Future<bool> openUrl(String? url) async {
    if (url != null) {
      final encodedUrl = Uri.encodeFull(url);
      if (await canLaunchUrlString(encodedUrl)) {
        await launchUrlString(encodedUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $encodedUrl';
      }
    }
    return true;
  }
}

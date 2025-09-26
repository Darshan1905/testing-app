// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/dashboard/recent_updates/widget_to_image.dart';

// Widget to convert into image for sharing post...
/*
RecentUpdateShareWidget(
title: data.title ?? "",
subtitle: data.subTitle ?? "",
controller: controller,
createdDate: data.createdDate ?? "",
),
*/

class RecentUpdateShareWidget extends StatelessWidget {
  final WidgetsToImageController controller;
  final String title;
  final String subtitle;
  final String createdDate;

  const RecentUpdateShareWidget(
      {Key? key,
      required this.controller,
      required this.title,
      required this.subtitle,
      required this.createdDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String recentDate = createdDate; //date published on
    try {
      late final dateFormat = DateFormat('dd MMMM, yyyy');
      late final utcFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final date = utcFormat.parse(createdDate);
      recentDate = dateFormat.format(date);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: WidgetsToImage(
        controller: controller,
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                color: AppColorStyle.primary(context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      title,
                      style: AppTextStyle.detailsSemiBold(
                        context,
                        AppColorStyle.textWhite(context),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    Text(
                      subtitle,
                      style: AppTextStyle.detailsMedium(
                        context,
                        AppColorStyle.text(context),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "Published on $recentDate",
                      style: AppTextStyle.captionRegular(
                        context,
                        AppColorStyle.textDetail(context),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 0.0, bottom: 10.0),
                child: Divider(
                  color: AppColorStyle.primaryText(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconsSVG.icPlayStoreAppStoreLogo,
                      width: 150,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          IconsPNG.pdfOccusearchHeaderLogo,
                          fit: BoxFit.contain,
                          scale: 1,
                          height: 30,
                          width: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text("|",
                              style: AppTextStyle.detailsLight(
                                context,
                                AppColorStyle.textDetail(context),
                              )),
                        ),
                        Image.asset(
                          IconsPNG.icAussizzLogo,
                          fit: BoxFit.contain,
                          scale: 1,
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

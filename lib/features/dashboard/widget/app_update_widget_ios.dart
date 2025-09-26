import 'dart:io';

import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';

Future appUpdateAlertWidgetiOS(BuildContext context, String message) {
  return WidgetHelper.alertDialogWidget(
    context: context,
    title: StringHelper.newVersionAvailable,
    message: message,
    positiveButtonTitle: StringHelper.updateNow,
    negativeButtonTitle: StringHelper.ratingUsRemindMeLater,
    isFromAppUpdate: true,
    onPositiveButtonClick: () async {
      if (Platform.isIOS) {
        Utility.launchURL(Constants.appStoreLink);
      } else if (Platform.isAndroid) {
        Utility.launchURL(Constants.playStoreLink);
      }
    },
  );

  /*showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height < 670
              ? MediaQuery.of(context).size.height / 2
              : MediaQuery.of(context).size.height / 2.5),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                IconsSVG.occusearchLogo,
                fit: BoxFit.fill,
                width: 80,
                height: 80,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                StringHelper.newVersionAvailable,
                style: AppTextStyle.subTitleMedium(
                    context, AppColorStyle.text(context)),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Divider(
                  color: AppColorStyle.disableVariant(context), thickness: 0.5),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                message,
                style: AppTextStyle.captionRegular(
                    context, AppColorStyle.text(context)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColorStyle.primary(context),
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWellWidget(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          child: Text(
                            StringHelper.updateNow,
                            style: AppTextStyle.detailsSemiBold(
                                context, AppColorStyle.textWhite(context)),
                          ),
                        ),
                        onTap: () {
                          if (Platform.isIOS) {
                            Utility.launchURL(Constants.appStoreLink);
                          } else if (Platform.isAndroid) {
                            Utility.launchURL(Constants.playStoreLink);
                          }
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColorStyle.backgroundVariant(context),
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWellWidget(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          child: Text(
                            StringHelper.remindMeLater,
                            style: AppTextStyle.detailsSemiBold(
                                context, AppColorStyle.textDetail(context)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });*/
}

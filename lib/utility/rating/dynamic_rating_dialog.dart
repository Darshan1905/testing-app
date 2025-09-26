import 'dart:io';

import 'package:occusearch/common_widgets/widget_helper.dart';
import 'package:occusearch/constants/constants.dart';

class DynamicRatingDialog {
  static showRatingAppDialog({required BuildContext context}) {
    WidgetHelper.alertDialogWidget(
      context: context,
      title: StringHelper.likeUsingApp,
      message: StringHelper.recommendUsToOthers,
      positiveButtonTitle: StringHelper.rateUs,
      negativeButtonTitle: StringHelper.ratingUsRemindMeLater,
      onPositiveButtonClick: () async {
        // FIREBASE EVENT LOG
        FirebaseAnalyticLog.shared.eventTracking(
            screenName: RouteName.home,
            actionEvent: FBActionEvent.fbActionRateUs,
            sectionName: FBSectionEvent.fbSectionRateReview);
        if (Platform.isIOS) {
          Utility.launchURL(Constants.appStoreLink);
        } else if (Platform.isAndroid) {
          Utility.launchURL(Constants.playStoreLink);
        }
      },
    );
  }
}

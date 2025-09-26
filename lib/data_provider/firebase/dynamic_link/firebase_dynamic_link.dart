import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';

import 'firebase_dynamic_link_constants.dart';

class FirebaseDynamicLink {
  static final FirebaseDynamicLink shared = FirebaseDynamicLink._internal();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  Map<String, dynamic>? action;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  factory FirebaseDynamicLink() {
    return shared;
  }

  FirebaseDynamicLink._internal();

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      final Uri deepLink = dynamicLinkData.link;
      // WHEN APPLICATION OPEN
      if (deepLink.queryParameters.isNotEmpty) {
        var param = deepLink.queryParameters;
        // debugPrint("%%%%%%%%%%");
        // debugPrint(param['recent_id'] ?? "");
        // debugPrint("%%%%%%%%%%");

        // Recent updates sharing link...
        if (param['recent_id'] != null && param['recent_id']!.isNotEmpty) {
          UserInfoData userInfo =
              await SharedPreferenceController.getUserData();
          if (userInfo.name != null && userInfo.name!.isNotEmpty) {
            //todo:check current path is recent update or not
            String currentPath = GoRouterConfig.router.location;
            if (currentPath == "\/${RouteName.recentUpdateScreen}") {
              Future.delayed(const Duration(seconds: 0), () {
                GoRoutesPage.go(
                    mode: NavigatorMode.replace,
                    moveTo: RouteName.recentUpdateScreen,
                    param: param['recent_id']);
              });
            } else {
              Future.delayed(const Duration(seconds: 1), () {
                GoRoutesPage.go(
                    mode: NavigatorMode.push,
                    moveTo: RouteName.recentUpdateScreen,
                    param: param['recent_id']);
              });
            }
          }
        }

        /*// Occupation sharing link...
        if (param['oc'] != null && param['oc']!.isNotEmpty) {
          UserInfoData userInfo =
              await SharedPreferenceController.getUserData();
          if (userInfo.name != null && userInfo.name!.isNotEmpty) {
            // print("^^^^${config.path}^^^^^");
            //appProvider.setMenuActiveIndex(3, true);

            GoRoutesPage.go(
                mode: NavigatorMode.push,
                moveTo: RouteName.occupationSearchScreen,
                param: param['oc']);
          }
        }*/
      }
    }).onError((error) {
      debugPrint('onLink error');
      printLog(error.message);
    });

    // WHEN APPLICATION CLOSE
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      var param = deepLink.queryParameters;

      // Recent updates sharing link...
      if (param['recent_id'] != null && param['recent_id']!.isNotEmpty) {
        UserInfoData userInfo = await SharedPreferenceController.getUserData();
        if (userInfo.name != null && userInfo.name!.isNotEmpty) {
          Future.delayed(const Duration(seconds: 5), () {
            GoRoutesPage.go(
                mode: NavigatorMode.push,
                moveTo: RouteName.recentUpdateScreen,
                param: param['recent_id']);
          });
        }
      }

      /* // Occupation sharing link...
      if (param['oc'] != null && param['oc']!.isNotEmpty) {
        // SET OCCUPATION PARAMETER FOR DYNAMIC LINK
        */ /* todo : redirect to search occupation search pending*/ /*
        Future.delayed(const Duration(seconds: 5), () {
          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.occupationSearchScreen,
              param: param['oc']);
        });
      }*/
    }
  }

  createDynamicLink(
      {required String link,
      required String title,
      required String description,
      required String imageUrl,
      required String? fallbackUrl}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: FirebaseDynamicLinkConstants.dynamicLinkPrefix,
        link: Uri.parse(link),
        androidParameters: AndroidParameters(
          packageName: FirebaseDynamicLinkConstants.androidBundleId,
          minimumVersion: 0,
          fallbackUrl: fallbackUrl == null ? null : Uri.parse(fallbackUrl),
        ),
        iosParameters: IOSParameters(
          bundleId: FirebaseDynamicLinkConstants.iosBundleId,
          appStoreId: FirebaseDynamicLinkConstants.iosAppStoreId,
          minimumVersion: '0',
          fallbackUrl: fallbackUrl == null ? null : Uri.parse(fallbackUrl),
          ipadFallbackUrl: fallbackUrl == null ? null : Uri.parse(fallbackUrl),
        ),
        navigationInfoParameters:
            const NavigationInfoParameters(forcedRedirectEnabled: true),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: title,
          description: description,
          imageUrl: Uri.parse(imageUrl),
        ));

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    return shortLink.shortUrl;
  }
}

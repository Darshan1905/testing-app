import 'dart:io';

import 'package:flutter/services.dart';
import 'package:occusearch/constants/constants.dart';

/// Platform channel constants class
class PlatformChannelConstants {
  static const platformChannel = 'flutter.native/helper';
  static const kondeskDomainName = "https://crm.kondesk.com/";

  static const kondeskJWTEncryptToken = "occusearch_encrypt_userEmail";
  static const occusearchEncryptRequest = "occusearch_encryptRequest";

  static const shareDynamicLink = "shareDynamicLink";

  static const lunchURL = "lunchUrl";
  static const guardDebugger = "guardDebugger";
}

class PlatformChannels {
  static const platform =
      MethodChannel(PlatformChannelConstants.platformChannel);

  /// Encrypt API Request Parameter
  static Future<Map<String, dynamic>> getOccuSearchEncryptedParam(
      dynamic params) async {
    try {
      final String encodedString = await platform.invokeMethod(
          PlatformChannelConstants.occusearchEncryptRequest, params);
      var param = {"key": encodedString};
      return param;
    } on PlatformException catch (e) {
      return {"error": e.message};
    }
  }

  /// To get JWT Bearer token
  static Future<String> getJWTBearerToken(String email, String domain) async {
    final data = {"email": email, "domain": domain};
    try {
      final String encodedString = await platform.invokeMethod(
          PlatformChannelConstants.kondeskJWTEncryptToken, data);
      return encodedString;
    } on PlatformException catch (e) {
      return "error ${e.message}";
    }
  }

  /// To Lunch URL
  static Future<void> lunchUrl(String? url) async {
    try {
      await platform.invokeMethod(PlatformChannelConstants.lunchURL, url);
    } on PlatformException catch (e) {
      printLog("error ${e.message}");
    }
  }

  /// To check TEMPER DETECTION
  static Future<bool> checkGuardDebugger() async {
    try {
      if (Platform.isAndroid) {
        bool isDebug =
            await platform.invokeMethod(PlatformChannelConstants.guardDebugger);
        return isDebug;
      } else {
        return true;
      }
    } on PlatformException catch (e) {
      printLog("error ${e.message}");
      return false;
    }
  }

  static Future<void> shareContentWithDynamicLink(
      String url, String package) async {
    final data = {"url": url, "package": package};
    await platform.invokeMethod(
        PlatformChannelConstants.shareDynamicLink, data);
  }
}

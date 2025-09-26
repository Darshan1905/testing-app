// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/data_provider/firebase/remote_config/model/aussizz_subscription_data.dart';
import 'package:occusearch/data_provider/firebase/remote_config/model/dynamic_base_url_model.dart';
import 'package:occusearch/data_provider/firebase/remote_config/model/dynamic_end_url_model.dart';

class FirebaseRemoteConfigController {
  static final FirebaseRemoteConfigController shared =
      FirebaseRemoteConfigController._internal();

  FirebaseRemoteConfigController._internal();

  // Firebase remote config instance
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  factory FirebaseRemoteConfigController()  {
    return shared;
  }

  DynamicBaseUrlModel? dynamicBaseUrl;
  DynamicEndUrlModel? dynamicEndUrl;
  SubscriptionAussizzData? subscriptionAussizzData;

  String shareAppContent = "";
  String severity = "";
  String description = "";
  String androidVersion = "";
  String iosVersion = "";

  Future<String> Data(
      {required String key,
      fetchTimeOutDuration = const Duration(seconds: 3),
      minimumFetchIntervalDuration = const Duration(hours: 4)}) async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: fetchTimeOutDuration,
          minimumFetchInterval: minimumFetchIntervalDuration,
        ),
      );

      await _remoteConfig.setDefaults(<String, dynamic>{
        "": '',
      });
      await _remoteConfig.fetchAndActivate();
      return _remoteConfig.getString(key);
    } catch (e) {
      printLog(e);
      return "";
    }
  }

  // return Firebase Remote Config object
  firebaseRemoteConfigObject(
      {fetchTimeOutDuration = const Duration(seconds: 3),
      minimumFetchIntervalDuration = const Duration(hours: 1)}) async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: fetchTimeOutDuration,
          minimumFetchInterval: minimumFetchIntervalDuration,
        ),
      );
      await _remoteConfig.setDefaults(<String, dynamic>{
        "": '',
      });
      await _remoteConfig.fetchAndActivate();

      // fetch data from firebase
      var dynamicBaseUrl =
          _remoteConfig.getString(FirebaseRemoteConfigConstants.dynamicBaseURL);
      var dynamicEndUrl =
          _remoteConfig.getString(FirebaseRemoteConfigConstants.dynamicEndURL);

      //store data into model
      FirebaseRemoteConfigController.shared.dynamicBaseUrl =
          DynamicBaseUrlModel.fromJson(jsonDecode(dynamicBaseUrl));
      FirebaseRemoteConfigController.shared.dynamicEndUrl =
          DynamicEndUrlModel.fromJson(jsonDecode(dynamicEndUrl));

      //fetch In-app Data
      severity =
          _remoteConfig.getString(FirebaseRemoteConfigConstants.severity);
      description =
          _remoteConfig.getString(FirebaseRemoteConfigConstants.description);
      iosVersion =
          _remoteConfig.getString(FirebaseRemoteConfigConstants.iosVersion);
      androidVersion =
          _remoteConfig.getString(FirebaseRemoteConfigConstants.androidVersion);
      //////
      shareAppContent = _remoteConfig
          .getString(FirebaseRemoteConfigConstants.keyShareAppContent);

      // fetch subscription data
      var subscriptionDetails = _remoteConfig.getString(FirebaseRemoteConfigConstants.keySubscriptionAussizz);

      FirebaseRemoteConfigController.shared.subscriptionAussizzData =
          SubscriptionAussizzData.fromJson(jsonDecode(subscriptionDetails));

      return _remoteConfig;
    } catch (exception) {
      //print("remote_exc: ${exception.toString()}");
      return;
    }
  }
}

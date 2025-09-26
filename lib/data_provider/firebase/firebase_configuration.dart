import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:occusearch/data_provider/firebase/dynamic_link/firebase_dynamic_link.dart';
import 'package:occusearch/data_provider/firebase/push_notification/push_notification.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';
import 'package:occusearch/utility/utils.dart';

class FirebaseConfiguration {
  static Future<void> configure() async {
    await Firebase.initializeApp();

    //Fetch data from firebase remote config
    await FirebaseRemoteConfigController.shared.firebaseRemoteConfigObject();

    //Firebase performance
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_messageHandler);

    // Subscribe notification Topics...
    subscribeToTopic();
    FirebasePushNotification.shared.configureNotification();

    FirebasePushNotification.shared.handlePushNotification();
    FirebaseDynamicLink.shared.initDynamicLinks();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      onSelectNotification(notificationResponse.payload);
      // ...
    });
  }

  static Future<dynamic> onSelectNotification(module) async {
    Map<String, dynamic>? action = json.decode(module);
    if (module != null) {
      FirebasePushNotification.shared.redirectToModule(
          payload: action, remoteMessage: null, openTimeInSecond: 3);
    }
  }

  static Future<void> _messageHandler(RemoteMessage message) async {
    printLog("Notification click:: ${message.data}");
    FirebasePushNotification.shared.showNotification(message);
  }

  // Firebase Notification Topic subscribe
  static subscribeToTopic() async {
    try {
      await FirebaseMessaging.instance
          .subscribeToTopic(FirebaseNotificationConstants.firebaseNotificationTopicGeneral);
    } catch (e) {
      debugPrint('error::  $e');
    }
  }
}

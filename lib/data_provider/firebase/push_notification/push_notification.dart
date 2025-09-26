// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/navigation/go_router.dart';
import 'package:occusearch/navigation/route_navigation.dart';
import 'package:occusearch/navigation/routes.dart';
import 'package:occusearch/utility/utils.dart';

class FirebaseNotificationConstants {
  static const firebaseNotificationServerKey =
      'AAAAqR7CmuM:APA91bEa8U1_O0fA2NjtRY6Jl5rLt5G5Kyry-uVK5W7WSnnxjrN90DiU5PX8fkbQ8VXPlsD_HwO9DkSapdE1_97GPYS--1TM0eSjevj3DXQ6-2_t9BIiFN8xqhzGstCnOAJAxDnOHHWZ';

  // Subscribe Firebase Notification Topic List
  static const firebaseNotificationTopicGeneral = "general";
  static const firebaseNotificationTopicPointCalculator = "point_calculator";
  static const firebaseNotificationTopicVisaFees = "visa_fees";
  static const firebaseNotificationTopicOccupation = "occupation";
  static const firebaseNotificationTopicFundCalculator = "fund_calculator";
  static const firebaseNotificationTopicVevoCheck = "vevo_check";

  // NAVIGATION SCREEN NAME
  static const firebaseNotificationTypeRecentUpdate = "recent_update";
}

class FirebasePushNotification {
  static final FirebasePushNotification shared =
      FirebasePushNotification._internal();

  factory FirebasePushNotification() {
    return shared;
  }

  FirebasePushNotification._internal();

  String? token;
  Map<String, dynamic>? action;
  Stream<String>? _tokenStream;
  AndroidNotificationChannel? channel;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  configureNotification() async {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.' // description
        );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification_tab presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _requestPushNotificationPermission();

    // FirebaseMessaging.onBackgroundMessage(_messageHandler);
  }

  // _messageHandler(RemoteMessage message)  {
  //   printLog("Notification click:: ${message.data}");
  //   showNotification(message);
  // }

  _requestPushNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      provisional: false,
      criticalAlert: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      // TODO: handle the received notifications
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    await FirebaseMessaging.instance
        .getToken(
            vapidKey:
                FirebaseNotificationConstants.firebaseNotificationServerKey)
        .then(_setToken);

    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream?.listen(_setToken);
  }

  void _setToken(String? token) {
    debugPrint('FCM Token: $token');
    this.token = token;
  }

  // call function if application is close/terminate and user click on notification
  handlePushNotification() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('A new applaunch event was published!');
        String opentype = message.data['notification_opentype'] ?? "";
        if (opentype == 'Browser') {
          Future.delayed(const Duration(seconds: 5), () {
            Utility.launchURL(message.data['click_action']);
          });
        } else {
          redirectToModule(
              remoteMessage: message, payload: null, openTimeInSecond: 5);
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      //Redirect to specific page
      String opentype = message.data['notification_opentype'] ?? "";
      if (opentype == 'Browser') {
        Utility.launchURL(message.data['click_action']);
      } else {
        redirectToModule(
            remoteMessage: message, payload: null, openTimeInSecond: 3);
      }
    });
  }

  void showNotification(RemoteMessage message) {
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      action = message.data;
      String image =
          message.data.isEmpty ? "" : message.data['notification_image'] ?? "";

      if (notification != null && android != null) {
        if (image.isNotEmpty && message.data.isNotEmpty && action != null) {
          _showBigPictureNotificationURL(notification.hashCode, action, image);
        } else {
          flutterLocalNotificationsPlugin?.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel?.id ?? '',
                  channel?.name ?? '',
                  channelDescription: channel?.description ?? "",
                  // TODO Add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'app_icon',
                ),
              ),
              payload: json.encode(action));
        }
      }
    } catch (e) {
      printLog(e);
    }
  }

  Future<void> _showBigPictureNotificationURL(
      int code, Map<String, dynamic>? data, String image) async {
    final ByteArrayAndroidBitmap bigPicture =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(image));

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(bigPicture,
            contentTitle: data?['title'],
            htmlFormatContentTitle: true,
            summaryText: data?['body'],
            htmlFormatSummaryText: true);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channel?.id ?? '',
      channel?.name ?? '',
      channelDescription: channel?.description ?? "",
      styleInformation: bigPictureStyleInformation,
      icon: 'app_icon',
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin!.show(
        code, data?['title'], data?['body'], platformChannelSpecifics,
        payload: json.encode(action));
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  ///TODO Push Notification redirection
  // BY CLICKING ON NOTIFICATION WHERE TO REDIRECT
  Future<void> redirectToModule(
      {required RemoteMessage? remoteMessage,
      required Map<String, dynamic>? payload,
      required int openTimeInSecond}) async {
    // get Login user details from shared preference...
    UserInfoData userInfo = await SharedPreferenceController.getUserData();

    String? moduleType;
    var arguments = "";

    if (remoteMessage != null) {
      debugPrint("Notification payload data_1 :: ${remoteMessage.data}");
      moduleType = remoteMessage.data['notification_module_type'];
      arguments = remoteMessage.data['recent_changes_id'] ?? '';
    } else if (payload != null) {
      debugPrint("Notification payload data_2 :: $payload");
      moduleType = payload['notification_module_type'];
      arguments = payload['recent_changes_id'] ?? '';
    }

    if (userInfo.name != null && userInfo.name!.isNotEmpty) {
      // Navigation To [RECENT UPDATE] screen
      if (moduleType != null &&
          moduleType ==
              FirebaseNotificationConstants
                  .firebaseNotificationTypeRecentUpdate) {
        String? recentId = arguments;
        Future.delayed(Duration(seconds: openTimeInSecond), () {
          printLog(
              "Notification current route :: ${GoRouterConfig.router.location}");
          if ("/${RouteName.recentUpdateScreen}" ==
              GoRouterConfig.router.location) {
            GoRoutesPage.go(
                mode: NavigatorMode.replace,
                moveTo: RouteName.recentUpdateScreen,
                param: recentId);
          } else {
            GoRoutesPage.go(
                mode: NavigatorMode.push,
                moveTo: RouteName.recentUpdateScreen,
                param: recentId);
          }
        });
      } else {}
    }
  }
}

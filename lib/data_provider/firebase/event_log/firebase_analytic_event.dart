import 'dart:developer';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:occusearch/constants/constants.dart';

class FirebaseAnalyticLog {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static final FirebaseAnalyticLog shared = FirebaseAnalyticLog._event();

  factory FirebaseAnalyticLog() {
    return shared;
  }

  FirebaseAnalyticLog._event();

  /// Login user information
  static String _fullName = "";
  static String _mobileNumber = "";
  static String _emailAddress = "";
  static String _userID = "";
  static String _firebaseUserID = ""; // Firebase realtime database id
  static String _firebaseToken = ""; // Firebase push notification token

  setUserInformation(
      {required fullName,
      required mobileNumber,
      required emailAddress,
      required userID,
      required firebaseUserID,
      required firebaseToken}) {
    _userID = userID;
    _fullName = fullName;
    _mobileNumber = mobileNumber;
    _emailAddress = emailAddress;
    _firebaseUserID = firebaseUserID;
    _firebaseToken = firebaseToken;
    setDefaultLogs();
  }

  setDefaultLogs() {
    _analytics.setUserId(
        id: _mobileNumber.trim().isNotEmpty ? _mobileNumber : _emailAddress);
    Map<String, Object> param = <String, Object>{
      firebaseAnalyticsUserId: _userID,
      firebaseAnalyticsUserEmail: _emailAddress,
      firebaseAnalyticsUserMobile: _mobileNumber,
      firebaseAnalyticsUsername: _fullName,
      firebaseAnalyticsFbToken: _firebaseToken,
      firebaseAnalyticsFbUserId: _firebaseUserID,
    };
    _analytics.setDefaultEventParameters(param);
  }

  /// Here we check Login user information is set or not...
  checkUserInfoHave({String? type}) {
    if (_userID.isEmpty) {
      log("+---------------------------------------------------------------------------------------+");
      log("| USER_BEHAVIOUR_OBSERVER [${type ?? ''}] WARNING :: User profile information is not set yet. |");
      log("+---------------------------------------------------------------------------------------+");
      return false;
    }
    return true;
  }

// ** Random event log **
  void eventLog(
      {required String title, required String message, String? other}) {
    try {
      Map<String, Object> param = <String, Object>{
        firebaseAnalyticsTitle: title,
        firebaseAnalyticsMessage: _splitStringInto100Character(message),
        firebaseAnalyticsOther: _splitStringInto100Character(other)
      };
      // submit event log
      _writeEventLog(title, param);
    } catch (e) {
      printLog(e);
    }
  }

  // ** Event tracking like button click event, card section click event or any other log/event tracking **
  void eventTracking(
      {
      // Current screen name for ex. DashboardScreen, MoreMenu screen etc
      required String screenName,
      // Screen section name where event was occurred ex. Product section, Course Plan section, Ads banner
      String? sectionName,
      // event type name ex. share button click, buy now button click, refer friend button click etc
      required String actionEvent,
      // Message like Course name that user wants to purchase, detail about section or events
      String? subSectionName,
      // message
      String? message,
      // Others extra information about events wants to pass
      String? other}) {
    try {
      Map<String, Object> param = <String, Object>{
        firebaseAnalyticsCurrentScreenName: screenName,
        firebaseAnalyticsSectionName: sectionName ?? "",
        firebaseAnalyticsSubSectionName: subSectionName ?? "",
        firebaseAnalyticsAction: actionEvent,
        firebaseAnalyticsMessage: _splitStringInto100Character(message),
        firebaseAnalyticsUserId: _userID,
        firebaseAnalyticsFbUserId: _firebaseUserID,
        firebaseAnalyticsOther: other ?? "",
      };
      // submit event log
      _writeEventLog(actionEvent, param);
    } catch (e) {
      printLog(e);
    }
  }

  // ** Route Navigation event Tracking like  PUSH, POP, REMOVE, REPLACE etc. **
  void screenNavigationTracking(
      {
      // Current screen name for ex. DashboardScreen, MoreMenu screen etc
      String? screenName,
      // Navigation status like Push, POP, Remove, Replace etc
      required String navigationAction,
      String? message, // Message for screen
      String other = "" // Extra information about events
      }) {
    try {
      Map<String, Object> param = <String, Object>{
        firebaseAnalyticsCurrentScreenName: screenName ?? "",
        firebaseAnalyticsNavigationTo: navigationAction,
        firebaseAnalyticsMessage: _splitStringInto100Character(message),
        firebaseAnalyticsUserId: _userID,
        firebaseAnalyticsFbUserId: _firebaseUserID,
        firebaseAnalyticsOther: other,
      };
      _writeEventLog(firebaseAnalyticsNavigationTracking, param);
    } catch (e) {
      printLog(e);
    }
  }

  // ** User spent time on particular screen **
  void screenTimeTracking(
      {
      // Previous screen name where user came from ex. Splash Screen
      String? previousScreenName,
      // Logged screen name for ex. DashboardScreen
      required String? screenName,
      // Current screen name for ex. More menu screen
      String? visibleScreenName,
      // Navigation status like Push, POP, Remove, Replace etc
      required String navigationAction,
      // How much time user spent on particular screen
      String? spentTime,
      // Message for time event
      String? message,
      // Extra information about events
      String other = ""}) {
    try {
      Map<String, Object> param = <String, Object>{
        firebaseAnalyticsCurrentScreenName: screenName ?? "",
        firebaseAnalyticsPreviousScreenName: previousScreenName ?? "",
        firebaseAnalyticsNextScreenName: visibleScreenName ?? "",
        // NAVIGATION_TO: status,
        firebaseAnalyticsSpentTime: spentTime ?? "0",
        firebaseAnalyticsMessage: _splitStringInto100Character(message),
        firebaseAnalyticsUserId: _userID,
        firebaseAnalyticsFbUserId: _firebaseUserID,
        firebaseAnalyticsOther: other,
      };
      _writeEventLog(firebaseAnalyticsScreenTimeTracking, param);
    } catch (e) {
      printLog(e);
    }
  }

// ** API Request & Response Tracking Log **
  void apiRequestTracking(
      {required String apiName, // API Name
      String? header, // API header
      String? requestJSON, // API JSON Request
      String? requestEncryptedJSON,
      required String
          requestType, // Request Type [GET, POST, DELETE, UPDATE etc]
      String? responseJSON, // API JSON Response
      // API Response status code like: 200-OK, 404-NOT FOUND, 500-INTERNAL SERVER ERROR etc
      int? responseStatusCode,
      // API Response JSON key "message" value text
      String? responseMessage,
      // Extra information about events
      String other = ""}) {
    try {
      Map<String, Object> param = <String, Object>{
        firebaseAnalyticsApiName: apiName,
        firebaseAnalyticsApiHeader: header ?? "",
        firebaseAnalyticsApiRequestJson:
            _splitStringInto100Character(requestJSON),
        firebaseAnalyticsApiRequestEncryptedJson:
            _splitStringInto100Character(requestEncryptedJSON ?? ""),
        firebaseAnalyticsApiRequestType: requestType,
        firebaseAnalyticsApiResponseJson:
            _splitStringInto100Character(responseJSON),
        firebaseAnalyticsApiResponseCode: responseStatusCode ?? 0,
        firebaseAnalyticsApiResponseMessage:
            _splitStringInto100Character(responseMessage),
        firebaseAnalyticsOther: other,
      };
      _writeEventLog(firebaseAnalyticsApiTracking, param);
    } catch (e) {
      printLog(e);
    }
  }

  // ** Online Payment Event Tracking Log **
  void paymentTracking(
      {String? cartID, // API Cart ID
      String? productID, // product/item ID
      String? productName, // product/Item name
      String? transactionID, // Transaction ID
      String? paymentToken, // Payment Token
      String? productPrice, // Product Price
      String? currency, // Currency
      String? deviceType, // Device Type ex. Android or iOS
      String? priceID, // Product price ID
      String? paymentFlag, // Payment flag ex. Success or Failed, Error etc
      String? gateway, // Payment Gateway ex. In App Purchase, Stripe Payment
      required bool isPurchaseProduct, // isPurchase the product or not
      String other = "" // Extra information about events
      }) {
    try {
      Map<String, Object> param = <String, Object>{
        firebaseAnalyticsCartId: cartID ?? "",
        firebaseAnalyticsProductId: productID ?? "",
        firebaseAnalyticsProductName: productName ?? "",
        firebaseAnalyticsTransactionId: transactionID ?? "",
        firebaseAnalyticsPaymentTokenId: paymentToken ?? "",
        firebaseAnalyticsProductPrice: productPrice ?? "",
        firebaseAnalyticsCurrency: currency ?? "",
        firebaseAnalyticsDeviceType: deviceType ?? "",
        firebaseAnalyticsPriceId: priceID ?? "",
        firebaseAnalyticsPaymentFlag: paymentFlag ?? "",
        firebaseAnalyticsPaymentGateway: gateway ?? "",
        firebaseAnalyticsIsPurchaseProduct: isPurchaseProduct,
        firebaseAnalyticsUserId: _userID,
        firebaseAnalyticsFbUserId: _firebaseUserID,
        firebaseAnalyticsOther: _splitStringInto100Character(other),
      };
      _writeEventLog(firebaseAnalyticsPaymentTracking, param);
    } catch (e) {
      printLog(e);
    }
  }

  // ** Push Notification & Dynamic Link Event Log **
  void notificationDynamicLinkTracking(
      {
      // [TRUE] Notification, [FALSE] Dynamic link
      required bool isFromNotificationOrDynamicLink,
      String? type, // Notification type
      String? url, // Attached url if have
      String other = "" // Extra information about events
      }) {
    try {
      Map<String, Object> param = <String, Object>{
        // [TRUE] Notification, [FALSE] Dynamic link
        firebaseAnalyticsIsNotification: isFromNotificationOrDynamicLink,
        firebaseAnalyticsType: type ?? "",
        firebaseAnalyticsUrl: url ?? "",
        firebaseAnalyticsUserId: _userID,
        firebaseAnalyticsFbUserId: _firebaseUserID,
        firebaseAnalyticsOther: _splitStringInto100Character(other),
      };
      _writeEventLog(firebaseAnalyticsNotifyDynamicTracking, param);
    } catch (e) {
      printLog(e);
    }
  }

  /// write firebase event log
  _writeEventLog(String? log, Map<String, Object>? param) {
    /// checking that login user information is set or not
    checkUserInfoHave(type: log);
    //print(param);
    /// called firebase logevent() method to write log
    _analytics.logEvent(
        name: _splitStringInto40Character(log), parameters: param);
  }

  /// Split String value if length is more then 100 character,
  /// if we don't split then firebase consider that log as a Event Error
  /// https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Param
  String _splitStringInto100Character(String? value) {
    if (value != null && value.isNotEmpty && value.length > 100) {
      value = value.substring(0, 99);
    }
    return value ?? "";
  }

  String _splitStringInto40Character(String? value) {
    if (value != null && value.isNotEmpty && value.length > 40) {
      value = value.substring(0, 39);
    }
    return value ?? "EVENT";
  }
}

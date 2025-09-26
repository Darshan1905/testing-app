// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:io';
import 'dart:math';

import 'package:android_id/android_id.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/app_style/theme/theme_bloc.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/dynamic_link/firebase_dynamic_link.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void printLog(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

class Utility {
  static launchURL(String url) async {
    if (url.startsWith("www.", 0)) {
      Utility.launchURL("http://$url");
    }

    await canLaunchUrlString(url)
        ? await launchUrlString(url, mode: LaunchMode.externalApplication)
        : throw 'Could not launch $url';
  }

  static String getTodayDate() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  static double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);

    // print("Vevo file:: ${sizeInMb}");
    return sizeInMb;
  }

  // convert dobule into currency format, ex. 25365.86 to 25,365.86
  static String getAmountInCurrencyFormat({required double? amount}) {
    MoneyFormatter fmf = MoneyFormatter(amount: amount ?? 0.0);
    return fmf.output.nonSymbol;
  }

  //convert int number format,Ex.256365 to 2,56,365
  static String getIntAmountFormat({required int? amount}) {
    var formatter = NumberFormat('#,##,000');
    return formatter.format(amount);
  }

  static String getDoubleAmountFormat({required double? amount}) {
    var formatter = NumberFormat('#,##,000');
    return formatter.format(amount);
  }

  static Future<String> getDeviceId() async {
    String deviceId = "unknown";
    if (Platform.isAndroid) {
      const androidIdPlugin = AndroidId();
      deviceId = await androidIdPlugin.getId() ?? "unknown";
    } else if (Platform.isIOS) {
      const storage = FlutterSecureStorage();
      String? storedDeviceId =
          await storage.read(key: RequestParameterKey.secureDeviceId);
      if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
        deviceId = storedDeviceId;
      } else {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor!;
        await storage.write(
            key: RequestParameterKey.secureDeviceId, value: deviceId);
      }
    }
    return deviceId;
  }

  static void showToastErrorMessage(BuildContext context, int? statusCode) {
    String message = "";
    switch (statusCode) {
      case NetworkAPIConstant.statusCodeNoInternet:
        message = StringHelper.internetConnection;
        break;
      case NetworkAPIConstant.statusCodeVPNConnection:
        message = NetworkAPIConstant.vpnAlertMessage;
        break;
      case NetworkAPIConstant.statusCodeServerError:
        message = NetworkAPIConstant.somethingWentWrong;
        break;
      default:
        message = NetworkAPIConstant.somethingWentWrong;
        break;
    }
    Toast.show(context, message: message, duration: 3, type: Toast.toastError);
  }

  // Here we check if user is Login in firebase or not
  static Future<bool> checkFirebaseAuthUserFound() async {
    //return false;
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null && firebaseUser.uid.isNotEmpty) {
      // User is signed in.
      debugPrint(firebaseUser.displayName ?? "Name not found in firebase.");
      return true;
    } else {
      // No user is signed in.
      return false;
    }
  }

  static List<String> getMonthNameList() {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
  }

  static String getFormattedNumber(int number) {
    var formatter = NumberFormat('#,##,000');
    return formatter.format(number);
  }

  //to get initial name from given name
  static String getInitials(String userName) {
    if (userName.length == 1) {
      return userName;
    }
    return userName.isNotEmpty
        ? userName.trim().split(' ').length < 2
            ? userName.trim().substring(0, 2).toUpperCase()
            : userName
                .trim()
                .split(' ')
                .map((i) => i[0])
                .take(2)
                .join()
                .toUpperCase()
        : '';
  }

  static imageCache(String url, BuildContext context) {
    return CachedNetworkImage(
        imageUrl: url,
        //color: Colors.white,
        fit: BoxFit.cover,
        placeholder: (context, error) =>
            SvgPicture.asset(IconsSVG.placeholder, width: 18.0, height: 18.0),
        errorWidget: (context, url, error) => Icon(
              Icons.photo,
              color: AppColorStyle.disableVariant(
                  context), //TODO: change after proper color added.
            ));
  }

  //Share application
  static shareApplication(String shareApplicationText) {
    Share.share(
        "$shareApplicationText${Constants.occuSearchAppPlaystoreAppStoreDynamicLink}");
  }

  static openUrl(String? url, {bool launchExternal = true}) async {
    if (url != null) {
      final Uri encodedUrl = Uri.parse(url);
      if (await canLaunchUrl(encodedUrl)) {
        await launchUrl(encodedUrl,
            mode: launchExternal
                ? LaunchMode.externalApplication
                : LaunchMode.inAppWebView,
            webViewConfiguration:
                const WebViewConfiguration(enableJavaScript: true));
      } else {
        throw 'Could not launch $encodedUrl';
      }
    }
  }

  static Future<int> getOSVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    double osVersion;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      osVersion = double.parse(androidInfo.version.release);
    } else {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      String versionString = iosDeviceInfo.systemVersion ?? '';
      if (versionString.contains(".")) {
        List<String> versionList = versionString.split(".");
        if (versionList.length > 2) {
          versionList.removeLast();
          versionString = versionList.join(".");
        }
      }
      osVersion = double.parse(versionString);
    }
    return osVersion.round();
  }

  static Future<Permission> getPhotoPermissionType() async {
    int osVersion = await Utility.getOSVersion();
    Permission permission = Platform.isIOS
        ? Permission.photos
        : osVersion < 13
            ? Permission.storage
            : Permission.photos;
    return permission;
  }

  static Future<Permission> getStoragePermissionType() async {
    int osVersion = await Utility.getOSVersion();
    Permission permission = Platform.isAndroid && osVersion >= 13
        ? Permission.photos
        : Permission.storage;
    return permission;
  }

  static String capitalizeAllWords(String value) {
    if (value.isNotEmpty) {
      var result = value[0].toUpperCase();
      for (int i = 1; i < value.length; i++) {
        if (value[i - 1] == " ") {
          result = result + value[i].toUpperCase();
        } else {
          result = result + value[i];
        }
      }
      return result;
    }
    return value;
  }

  // To get point test dialer color based on point score number
  static Color getPointTestDialerColor(BuildContext context, int points) {
    if (points < 30) {
      return AppColorStyle.red(context);
    } else if (points >= 30 && points < 75) {
      return AppColorStyle.yellow(context);
    } else if (points >= 75 && points <= 130) {
      return AppColorStyle.teal(context);
    } else if (points > 130) {
      return AppColorStyle.green(context);
    }
    return AppColorStyle.cyanVariant2(context);
  }

  // To get point test dialer gradient color based on point score number
  static (List<Color>, List<double>) getPointTestDialerGradientColor(
      BuildContext context, int points) {
    List<Color> gradientColors = [];
    List<double> gradientPercentage = [];
    if (points > 0) {
      //return AppColorStyle.red(context);
      gradientColors.add(AppColorStyle.red(context));
      //gradientPercentage.add(0.25);
      gradientPercentage.add(0.15);
    }
    if (points >= 30) {
      //return AppColorStyle.yellow(context);
      gradientColors.add(AppColorStyle.yellow(context));
      gradientPercentage.add(0.45);
    }
    if (points >= 75) {
      //return AppColorStyle.teal(context);
      gradientColors.add(AppColorStyle.teal(context));
      gradientPercentage.add(0.75);
    }
    if (points >= 130) {
      //return AppColorStyle.green(context);
      gradientColors.add(AppColorStyle.green(context));
      gradientPercentage.add(1.0);
    }
    // return AppColorStyle.cyanVariant2(context);
    return (gradientColors, gradientPercentage);
  }

  // To get point test dialer color based on point score number
  static String getPointGrade(BuildContext context, int points) {
    if (points < 30) {
      return "Weak";
    } else if (points >= 30 && points < 65) {
      return "Average";
    } else if (points >= 65 && points <= 80) {
      return "Good";
    } else if (points > 80) {
      return "Excellent";
    }
    return "Good";
  }

  // To get Skill level text based on skill number 1-2, if number other than (1-5) then return "-"
  static String getSkillLevel(BuildContext context, int skillLevel) {
    if (skillLevel == 1) {
      return "Very High Skill";
    } else if (skillLevel == 2) {
      return "High Skill";
    } else if (skillLevel == 3) {
      return "Medium Skill";
    } else if (skillLevel == 4) {
      return "Lower Skill";
    } else if (skillLevel == 5) {
      return "Entry Level";
    }
    return " - ";
  }

  static String capitalizeAfterDot(String text) {
    final split = text.replaceAll(RegExp(r"(\.+)"), ' #').split(' ');
    String result = split.reduce((a, b) {
      if (b.startsWith('#')) {
        return a + b.replaceRange(0, 2, '. ${b[1].toUpperCase()}');
      }
      return '$a $b';
    });

    return result.replaceRange(0, 1, result[0].toUpperCase());
  }

  static String capitalizeAll(String text) {
    return text.replaceAllMapped(RegExp(r'\.\s+[a-z]|^[a-z]'), (m) {
      final String match = m[0] ?? '';
      return match.toUpperCase();
    });
  }

  static getRandomBGColor() {
    /// TODO : Condition for light and dark theme Pending.
    return ThemeBloc().currentTheme
        ? ThemeConstant.arrRandomColorsDark[Random().nextInt(12)]
        : ThemeConstant.arrRandomColors[Random().nextInt(12)];
  }

  static getRandomBGVisaListScreenColor() {
    return ThemeConstant.arrRandomVisaListColors[Random().nextInt(9)];
  }

  // Recent update dynamic link sharing(deep linking)..
  static shareRecentUpdatePostLink(
      {required String title,
      required String subTitle,
      required Uint8List? imageInBytes,
      required String recentChangesId}) async {
    String link =
        '${Constants.occusearchWebsiteRecentUpdateLink}?recent_id=$recentChangesId';
    Uri? dynamicLink = await FirebaseDynamicLink.shared.createDynamicLink(
        link: link,
        title: title,
        description: subTitle,
        imageUrl: "",
        fallbackUrl: link);

    var data =
        "\nFor more details, please visit the below link \n\n${(dynamicLink != null) ? dynamicLink.toString() : ''}";

    XFile file = await _createFileFromString(imageInBytes!);
    //print(image_file_path);
    await Share.shareXFiles(
      [file],
      subject: "Recent update: $title",
      text: data,
    );
    //await Share.share(data, subject: "Recent update: $title");
  }

  static shareRecentUpdatePostLinkWithImageURl(
      {required String title,
      required String subTitle,
      required String imageUrl,
      required String recentChangesId}) async {
    String link =
        '${Constants.occusearchWebsiteRecentUpdateLink}?recent_id=$recentChangesId';
    Uri? dynamicLink = await FirebaseDynamicLink.shared.createDynamicLink(
      link: link,
      title: title,
      description: subTitle,
      imageUrl: imageUrl,
      fallbackUrl: link,
    );

    var data =
        "\nFor more details, please visit the below link \n\n${(dynamicLink != null) ? dynamicLink.toString() : ''}";

    await Share.share(data, subject: "Recent update: $title");
  }

  static Future<XFile> _createFileFromString(Uint8List uint8) async {
    //final encodedStr = "put base64 encoded string here";
    //Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/occusearch_recent_update.jpg");
    await file.writeAsBytes(uint8);
    return XFile(file.path, name: "Recent update");
    // return file.path;
  }

/*  static Future<String> _createFileFromString1(Uint8List uint8) async {
    //final encodedStr = "put base64 encoded string here";
    //Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/occusearch_recent_update.jpg");
    await file.writeAsBytes(uint8);
    return file.path;
  }*/

  static int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  //OCCUPATION BASED ON SKILL-LEVEL CALCULATE COLOR
  static getSkillLevelColor(int skillLevel) {
    if (skillLevel != 0 && skillLevel <= 5) {
      var skillLevelColorArr, splitArr = [];
      skillLevelColorArr = [
        ThemeConstant.greenVariantTemp,
        ThemeConstant.lightGreenVariantTemp,
        ThemeConstant.yellowVariantTemp,
        ThemeConstant.orangeVariantTemp,
        ThemeConstant.redVariantTemp,
      ];
      splitArr = skillLevelColorArr.sublist(((skillLevel) - 1), 5);
      //OTHER ELEMENTS FILLED WITH DEFAULT COLOR
      return splitArr.reversed;
    } else {
      return [];
    }
  }

  static popToSpecificPage(BuildContext context,
      {required String rootName, dynamic data}) {
    int indexOfRoute = GoRouterConfig.router.routeList
        .indexWhere((element) => element.contains(rootName));
    int routeListLength = GoRouterConfig.router.routeList.length;
    if (indexOfRoute == -1) {
      GoRoutesPage.go(mode: NavigatorMode.push, moveTo: rootName, param: data);
    } else if (GoRouterConfig.router.routeList[routeListLength - 2]
        .contains(rootName)) {
      context.pop(data);
    } else {
      context.popUntil(rootName, extra: data);
    }
  }

  //OCCUPATION BASED ON SKILL-LEVEL CALCULATE COLOR WITH DEFAULT GREY COLOR
  static getSkillLevelWithDefaultColor(int skillLevel) {
    var defaultColor, list = [];
    var skillLevelColorArr, splitArr = [];
    skillLevelColorArr = [
      ThemeConstant.greenVariantTemp,
      ThemeConstant.lightGreenVariantTemp,
      ThemeConstant.yellowVariantTemp,
      ThemeConstant.orangeVariantTemp,
      ThemeConstant.redVariantTemp,
    ];
    if (skillLevel == 0) {
      defaultColor =
          List.filled(skillLevelColorArr.length, ThemeConstant.disableVariant);
      list = [...splitArr.reversed, ...defaultColor];
      return list;
    }
    if (skillLevel != 0 && skillLevel <= 5) {
      splitArr = skillLevelColorArr.sublist(((skillLevel) - 1), 5);
      //OTHER ELEMENTS FILLED WITH DEFAULT COLOR
      defaultColor = List.filled(skillLevelColorArr.length - splitArr.length,
          ThemeConstant.disableVariant);
      list = [...splitArr.reversed, ...defaultColor];
      return list;
    } else {
      return [];
    }
  }

  // LABOUR INSIGHT -> Region wise employment
  static double getLatitude(String state) {
    if (state.contains("NSW")) {
      return -32.7105788;
    } else if (state.contains("VIC")) {
      return -36.857262;
    } else if (state.contains("QLD")) {
      return -22.973994;
    } else if (state.contains("SA")) {
      return -30.061947;
    } else if (state.contains("WA")) {
      return -26.461694;
    } else if (state.contains("TAS")) {
      return -42.044415;
    } else if (state.contains("NT")) {
      return -19.773913;
    } else if (state.contains("ACT")) {
      return -35.402884;
    }
    return 0.0;
  }

  /*NSW, Australia : -32.7105788,144.7602029
VIC, Australia : -36.857262, 144.221405
QLD, Australia : -22.973994, 144.174430
SA, Australia : -30.061947, 134.861824
WA, Australia : -26.461694, 122.161929
TAS, Australia : -42.044415, 146.460750
NT, Australia : -19.773913, 133.567818
ACT, Australia : -35.402884, 148.998998*/

  static double getLongitude(String state) {
    if (state.contains("NSW")) {
      return 144.7602029;
    } else if (state.contains("VIC")) {
      return 144.221405;
    } else if (state.contains("QLD")) {
      return 144.174430;
    } else if (state.contains("SA")) {
      return 134.861824;
    } else if (state.contains("WA")) {
      return 122.161929;
    } else if (state.contains("TAS")) {
      return 146.460750;
    } else if (state.contains("NT")) {
      return 133.567818;
    } else if (state.contains("ACT")) {
      return 148.998998;
    }
    return 0.0;
  }

/*
ACT - Australian Capital Territory
NSW - New South Wales
QLD - Queensland
NT - Northern Territory
SA - South Australia
TAS - Tasmania
VIC - Victoria
WA - Western Australia
*/

  //for region convert state into full name!
  static String getFullNameOfAUState(String state) {
    if (state.toUpperCase() == "NSW") {
      return "New South Wales";
    } else if (state.toUpperCase() == "VIC") {
      return "Victoria";
    } else if (state.toUpperCase() == "QLD") {
      return "Queensland";
    } else if (state.toUpperCase() == "SA") {
      return "South Australia";
    } else if (state.toUpperCase() == "WA") {
      return "Western Australia";
    } else if (state.toUpperCase() == "TAS") {
      return "Tasmania";
    } else if (state.toUpperCase() == "NT") {
      return "Northern Territory";
    } else if (state.toUpperCase() == "ACT") {
      return "Australian Capital Territory";
    }
    return state;
  }

  static String getYearFromWeek(int week) {
    int totalWeek = 52;
    double year = week / totalWeek;
    String finalYear = year.toStringAsFixed(1);
    return finalYear;
  }

  //to make capital first latter of each word
  static String capitaliseName(String name) {
    List<String> words = name.trim().split(' ');
    for (int i = 0; i < words.length; i++) {
      String latestWord = words[i];
      words[i] = (latestWord[0].toUpperCase() + latestWord.substring(1));
    }
    return words.join(' ');
  }

  static writeFacebookEventsLog(
      {@required String? eventName,
      @required String? screenName,
      @required String? sectionName,
      String? message}) async {
    try {
      UserInfoData userInfoData =
          await SharedPreferenceController.getUserData();
      Map<String, dynamic> param = <String, dynamic>{
        "SCREEN_NAME": screenName ?? '',
        "SECTION_NAME": sectionName ?? '',
        "MESSAGE": message ?? '',
        "USER_ID": userInfoData.userId ?? 0,
        "USER_NAME": userInfoData.name ?? "",
        "USER_EMAIL": userInfoData.email ?? "",
        "USER_MOBILE": userInfoData.phone ?? 0,
        "COUNTRY_CODE": userInfoData.countryCode ?? 0,
      };
      final facebookAppEvents = FacebookAppEvents();
      facebookAppEvents.logEvent(name: eventName ?? '', parameters: param);

      FirebaseAnalyticLog.shared.eventTracking(
          screenName: RouteName.subscription,
          actionEvent: eventName ?? '',
          message: param.toString());
    } catch (e) {
      print(e);
    }
  }
}

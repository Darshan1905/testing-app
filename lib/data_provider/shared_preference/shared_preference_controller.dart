// ignore_for_file: non_constant_identifier_names

import 'package:occusearch/data_provider/shared_preference/shared_preference_constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceController {
  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 1;
  }

  static setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<double> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0;
  }

  static setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<List<String>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static setStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  //........................................

  getIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceConstants.isLogin) ?? false;
  }

  setIsLogin(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceConstants.isLogin, value);
  }

  static Future<bool> getIsWelcomeOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceConstants.isWelcome) ?? false;
  }

  static setIsWelcomeOpen(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceConstants.isWelcome, value);
  }

  getDeviceUUI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceConstants.deviceUUID) ?? "";
  }

  setDeviceUUI(String UUID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceConstants.deviceUUID, UUID);
  }

  static getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceConstants.themeMode) ?? false;
  }

  static setThemeMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceConstants.themeMode, value);
  }

  static getAdsBannerClickStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceConstants.clickOnAdsBanner) ?? false;
  }

  static setAdsBannerClickStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceConstants.clickOnAdsBanner, value);
  }

  getIsDashboardTourGuideDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    printLog(prefs.getBool(SharedPreferenceConstants.isDashboardTourGuide));
    return prefs.getBool(SharedPreferenceConstants.isDashboardTourGuide) ??
        false;
  }

  setIsDashboardTourGuideDone(bool value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
          SharedPreferenceConstants.isDashboardTourGuide, value);
    } catch (e) {
      printLog(e);
    }
  }

  //For checking if subscription dialog is shown once or not
  static Future<bool> getIsSubscriptionDialogShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceConstants.isSubscriptionDialogShown) ?? false;
  }

  static setIsSubscriptionDialogShown(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPreferenceConstants.isSubscriptionDialogShown, value);
  }

  // ----------- [USER DATA] -----------
  static Future<UserInfoData> getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserInfoData userInfo = UserInfoData(
      pref.getInt(SharedPreferenceConstants.userId),
      pref.getString(SharedPreferenceConstants.leadCode),
      pref.getString(SharedPreferenceConstants.name),
      pref.getString(SharedPreferenceConstants.phone),
      pref.getString(SharedPreferenceConstants.email),
      pref.getString(SharedPreferenceConstants.dateOfBirth),
      pref.getString(SharedPreferenceConstants.profilePicture),
      pref.getString(SharedPreferenceConstants.deviceId),
      pref.getString(SharedPreferenceConstants.countryCode),
      pref.getInt(SharedPreferenceConstants.companyidf),
      pref.getInt(SharedPreferenceConstants.branchidf),
      pref.getString(SharedPreferenceConstants.productID),
      pref.getInt(SharedPreferenceConstants.subscriptionId),
      pref.getInt(SharedPreferenceConstants.planId),
      pref.getString(SharedPreferenceConstants.subName),
      pref.getBool(SharedPreferenceConstants.isDelete),
      pref.getInt(SharedPreferenceConstants.subRemainingDays),
      pref.getString(SharedPreferenceConstants.subsStartDate),
      pref.getString(SharedPreferenceConstants.subEndDate),
    );
    return userInfo;
  }

  static Future<void> setUserData(UserInfoData uData) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setInt(SharedPreferenceConstants.userId, uData.userId!);
      pref.setString(
          SharedPreferenceConstants.leadCode, (uData.leadCode ?? "").trim());
      pref.setString(SharedPreferenceConstants.name, (uData.name ?? "").trim());
      pref.setString(
          SharedPreferenceConstants.phone, (uData.phone ?? "").trim());
      pref.setString(
          SharedPreferenceConstants.email, (uData.email ?? "").trim());
      pref.setString(
          SharedPreferenceConstants.dateOfBirth, uData.dateOfBirth ?? "");
      pref.setString(
          SharedPreferenceConstants.profilePicture, uData.profilePicture ?? "");
      pref.setString(
          SharedPreferenceConstants.deviceId, (uData.deviceId ?? "").trim());
      pref.setString(SharedPreferenceConstants.countryCode,
          (uData.countryCode ?? "").trim());
      pref.setInt(SharedPreferenceConstants.companyidf, uData.companyId ?? 0);
      pref.setInt(SharedPreferenceConstants.branchidf, uData.branchId ?? 0);
      pref.setString(SharedPreferenceConstants.productID, uData.productID ?? "0");
      pref.setInt(SharedPreferenceConstants.subscriptionId, uData.subscriptionId ?? 0);
      pref.setInt(SharedPreferenceConstants.planId, uData.planId ?? 0);
      pref.setString(SharedPreferenceConstants.subName, uData.subName ?? "");
      pref.setBool(SharedPreferenceConstants.isDelete, uData.isDelete ?? false);
      pref.setInt(SharedPreferenceConstants.subRemainingDays, uData.subRemainingDays ?? 0);
      pref.setString(SharedPreferenceConstants.subsStartDate, uData.subsStartDate ?? "");
      pref.setString(SharedPreferenceConstants.subEndDate, uData.subEndDate ?? "");
    } catch (e) {
      printLog("SharedPreferenceController-setUserData() = $e");
    }
  }

  static clearPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

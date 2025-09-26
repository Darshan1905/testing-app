import 'dart:async';
import 'dart:convert';
import 'package:occusearch/constants/constants.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_constants.dart';
import 'package:occusearch/utility/rating/model/rate_us_dialog_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicRatingCalculation {
  // INSERT & UPDATE Rating JSON from Firebase RemoteConfig
  static Future<bool> setFirebaseRemoteConfigRatingJSON(
      {required bool isCameFromSplash}) async {
    final completer = Completer<bool>();
    try {
      // getting rating data from firebase config
      String firebaseRemoteConfigRatingJSON =
          await FirebaseRemoteConfigController.shared
              .Data(key: FirebaseRemoteConfigConstants.keyDynamicRating);

      // convert string into model
      RateUsDialogModel firebaseRatingDynamicModel = RateUsDialogModel.fromJson(
          json.decode(firebaseRemoteConfigRatingJSON));

      //Shared Preference instance
      SharedPreferences spInstance = await SharedPreferences.getInstance();

      //to check if user came from dashboard don't update
      // when user came from splash screen
      final String? ratingLocalStoredData =
          spInstance.getString(SharedPreferenceConstants.dynamicRating);
      if (isCameFromSplash ||
          ratingLocalStoredData == null ||
          ratingLocalStoredData == "") {
        List<DynamicRating> newRateUsModel = [];

        // spRating data not null and not empty
        if (ratingLocalStoredData != null &&
            ratingLocalStoredData.isNotEmpty &&
            firebaseRatingDynamicModel.dynamicRating != null) {
          //  sp_rating string to model
          final RateUsDialogModel rateUsDialogSharedPrefList =
              RateUsDialogModel.fromJson(jsonDecode(ratingLocalStoredData));

          firebaseRatingDynamicModel.dynamicRating
              ?.forEach((remoteRatingRowData) {
            // Check JSON object wise Rating module name, match count and increment by value are matching...
            DynamicRating localRatingRowData = rateUsDialogSharedPrefList
                .dynamicRating!
                .firstWhere((localRatingRowData) {
              return localRatingRowData.module == remoteRatingRowData.module;
            },
                    orElse: () => DynamicRating(0, 0,
                        module: null, matchCount: 0, incrementBy: 0));
            if (localRatingRowData.module != null &&
                localRatingRowData.module == remoteRatingRowData.module &&
                (localRatingRowData.matchCount !=
                        remoteRatingRowData.matchCount ||
                    localRatingRowData.incrementBy !=
                        remoteRatingRowData.incrementBy)) {
              // change found
              DynamicRating data = DynamicRating(
                  // remote_match_count not equal local_match_count then reset local count with 0
                  (localRatingRowData.matchCount !=
                          remoteRatingRowData.matchCount)
                      ? 0
                      : localRatingRowData.localCount,
                  // 5 + 2 [ 7 ] , reset by 0 if change found
                  // remote_match_count not equal local_match_count then update local_match_count value
                  (localRatingRowData.matchCount !=
                          remoteRatingRowData.matchCount)
                      ? remoteRatingRowData.matchCount ?? 0 // 5 , 3 [ 3 ]
                      : localRatingRowData.matchCount ?? 0,
                  module: remoteRatingRowData.module,
                  matchCount: remoteRatingRowData.matchCount,
                  incrementBy: remoteRatingRowData.incrementBy);
              newRateUsModel.add(data);
            } else if (localRatingRowData.module != null &&
                localRatingRowData.module == remoteRatingRowData.module) {
              // change not found in match count and increment by count value
              DynamicRating data = DynamicRating(localRatingRowData.localCount,
                  localRatingRowData.localMatchCount,
                  module: localRatingRowData.module,
                  matchCount: localRatingRowData.matchCount,
                  incrementBy: localRatingRowData.incrementBy);
              newRateUsModel.add(data);
            } else {
              // New Rating us JSON module data found
              DynamicRating data = DynamicRating(
                  0, remoteRatingRowData.matchCount ?? 0,
                  module: remoteRatingRowData.module,
                  matchCount: remoteRatingRowData.matchCount,
                  incrementBy: remoteRatingRowData.incrementBy);
              newRateUsModel.add(data);
            }
          });

          /*for (var element in newRateUsModel) {
                print("\n****************************");
                print("Module:: ${element.module}");
                print("Match  :: ${element.matchCount}");
                print("increment:: ${element.incrementBy}");
                print("local:: ${element.localCount}");
                print("****************************");
              }*/

          RateUsDialogModel model =
              RateUsDialogModel(dynamicRating: newRateUsModel);
          spInstance.setString(
              SharedPreferenceConstants.dynamicRating, jsonEncode(model));

          spInstance.getString(SharedPreferenceConstants.dynamicRating);

          //printLog("sharedPrefRatingUSData:: $SharedPrefRatingUSData");
        } else {
          // if there is not any rating us data in shared preference
          spInstance.setString(SharedPreferenceConstants.dynamicRating,
              jsonEncode(firebaseRatingDynamicModel));
        }

        // [LOGIN VISIT] calculate total user visit after login in different date
        DynamicRatingCalculation.calculateUserVisitCountForRating();

        completer.complete(false);
      } else {
        completer.complete(false);
      }
    } catch (e) {
      printLog(e);
      completer.complete(true);
    }
    return completer.future;
  }

  // condition to show rating dialog or not
  static Future<bool> showRatingDialog() async {
    final completer = Completer<bool>();
    bool flag = false;
    try {
      // shared preference instance
      SharedPreferences spInstance = await SharedPreferences.getInstance();
      String? ratingLocalStoredData =
          spInstance.getString(SharedPreferenceConstants.dynamicRating);

      if (ratingLocalStoredData != null) {
        // String to model
        RateUsDialogModel rateUsDialogSharedPrefList =
            RateUsDialogModel.fromJson(jsonDecode(ratingLocalStoredData));

        if (rateUsDialogSharedPrefList.dynamicRating != null) {
          for (int i = 0;
              i < rateUsDialogSharedPrefList.dynamicRating!.length;
              i++) {
            if (rateUsDialogSharedPrefList.dynamicRating![i].localCount ==
                    rateUsDialogSharedPrefList
                        .dynamicRating![i].localMatchCount &&
                rateUsDialogSharedPrefList.dynamicRating![i].localMatchCount !=
                    0) {
              rateUsDialogSharedPrefList.dynamicRating![i].localMatchCount +=
                  rateUsDialogSharedPrefList.dynamicRating![i].incrementBy ?? 0;
              flag = true;
            } else if (rateUsDialogSharedPrefList.dynamicRating![i].localCount >
                rateUsDialogSharedPrefList.dynamicRating![i].localMatchCount) {
              rateUsDialogSharedPrefList.dynamicRating![i].localMatchCount =
                  rateUsDialogSharedPrefList.dynamicRating![i].localCount +
                      (rateUsDialogSharedPrefList
                              .dynamicRating![i].incrementBy ??
                          0);
              flag = true;
            }
          }
        }

        // set in shared preference with updated rating data
        spInstance.setString(SharedPreferenceConstants.dynamicRating,
            jsonEncode(rateUsDialogSharedPrefList));

        spInstance.getString(SharedPreferenceConstants.dynamicRating);

        // printLog("updatedSharedPref:: $updatedSharedPref");
      }
      completer.complete(flag);
    } catch (e) {
      printLog(e);
      completer.complete(false);
    }
    return completer.future;
  }

  //Increase local count according to module wise
  static updateRatingLocalCountByModuleName(String moduleName,
      [int? addedOccupationCount]) async {
    try {
      SharedPreferences spInstance = await SharedPreferences.getInstance();

      // read dynamic rating string from shared preference
      String? ratingData =
          spInstance.getString(SharedPreferenceConstants.dynamicRating);
      // debugPrint("<<<<<<<<<<<<");
      // debugPrint("sp_rating ::: $ratingData");
      // debugPrint("<<<<<<<<<<<<");
      if (ratingData != null || ratingData != "") {
        // string to rating model
        final RateUsDialogModel rateUsDialogList =
            RateUsDialogModel.fromJson(jsonDecode(ratingData!));
        // updating local count
        for (int i = 0; i < rateUsDialogList.dynamicRating!.length; i++) {
          if (moduleName == SharedPreferenceConstants.myOccupation &&
              rateUsDialogList.dynamicRating![i].module ==
                  SharedPreferenceConstants.myOccupation) {
            // module name is my occupation then we will update local count with added occupation length
            rateUsDialogList.dynamicRating![i].localCount =
                addedOccupationCount ?? 0;
            spInstance.setString(SharedPreferenceConstants.dynamicRating,
                jsonEncode(rateUsDialogList));
          } else if (rateUsDialogList.dynamicRating![i].module == moduleName) {
            rateUsDialogList.dynamicRating![i].localCount += 1;
            spInstance.setString(SharedPreferenceConstants.dynamicRating,
                jsonEncode(rateUsDialogList));
          }
        }

        // String? updateRating = spInstance.getString(PreferencesHelper.dynamicRating);
        // print(">>>>>>>>>>>>>>>>");
        // print("temp2::: $updateRating");
        // print(">>>>>>>>>>>>>>>>");
      }
    } catch (e) {
      printLog(e);
    }
  }

  // [LOGIN VISIT] calculate total user visit after login in different date
  static calculateUserVisitCountForRating() async {
    try {
      String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Last app open date
      String? localStoredDate =
          prefs.getString(SharedPreferenceConstants.userLoggedInOrSignInDate);

      // Dynamic rating JSON data from SharedPreference
      String? spDynamicRatingData =
          prefs.getString(SharedPreferenceConstants.dynamicRating);

      if (spDynamicRatingData != null) {
        RateUsDialogModel rateUsDialogList =
            RateUsDialogModel.fromJson(jsonDecode(spDynamicRatingData));

        for (int i = 0; i < rateUsDialogList.dynamicRating!.length; i++) {
          if (rateUsDialogList.dynamicRating![i].module ==
              SharedPreferenceConstants.loginVisit) {
            // if last login date and current date is match or not
            if (localStoredDate == null || localStoredDate == "") {
              rateUsDialogList.dynamicRating![i].localCount = 1;
            } else if (currentDate != localStoredDate) {
              rateUsDialogList.dynamicRating![i].localCount += 1;
            }

            // store dynamic rating model data into shared preference
            prefs.setString(SharedPreferenceConstants.dynamicRating,
                jsonEncode(rateUsDialogList));
            // store current date for login_visit count
            prefs.setString(SharedPreferenceConstants.userLoggedInOrSignInDate,
                currentDate);
          }
        }
      }
    } catch (e) {
      printLog(e);
    }
  }
}

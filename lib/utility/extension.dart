import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config.dart';

//To get API URL's data from firebase remote config
extension MapExtension on Map {
  String? getFirebaseUrl(String key) {
    Map data = this;
    // ignore: prefer_is_empty
    if (data.length < 0) {
      data = {};
    }
    if (data.containsKey(key)) {
      String startPoint = "", endPoint = "";
      String url = data[key];
      var arr = url.split("+");
      if (arr.length == 2) {
        startPoint = arr.first;
        endPoint = arr.last;
      } else if (arr.length == 1) {
        startPoint = arr.first;
        endPoint = "";
      }

      //TODO We can change the environment(LIVE/STAGING) for api from here
      var environment = FirebaseRemoteConfigController.shared.dynamicBaseUrl?.liveUrlList;
      var obj = environment?.where((element) => element.urlKey == startPoint).toList();
      if ((obj?.length ?? 0) > 0) {
        return "${obj?.first.urlValue}$endPoint";
      } else {
        return "";
      }
    } else {
      return "";
    }
  }
}

extension StringExtension on String {
  flag() {
    return toUpperCase().replaceAllMapped(
        RegExp(r'[A-Z]'),
            (match) =>
            String.fromCharCode((match.group(0)?.codeUnitAt(0) ?? 0) + 127397));
  }

  removeSquareBracketFromString() {
    if(this == "null"){
      return '';
    }
    return replaceAll('[', '').replaceAll(']', '');
  }
}
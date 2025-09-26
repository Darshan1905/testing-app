// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:in_app_update/in_app_update.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/features/dashboard/dashboard_repository.dart';
import 'package:occusearch/features/more_menu/model/more_app_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RxBloc()
class MoreMenuBloc extends RxBlocTypeBase {
  final _moreAppListValue = BehaviorSubject<List<ApplicationList>>();

  set setMoreAppList(List<ApplicationList> list) =>
      _moreAppListValue.sink.add(list);

  Stream<List<ApplicationList>> get getMoreAppListStream =>
      _moreAppListValue.stream;

  PackageInfo? packageInfo;

  final isNewVersionAvailable = BehaviorSubject<bool>.seeded(false);
 // bool isNewVersionAvailable =false; //true= new version available on playStore, false = new version not available

  Stream<bool> get getConditionAgree => isNewVersionAvailable.stream;
  Function(bool) get onClickConditionCheckbox => isNewVersionAvailable.sink.add;
  // Firebase Remote Config: to get More Apps details
  fetchMoreAppsDataFromRemoteConfig() async {
    List<ApplicationList> moreAppList = [];

    //read data from firebase
    String firebaseMoreAppsData = await FirebaseRemoteConfigController.shared
        .Data(key: FirebaseRemoteConfigConstants.keyMoreApps);

    MoreAppModel moreAppModel =
        MoreAppModel.fromJson(jsonDecode(firebaseMoreAppsData));
    if (moreAppModel.applicationList != null) {
      moreAppList = moreAppModel.applicationList!;
    } else {
      moreAppList = [];
    }
    setMoreAppList = moreAppList;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate(BuildContext context) async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        isNewVersionAvailable.sink.add(true);
      } else {
        isNewVersionAvailable.sink.add(false);
      }
    }).catchError((e) {
      printLog(e);
      isNewVersionAvailable.sink.add(false);
    });
  }

  checkAppUpdate(BuildContext context, String severity, String version,
      String desc) async {
    /*update app dialog for iPhone*/
    packageInfo = await PackageInfo.fromPlatform();
    var iPhoneVersion = "";
    String url = "https://itunes.apple.com/lookup?id=1619089046";
    BaseResponseModel result = await DashboardRepository.getAppVersion(url);

    if (result.statusCode == Constants.statusCodeForApiData) {
      if (result.data != null && result.data.isNotEmpty) {
        //print(result.body);
        iPhoneVersion = json.decode(result.data)['results'][0]['version'];
        if (iPhoneVersion.isNotEmpty) {
          if (packageInfo?.version.compareTo(iPhoneVersion) == -1) {
            isNewVersionAvailable.sink.add(true);
          } else {
            isNewVersionAvailable.sink.add(false);
          }
        }
      }
    }
  }

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  @override
  void dispose() {
  }

  launchURLBrowser(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("url not launch");
      throw 'Could not launch $url';
    }
  }

  String getSubscriptionType(String plan) {
    String planDetails = "";
    switch (plan) {
      case StringHelper.freePlan:
        planDetails = "7 days free trial";
        break;
      case StringHelper.miniPlan:
        planDetails = "15 days $plan";
        break;
      case StringHelper.premiumPlan:
        planDetails = "1 Month $plan";
        break;
      default:
        planDetails = "7 days free trial";
        break;
    }
    return planDetails;
  }
}

// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/features/contact_us/model/contact_us_model.dart';
import 'package:occusearch/features/contact_us/model/country_wise_branch_model.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/utility/platform_channels.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RxBloc()
class ContactUsBloc extends RxBlocTypeBase {
  List<CountryWiseBranch>? countryAndBranchList = [];

  //variable
  final allCountryBranchListSubject =
      BehaviorSubject<List<AussizzBranches>>(); //All Branches of Country list
  final countryWiseBranchListSubject =
      BehaviorSubject<List<CountryWiseBranch>>(); // Country Wise Branch list
  final countryWiseBranchModel =
      BehaviorSubject<CountryWiseBranch>(); // Country Wise Branch Model
  final countryModelListSubject = BehaviorSubject<List<CountryModel>>();
  final _countryCode = BehaviorSubject<String?>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false); //loader
  final branchLocationSubject = BehaviorSubject<List<dynamic>>();
  final nearestBranchSubject = BehaviorSubject<List<dynamic>>();

  // by clicking on any branch address we hold the index of branch list
  final selectedAddressCurrentIndex = BehaviorSubject<int>.seeded(
      0); // 0 = 0 index selected to show of any branch address yet
  //get lat long according to branch list index that was hold
  final selectedBranchIndexLatitude = BehaviorSubject<double>.seeded(0.0);
  final selectedBranchIndexLongitude = BehaviorSubject<double>.seeded(0.0);
  final selectedBranchStateName = BehaviorSubject<
      String?>(); // get selected company name according to branch detail list index
  final selectedBranchListAddress =
      BehaviorSubject<String?>(); //get selected address of the list

  // For listen once api called and map has been initialised
  StreamController<bool> initStreamController =
      StreamController<bool>.broadcast();

  //final selectedCountryIndex = BehaviorSubject<int>.seeded(0);

  //SET
  set setCountryCodeValue(countryCode) => _countryCode.sink.add(countryCode);

  set setStateNameBranchWise(name) => selectedBranchStateName.sink.add(name);

  set setAddress(address) => selectedBranchListAddress.sink.add(address);

  //GET country code value
  BehaviorSubject<String?> get getCountryCodeValue => _countryCode;

  //GET Country Wise Branch list
  Stream<List<CountryWiseBranch>> get getCountryWiseListStream =>
      countryWiseBranchListSubject.stream;

  //GET Country Wise Branch Model
  Stream<CountryWiseBranch> get getCountryWiseBranchModelStream =>
      countryWiseBranchModel.stream;

  //GET Country Branch State Name
  Stream<String?> get getSelectedBranchStateNameStream =>
      selectedBranchStateName.stream;

  Stream<double> get getSelectedBranchIndexLatitudeStream =>
      selectedBranchIndexLatitude.stream;

  Stream<double> get getSelectedBranchIndexLongitudeStream =>
      selectedBranchIndexLongitude.stream;

  Stream<bool> get loadingStream => _isLoadingSubject.stream;

  // Firebase realtime database for contact us
  getContactUsDataFromFirebaseRealtimeDB(List<Marker> markers, argValue) async {
    _isLoadingSubject.sink.add(true);

    final response = await FirebaseDatabaseController.getRealtimeData(
        key: FirebaseRealtimeDatabaseConstants.contactUsListString);
    if (response != null) {
      final contactUsData = jsonEncode(response);
      List<AussizzBranches> contactUsList = (jsonDecode(contactUsData) as List)
          .map<AussizzBranches>((json) => AussizzBranches.fromJson(json))
          .toList();
      allCountryBranchListSubject.add(contactUsList);

      //////////////////////////////////////////////////
      if (argValue.length > 0) {
        //store branch latitude and longitude for users live location
        branchLocationSubject.add(contactUsList.map((e) {
          return {
            "countryName": e.countryname,
            "companyName": e.companyname,
            "branchLatitude": e.latitude,
            "branchLongitude": e.longitude,
            "difference": Geolocator.distanceBetween(
                double.parse(argValue['userLatitude'].toString()),
                double.parse(argValue['userLongitude'].toString()),
                double.parse(e.latitude.toString()),
                double.parse(e.longitude.toString())),
            "userAddress": argValue['usersPlace'],
          };
        }).toList());

        if (branchLocationSubject.value.isNotEmpty) {
          branchLocationSubject.value
              .sort((a, b) => a['difference']!.compareTo(b['difference']));
        }

        var nearestLocationValue = branchLocationSubject.value.first;
        //IF USER CURRENT LOCATION COUNTRY IS AUSTRALIA OR INDIA
        // if (branchLocationSubject.value.first['userAddress'].country.toString().toUpperCase() == 'AUSTRALIA' || branchLocationSubject.value.first['userAddress'].country.toString().toUpperCase() == 'INDIA') {
        nearestBranchSubject.add(contactUsList.where(
          (item) {
            ///DONE: COMPANY NAME COMPARE
            return item.companyname == nearestLocationValue['companyName'];
          },
        ).toList());
        // printLog("newList==>${nearestBranchSubject.value}");
      }
      //////////////////////////////////////////////////

      setBranchListCountryWise(contactUsList);
      setLatLongCountryWise(markers);
      _isLoadingSubject.sink.add(false);
    } else {
      _isLoadingSubject.sink.add(false);
    }
  }

  //Set Branch Wise Country List
  void setBranchListCountryWise(List<AussizzBranches> contactUsListData) {
    try {
      contactUsListData
          .sort((a, b) => a.countryname!.compareTo(b.countryname!));

      for (int i = 0; i < contactUsListData.length; i++) {
        if (i == 0) {
          var branchList = getCountryBranch(
              contactUsListData[i].countryname!, contactUsListData);
          countryAndBranchList?.add(CountryWiseBranch(
              contactUsListData[i].countryname, "", branchList));
          countryWiseBranchListSubject.sink.add(countryAndBranchList!);
        } else if (i > 0 &&
            contactUsListData[i].countryname !=
                contactUsListData[i - 1].countryname) {
          var branchList = getCountryBranch(
              contactUsListData[i].countryname!, contactUsListData);
          countryAndBranchList?.add(CountryWiseBranch(
              contactUsListData[i].countryname, "", branchList));
          countryWiseBranchListSubject.sink.add(countryAndBranchList!);
        }
      }
      getCountryListJson();
    } catch (e) {
      printLog(e);
    }
  }

  // to add all markers of branches
  void setLatLongCountryWise(List<Marker> markers) {
    for (int i = 0; i < allCountryBranchListSubject.value.length; i++) {
      if (allCountryBranchListSubject.value[i].latitude != "" ||
          allCountryBranchListSubject.value[i].longitude != "") {
        double lat = double.parse(
            allCountryBranchListSubject.value[i].latitude ?? "0.0");
        double long = double.parse(
            allCountryBranchListSubject.value[i].longitude ?? "0.0");
        markers.add(Marker(
          markerId: MarkerId(
              allCountryBranchListSubject.value[i].companyid.toString()),
          position: LatLng(lat, long),
        ));
      }
    }
  }

  //Get Country Branch
  List<AussizzBranches>? getCountryBranch(
      String countryName, List<AussizzBranches> contactUsListData) {
    List<AussizzBranches> branchList = [];
    for (int j = 0; j < contactUsListData.length; j++) {
      if (countryName == contactUsListData[j].countryname) {
        branchList.add(contactUsListData[j]);
      }
    }
    return branchList;
  }

  void getCountryListJson() async {
    String prefCountryCode = getCountryCodeValue.value ?? "INDIA";

    String prefCountryName = "";

    //read data of country_list json from firebase
    String firebaseCountryData = await FirebaseRemoteConfigController.shared
        .Data(key: FirebaseRemoteConfigConstants.keyCountry);

    var jsonData = json.decode(firebaseCountryData);
    //converted model into dynamic list
    List<CountryModel> list = (jsonData as List)
        .map<CountryModel>((json) => CountryModel.fromJson(json))
        .toList();
    countryModelListSubject.sink.add(list);

    //USER'S LIVE LOCATION
    if (nearestBranchSubject.valueOrNull != null) {
      if (nearestBranchSubject.value.first != null) {
        prefCountryName = nearestBranchSubject.value.first.countryname
            .toString()
            .toUpperCase();
      }
    } else {
      for (int i = 0; i < list.length; i++) {
        if (prefCountryCode == list[i].code) {
          prefCountryName = list[i].name!.toUpperCase();
        }
      }
    }

    // Find the country code based on contact branch list to show country flag
    List<CountryWiseBranch> temp = countryAndBranchList ?? [];
    countryAndBranchList = [];
    for (var branchRow in temp) {
      CountryModel? countryFlag = list.firstWhere(
          (element) =>
              element.name!.toLowerCase().trim() ==
              branchRow.countryName!.toLowerCase().trim(),
          orElse: () => CountryModel());
      countryAndBranchList!.add(CountryWiseBranch(branchRow.countryName,
          countryFlag.code ?? "", branchRow.branchDataList));
    }

    for (int i = 0; i < countryAndBranchList!.length; i++) {
      if (prefCountryName == countryAndBranchList![i].countryName) {
        countryWiseBranchModel.value = countryAndBranchList![i];
      }
    }

    // If user country and branch address country miss-match,
    // we show default branch of INDIA country
    if (countryWiseBranchModel.valueOrNull == null ||
        (countryWiseBranchModel.value.branchDataList != null &&
            countryWiseBranchModel.value.branchDataList!.isEmpty)) {
      for (int i = 0; i < countryAndBranchList!.length; i++) {
        if ("INDIA" == countryAndBranchList![i].countryName) {
          countryWiseBranchModel.value = countryAndBranchList![i];
        }
      }
    }

    //to load lat long, 0 selected index with company name for first time when screen opens
    final data = nearestBranchSubject.valueOrNull != null
        ? nearestBranchSubject.value.first
        : countryWiseBranchModel.value.branchDataList![0];

    //DEFAULT SELECTED DEFAULT
    final currentAddressValueIndex = nearestBranchSubject.valueOrNull != null
        ? countryWiseBranchModel.value.branchDataList?.indexWhere((element) =>
            element.companyname == nearestBranchSubject.value.first.companyname)
        : 0;
    selectedAddressCurrentIndex.value = currentAddressValueIndex ?? 0;
    // selectedAddressCurrentIndex.value = 0;

    selectedBranchStateName.value = nearestBranchSubject.valueOrNull != null
        ? nearestBranchSubject.value.first.companyname
        : countryWiseBranchModel.value.branchDataList![0].companyname;
    selectedBranchIndexLatitude.value = double.parse(
        (data.latitude == null || data.latitude == "" || data.latitude == "0.0")
            ? "0.0"
            : data.latitude!);

    selectedBranchIndexLongitude.value = double.parse((data.longitude == null ||
            data.longitude == "" ||
            data.longitude == "0.0")
        ? "0.0"
        : data.longitude!);

    initStreamController.add(true);
  }

  //set latitude longitude according to list index
  setBranchAddressIndex(int index, AussizzBranches data) {
    selectedAddressCurrentIndex.value = index;
    selectedBranchIndexLatitude.value = double.parse(
        (data.latitude == null || data.latitude == "" || data.latitude == "0.0")
            ? "0.0"
            : data.latitude!);
    selectedBranchIndexLongitude.value = double.parse((data.longitude == null ||
            data.longitude == "" ||
            data.longitude == "0.0")
        ? "0.0"
        : data.longitude!);
  }

  onClickBranch(CountryWiseBranch data) {
    countryWiseBranchModel.value = data;

    //to load lat long, 0 selected index with company name change when country name changes
    selectedAddressCurrentIndex.value = 0;
    selectedBranchStateName.value =
        countryWiseBranchModel.value.branchDataList![0].companyname;
    selectedBranchIndexLongitude.value =
        double.parse(data.branchDataList![0].longitude.toString());
    selectedBranchIndexLatitude.value =
        double.parse(data.branchDataList![0].latitude.toString());
    initStreamController.add(true);
  }

  // Handle Social media click event
  handleSocialMediaClickEvent(SocialLinks socialData, BuildContext context) {
    switch (socialData.type) {
      case "FACEBOOK":
        Utility.openUrl(socialData.link ?? "");
        break;
      case "WHATSAPP":
        openWhatsapp(context, socialData.link ?? "");
        break;
      case "TELEGRAM":
        openTelegram(context, socialData.link ?? "");
        break;
      case "TWITTER":
        Utility.openUrl(socialData.link ?? "");
        break;
      case "INSTAGRAM":
        Utility.openUrl(socialData.link ?? "");
        break;
      case "TIKTOK":
        Utility.openUrl(socialData.link ?? "");
        break;
      case "LINKEDIN":
        Utility.openUrl(socialData.link ?? "");
        break;
      default:
        Utility.openUrl(socialData.link ?? "");
        break;
    }
  }

  onGmail(String url) async {
    if (Platform.isAndroid) {
      debugPrint("mail");
      launchUrlString("mailto:$url");
    } else {
      await launchUrlString('mailto:$url');
    }
  }

  openWhatsapp(BuildContext context, String mobile) async {
    try {
      if (mobile.isNotEmpty && mobile.contains("-")) {
        mobile = mobile.replaceAll("-", "");
      }
    } catch (e) {
      printLog(e);
    }

    var whatsappUrl = "whatsapp://send?phone=$mobile";
    if (await canLaunchUrlString(whatsappUrl)) {
      await launchUrlString(whatsappUrl);
    } else {
      Toast.show(
          message: StringHelper.whatsappNotFound,
          context,
          type: Toast.toastError,
          gravity: Toast.toastTop);
    }
  }

  openTelegram(BuildContext context, telegram) async {
    var telegramUrl = "https://t.me/$telegram";
    if (await launchUrl(Uri.parse(telegramUrl))) {
      await PlatformChannels.lunchUrl(telegramUrl);
    } else {
      Toast.show(
          message: StringHelper.telegramNotFound,
          context,
          gravity: Toast.toastTop);
    }
  }

  //FOR USER CURRENT LIVE LOCATION
  getCurrentLocation(NavigatorMode mode, BuildContext context) async {
    try {
      PermissionStatus status = await Permission.location.request();
      if (NetworkController.isInternetConnected) {
        if (status.isGranted) {
          Toast.show(context,
              message:
                  "Please wait until we fetch branches near your location.",
              gravity: Toast.toastTop,
              duration: 5,
              type: Toast.toastNormal);
          Position currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best);
          printLog("Get Location currentPosition==>$currentPosition");
          List<Placemark> placeMarks = await placemarkFromCoordinates(
              currentPosition.latitude, currentPosition.longitude);
          Placemark place = placeMarks[0];
          Map<String, dynamic> param = {
            'userLatitude': currentPosition.latitude,
            'userLongitude': currentPosition.longitude,
            'usersPlace': place
          };
          GoRoutesPage.go(
              mode: mode, moveTo: RouteName.contactUs, param: param);
        } else {
          GoRoutesPage.go(mode: mode, moveTo: RouteName.contactUs, param: {});
        }
      } else {
        Toast.show(context,
            message: StringHelper.internetConnection,
            gravity: Toast.toastTop,
            duration: 3,
            type: Toast.toastError);
      }
    } catch (e) {
      GoRoutesPage.go(mode: mode, moveTo: RouteName.contactUs, param: {});
    }
  }

  //For Contact us onTap from dashboard and more menu
  contactUsOnTap(BuildContext context) async {
    return await Geolocator.isLocationServiceEnabled()
        .then((isLocationEnabled) => {
              if (isLocationEnabled)
                {
                  printLog('Location enabled'),
                  getCurrentLocation(NavigatorMode.push, context),
                }
              else
                {
                  GoRoutesPage.go(
                    mode: NavigatorMode.push,
                    moveTo: RouteName.locationPermissionScreen,
                  ),
                  printLog('Location disabled')
                }
            });
  }

  @override
  void dispose() {
    allCountryBranchListSubject.close();
    countryWiseBranchListSubject.close();
    branchLocationSubject.close();
    countryWiseBranchModel.close();
    countryModelListSubject.close();
    nearestBranchSubject.close();

    // Close the initStreamController stream and reinit
    // new stream other it will not work when screen will reinit.
    initStreamController.close();
    initStreamController = StreamController<bool>.broadcast();
  }
}

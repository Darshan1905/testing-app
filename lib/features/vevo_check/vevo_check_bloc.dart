// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:occusearch/common_widgets/loading_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/country/model/country_model.dart';
import 'package:occusearch/features/vevo_check/model/passport_model.dart';
import 'package:occusearch/features/vevo_check/model/vevo_check_model.dart';
import 'package:occusearch/features/vevo_check/vevo_check_respository.dart';
import 'package:occusearch/utility/rating/dynamic_rating_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

@RxBloc()
class VevoCheckBloc extends RxBlocTypeBase {
  // variable
  final countryModelList = BehaviorSubject<List<CountryModel>?>();
  final isSelectedRefType =
      BehaviorSubject<bool>.seeded(true); //true=VGN number, false = TRN number
  final selectedReference = BehaviorSubject<String>.seeded("Visa Grant Number");

  final _vgnRefNumberValue = BehaviorSubject<String>();
  final _trnRefNumberValue = BehaviorSubject<String>();
  final _dateOfBirthValue = BehaviorSubject<String>();
  final _passportValue = BehaviorSubject<String>();
  final _countryDocumentValue = BehaviorSubject<String>();
  final selectedCountryStream = BehaviorSubject<CountryModel>(); //CountryModel
  final workPlaceValue = BehaviorSubject<String>();
  final workPlaceLinkValue = BehaviorSubject<String>();
  final _errorMsgValue = BehaviorSubject<String>();
  final loadingShare = BehaviorSubject<bool>.seeded(false);

  final _vevoCheckDetailsModel =
      BehaviorSubject<VevoVisaDetailModel?>(); //VevoVisaDetailModel

  //SET
  set setCountryModelList(List<CountryModel>? countryList) {
    countryModelList.sink.add(countryList);
  }

  set setIsSelectedRefType(isSelected) {
    isSelectedRefType.sink.add(isSelected);
    getIsSelectedReference();
  }

  set setCountryModel(CountryModel countryModel) =>
      selectedCountryStream.sink.add(countryModel); //CountryModel

  set setVevoCheckDetailsModel(VevoVisaDetailModel? vevoVisaDetailModel) =>
      _vevoCheckDetailsModel.sink
          .add(vevoVisaDetailModel); //VevoVisaDetailModel

  set setWorkPlaceValue(String workPlace) => workPlaceValue.sink.add(workPlace);

  set setWorkPlaceLinkValue(String workPlaceLink) =>
      workPlaceLinkValue.sink.add(workPlaceLink);

  //GET
  Stream<List<CountryModel>?> get getCountryModelList =>
      countryModelList.stream;

  Stream<bool> get getIsSelectedRefType => isSelectedRefType.stream;

  Stream<String> get getSelectedReference => selectedReference.stream;

  Stream<VevoVisaDetailModel?> get getVevoCheckDetailsModelStream =>
      _vevoCheckDetailsModel.stream; //VevoVisaDetailModel

  Stream<String> get getWorkPlaceValueStream => workPlaceValue.stream;

  Stream<String> get getWorkPlaceLinkValueStream => workPlaceLinkValue.stream;

  //On Value Change
  Function(String) get onChangeVGNNumber => _vgnRefNumberValue.sink.add;

  Function(String) get onChangeTRNNumber => _trnRefNumberValue.sink.add;

  Function(String) get onChangeDOBNumber => _dateOfBirthValue.sink.add;

  Function(String) get onChangePassportNumber => _passportValue.sink.add;

  Function(String) get onChangeCountryDocumentValue =>
      _countryDocumentValue.sink.add;

  //TextEditing Controller
  TextEditingController vgnEditingController = TextEditingController();
  TextEditingController trnEditingController = TextEditingController();
  TextEditingController dobEditingController = TextEditingController();
  TextEditingController passportEditingController = TextEditingController();
  TextEditingController countryEditingController = TextEditingController();

  getIsSelectedReference() {
    if (isSelectedRefType.value) {
      selectedReference.value = "Visa Grant Number";
    } else {
      selectedReference.value = "Transaction Reference Number";
    }
  }

  //Api call for vevo check
  Future<void> submitVisaDetails(BuildContext context,
      {required String strTransactionType,
      required String strVisaGrantNumber,
      required String strDOB,
      required String strPassportNumber}) async {
    try {
      await NetworkController.initialiseNetworkManager();
      if (NetworkController.isInternetConnected == false) {
        Toast.show(context,
            message: StringHelper.internetConnection,
            gravity: Toast.toastTop,
            type: Toast.toastError);
        return;
      }

      LoadingWidget.show();

      var params = {
        RequestParameterKey.transactionRefType: strTransactionType,
        RequestParameterKey.visaGrantNumber: strVisaGrantNumber,
        RequestParameterKey.dateofbirth: strDOB,
        RequestParameterKey.passportNumber: strPassportNumber.trim(),
        RequestParameterKey.countryIDF: countryEditingController.text,
      };

      var configTable =
          await ConfigTable.read(strField: ConfigFields.vevoCheckResponse);

      BaseResponseModel response =
          await VevoCheckRepository.getVevoCheckDetails(params);

      if (response.statusCode == 200 &&
          response.flag == true &&
          !(response.data is String && response.data.contains("<p>"))) {
        LoadingWidget.hide();
        CheckMyVisaModel model = CheckMyVisaModel.fromJson(response.data);

        if (model.flag == true && model.data != null) {
          //delete data from config table if already data exists in db table
          if (configTable != null) {
            ConfigTable.deleteConfigData(
                strField: ConfigFields.vevoCheckResponse);
          }

          // Store data in DB config table
          var configVevoCheckTable = ConfigTable(
              fieldName: ConfigFields.vevoCheckResponse,
              fieldValue: jsonEncode(response.data));
          await ConfigTable.insertTable(configVevoCheckTable.toJson());

          //to store data and fetch in Vevo Details Screen
          setVevoCheckDetailsModel = model.data;

          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.vevoCheckDetail,
              param: model.data);

          // increase local count of dynamic rating according to module into stored data of shared preference...
          DynamicRatingCalculation.updateRatingLocalCountByModuleName(
              SharedPreferenceConstants.vevoCheck);
        } else {
          _errorMsgValue.value = model.message
                      .toString()
                      .contains("TypeError") ||
                  model.message.toString().contains("Family_name")
              ? "Your entered details is not proper. please enter correct detail."
              : model.message.toString();
          Toast.show(
              message: _errorMsgValue.value,
              context,
              type: Toast.toastError,
              gravity: Toast.toastTop,
              duration: 3);
        }
      } else {
        LoadingWidget.hide();
        _errorMsgValue.value = "Failed to check Visa status, Please try again.";
        Toast.show(
            message: _errorMsgValue.value,
            context,
            type: Toast.toastError,
            gravity: Toast.toastTop,
            duration: 3);
      }
    } catch (e) {
      LoadingWidget.hide();
      _errorMsgValue.value = "Something went wrong";
      Toast.show(
          message: _errorMsgValue.value,
          context,
          type: Toast.toastError,
          gravity: Toast.toastTop,
          duration: 3);
      debugPrint(e.toString());
    }
  }

  // Return Vevo check API model
  Future<bool> setVevoResultModel(VevoVisaDetailModel? model) {
    _vevoCheckDetailsModel.value = model;
    splitStringLink();
    return Future.value(true);
  }

  //split the string and link from workplaceRights
  void splitStringLink() {
    if (_vevoCheckDetailsModel.valueOrNull == null) {
      setWorkPlaceValue = "";
      setWorkPlaceLinkValue = "";
      return;
    }
    try {
      String result = _vevoCheckDetailsModel.value!.workplaceRights.toString();
      if (result.isNotEmpty && result.contains("http")) {
        result = result.replaceAll("\n", "");
        setWorkPlaceValue = result.substring(0, result.indexOf("http"));
        setWorkPlaceLinkValue =
            result.substring(result.indexOf("http"), result.length);
      }
    } catch (e) {
      printLog(e);
    }
  }

  // Fetch Passport OCR Details API
  Future<bool> fetchOCRPassportAPI(
      BuildContext context, String imageBase64, String docType) async {
    final completer = Completer<bool>();
    LoadingWidget.show();
    try {
      final headers = {'Content-Type': 'application/json'};

      if (docType == "jpg" || docType == "jpeg") {
        docType = "image";
      }

      final data = {'data': imageBase64, 'type': docType};

      final params = data;

      Response? response =
          await VevoCheckRepository.fetchOCRPassport(params, headers);

      if (response.statusCode == 200 && response.data != null) {
        LoadingWidget.hide();

        PassportModel passportModel = PassportModel.fromJson(response.data);

        var data = {
          "docType": StringHelper.passport,
          "model": passportModel,
        };

        GoRoutesPage.go(
            mode: NavigatorMode.push,
            moveTo: RouteName.vevoCheckForm,
            param: data);
      } else {
        LoadingWidget.hide();
        _errorMsgValue.value =
            "The document is not clear enough to scan, Please try again.";
        completer.complete(false);
        Toast.show(
            message: _errorMsgValue.value,
            context,
            type: Toast.toastError,
            gravity: Toast.toastTop,
            duration: 3);
      }
    } catch (e) {
      LoadingWidget.hide();
      _errorMsgValue.value = e.toString();
      completer.complete(false);
      debugPrint(e.toString());
      Toast.show(
          message: "Server Error, Please try again",
          context,
          type: Toast.toastError,
          gravity: Toast.toastTop,
          duration: 3);
    }
    return completer.future;
  }

  // Fetch VRN OCR Details API
  Future<bool> fetchOCRVrnAPI(
      BuildContext context, String imageBase64, String docType) async {
    final completer = Completer<bool>();

    LoadingWidget.show();
    try {
      final headers = {'Content-Type': 'application/json'};
      final params = {'data': imageBase64, 'type': docType.toLowerCase()};

      Response? response =
          await VevoCheckRepository.fetchOCRVRN(params, headers);

      if (response.statusCode == 200 && response.data != null) {
        LoadingWidget.hide();

        dynamic visaGrantModel = response.data;

        dynamic jsonData;

        if (docType == "pdf") {
          jsonData = visaGrantModel[0];
        } else {
          jsonData = visaGrantModel;
        }

        var data = {
          "docType": StringHelper.vrnDOC,
          "model": jsonData,
          "type": docType
        };

        if (jsonData["passport_number"].toString().isNotEmpty ||
            jsonData["date_of_birth"].toString().isNotEmpty) {
          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.vevoCheckForm,
              param: data);
        } else {
          _errorMsgValue.value =
              "The document is not clear enough to scan, Please try again.";
          completer.complete(false);
          Toast.show(context,
              message: _errorMsgValue.value,
              gravity: Toast.toastTop,
              type: Toast.toastError,
              duration: 3);
        }
      } else {
        LoadingWidget.hide();
        _errorMsgValue.value =
            "The document is not clear enough to scan, Please try again.";
        completer.complete(false);
        Toast.show(context,
            message: _errorMsgValue.value,
            gravity: Toast.toastTop,
            type: Toast.toastError,
            duration: 3);
      }
    } catch (e) {
      LoadingWidget.hide();
      _errorMsgValue.value = e.toString();
      completer.complete(false);
      debugPrint(e.toString());
      Toast.show(context,
          message: "Server Error, Please try again",
          gravity: Toast.toastTop,
          type: Toast.toastError,
          duration: 3);
    }
    return completer.future;
  }

  Future<void> setSelectedCountry(
      String country, TextEditingController selectCountryController) async {
    try {
      if (country.isNotEmpty && countryModelList.valueOrNull != null) {
        for (int i = 0; i < countryModelList.value!.length; i++) {
          if (countryModelList.value![i].name.toString().toLowerCase() ==
              country.toString().toLowerCase()) {
            setCountryModel = countryModelList.value![i];
            countryEditingController.text = countryModelList.value![i].name!;
          }
        }
      }
    } catch (e) {
      printLog(e);
    }
  }

  @override
  void dispose() {
    isSelectedRefType.close();
    selectedReference.close();
    _vgnRefNumberValue.close();
    _trnRefNumberValue.close();
    _dateOfBirthValue.close();
    _passportValue.close();
    _countryDocumentValue.close();

    vgnEditingController.clear();
    trnEditingController.clear();
    dobEditingController.clear();
    passportEditingController.clear();
    countryEditingController.clear();
  }
}

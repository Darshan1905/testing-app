// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/fund_calculator/model/country_with_currency.dart';
import 'package:occusearch/features/fund_calculator/model/currency_symbole_rate.dart';
import 'package:occusearch/features/fund_calculator/model/firebase_currency_model.dart';
import 'package:occusearch/features/visa_fees/model/question_model.dart';
import 'package:occusearch/features/visa_fees/model/visa_fees_question_model.dart';
import 'package:occusearch/features/visa_fees/model/visa_payment_model.dart';
import 'package:occusearch/features/visa_fees/visa_fees_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'model/visa_fees_price_model.dart';
import 'model/visa_fees_table_model.dart';
import 'model/visa_subclass_model.dart';

@RxBloc()
class VisaFeesBloc extends RxBlocTypeBase {
  VisaFeesBloc() {
    _applicantListStream.listen((value) {
      calculateVisaFeesPrice();
    });
  }

  final userInfo = BehaviorSubject<UserInfoData?>();

  TextEditingController? _searchController;
  final _visaSubclassListSubject = BehaviorSubject<List<SubclassData>>();
  final _visaQuestionSubclassListSubject =
      BehaviorSubject<List<SubclassData>>.seeded([]);
  final loadingStream = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<SubclassData?> _selectedSubclass =
      BehaviorSubject<SubclassData>();

  final loadingShare = BehaviorSubject<bool>.seeded(false);
  final loadingEmail = BehaviorSubject<bool>.seeded(false);

  BehaviorSubject<List<SubclassData>> get getVisaSubclassList =>
      _visaSubclassListSubject;

  Stream<List<SubclassData>> get getVisaSubclassListStream =>
      _visaSubclassListSubject
          // .debounceTime(const Duration(milliseconds: 100))
          .transform(visaSubStreamTransformer);

  List<SubclassData> get getVisaQuestionSubclassList =>
      _visaQuestionSubclassListSubject.value;

  set setVisaQuestionSubclassList(List<SubclassData> list) =>
      _visaQuestionSubclassListSubject.sink.add(list);

  // SET
  set setSearchFieldController(controller) => _searchController = controller;

  set setSelectedSubClassData(SubclassData? model) =>
      _selectedSubclass.sink.add(model);

  //GET
  SubclassData? get getSelectedSubClassValue => _selectedSubclass.valueOrNull;

  //GET
  Stream<SubclassData?> get getSelectedSubClass => _selectedSubclass.stream;

  // SEARCH
  onSearch(query) {
    getVisaSubclassList.add(getVisaSubclassList.value);
  }

  // [SEARCH IN SUBCLASS LIST]
  StreamTransformer<
      List<SubclassData>,
      List<
          SubclassData>> get visaSubStreamTransformer =>
      StreamTransformer<List<SubclassData>, List<SubclassData>>.fromHandlers(
        handleData: (list, sink) {
          if ((_searchController!.text).isNotEmpty) {
            List<SubclassData> newList = (list).where(
              (item) {
                return item.name!
                    .toLowerCase()
                    .contains(_searchController!.text.toLowerCase());
              },
            ).toList();
            return sink.add(newList);
          } else {
            return sink.add(list);
          }
        },
      );

  // [Visa Subclass]
  Future<void> getVisaSubclassData(BuildContext context) async {
    try {
      loadingStream.sink.add(true);
      if (await shouldFetchVisaSubclassListFromRemote()) {
        if (false == await NetworkController.isConnected()) {
          loadingStream.sink.add(false);
          Toast.show(context,
              message: StringHelper.internetConnection,
              type: Toast.toastError,
              duration: 2);
          return;
        }
        final response = await FirebaseDatabaseController.getRealtimeData(
            key: FirebaseRealtimeDatabaseConstants.visaSubclassListString);
        if (response != null) {
          final visaSubclassData = jsonEncode(response);
          List<SubclassData> subclassList =
              (jsonDecode(visaSubclassData) as List)
                  .map<SubclassData>((json) => SubclassData.fromJson(json))
                  .toList();

          _visaSubclassListSubject.sink.add(subclassList
              .where((element) => element.type == 0 || element.type == 1)
              .toList());
          List<SubclassData> temp = subclassList
              .where((element) => element.type == 0 || element.type == 2)
              .toList();
          temp.insert(
              0,
              SubclassData(
                  name: StringHelper.defaultVisaSubclass, id: "0", type: 0));
          _visaQuestionSubclassListSubject.sink.add(temp);
          // INSERT DATA INTO SQFLITE DATABASE
          await VisaFeesRepository.insertVisaSubclassDataIntoDB(
              visaSubclassData);
          loadingStream.sink.add(false);
        } else {
          loadingStream.sink.add(false);
        }
      } else {
        loadingStream.sink.add(false);
      }
    } catch (e) {
      printLog("#VisaFeesBloc# $e");
      loadingStream.sink.add(false);
    }
  }

  // FETCH Visa Subclass data from Local Database
  Future<bool> shouldFetchVisaSubclassListFromRemote() async {
    /*check today's date with the date in database for visa subclass list sync.
    If date is mismatched, visa subclass list will be fetched from API and response will be saved(updated) in local database.
    If date is same, then visa subclass list will be fetched from db.*/

    var syncDate = await ConfigTable.read(
        strField: ConfigFields.configFieldVisaSubclassSyncDate);
    var configVisaSubclassData =
        await ConfigTable.read(strField: ConfigFields.configFieldVisaSubclass);

    if (syncDate?.fieldValue == Utility.getTodayDate() &&
        configVisaSubclassData?.fieldValue != null) {
      List<SubclassData> subclassList =
          (jsonDecode(configVisaSubclassData?.fieldValue.toString() ?? "")
                  as List)
              .map<SubclassData>((json) => SubclassData.fromJson(json))
              .toList();
      _visaSubclassListSubject.sink.add(subclassList
          .where((element) => element.type == 0 || element.type == 1)
          .toList());
      List<SubclassData> temp = subclassList
          .where((element) => element.type == 0 || element.type == 2)
          .toList();
      temp.insert(
          0,
          SubclassData(
              name: StringHelper.defaultVisaSubclass, id: "0", type: 0));
      _visaQuestionSubclassListSubject.sink.add(temp);
      return Future(() => false);
    } else {
      return Future(() => true);
    }
  }

  // **************  [VISA FEES APPLICANT LIST]  **************

  final applicantControllerCount = BehaviorSubject<int>();

  final _applicantListStream =
      BehaviorSubject<List<VisaQuestionApplicantModel>>();

  Stream<List<VisaQuestionApplicantModel>> get getApplicantListStream =>
      _applicantListStream.stream;

  List<VisaQuestionApplicantModel>? get getApplicantListValue =>
      _applicantListStream.valueOrNull;

  set setApplicantList(applicant) => _applicantListStream.sink.add(applicant);

  // [ADD/UPDATE] VISA APPLICANT
  addUpdateApplicant(VisaQuestionApplicantModel applicantModel, int index) {
    List<VisaQuestionApplicantModel>? applicantList;
    if (_applicantListStream.valueOrNull != null) {
      applicantList = _applicantListStream.valueOrNull;
    } else {
      return;
    }
    if (index == -1) {
      count = applicantModel.count;
      // -1 == add new applicant
      applicantList?.add(applicantModel);
    } else {
      // update applicant
      applicantList![index] = applicantModel;
    }
    setApplicantList = applicantList;
  }

  // [DELETE] APPLICANT
  deleteApplicant(int index, [PriceTableRowModel? priceModel]) {
    List<VisaQuestionApplicantModel>? applicantList;
    if (_applicantListStream.valueOrNull != null) {
      applicantList = _applicantListStream.valueOrNull;
    } else {
      return;
    }
    if (applicantList!.length > index) {
      if (priceModel != null) {
        applicantList
            .removeWhere((element) => element.title == priceModel.label);
      } else {
        applicantList.removeAt(index);
      }
    }
    setApplicantList = applicantList;
  }

  // **************  [SECONDARY & PRIMARY APPLICANT]  **************

  int count = 1;

  // [RETURN] NEW SECONDARY APPLICANT MODEL
  VisaQuestionApplicantModel secondaryApplicantQuestionModel() {
    int secondaryNo = count;
    /*if (_applicantListStream.valueOrNull != null) {
      if (getApplicantListValue != null && getApplicantListValue!.isNotEmpty) {
        secondaryNo = 1;
        count = 2;
      }
    }*/
    List<QuestionModel> list = [];
    VisaQuestionApplicantModel model = VisaQuestionApplicantModel();
    String headerTitle = "Secondary Applicant ${secondaryNo++}";
    for (var question in _secondaryQuestionListStream.valueOrNull ?? []) {
      model.title = headerTitle;
      model.count = secondaryNo;
      model.isPrimaryApplicant = false;
      list.add(QuestionModel(
          title: headerTitle,
          questionId: question.questionId,
          question: question.question ?? "",
          type: question.type,
          options: question.options,
          selectedOption: false,
          selectedSubclass: _visaQuestionSubclassListSubject.value.isNotEmpty
              ? _visaQuestionSubclassListSubject.value[0]
              : SubclassData()));
    }
    model.setQuestionList = list;
    return model;
  }

  final BehaviorSubject<List<QuestionModel>?> _primaryQuestionListStream =
      BehaviorSubject<List<QuestionModel>>();

  List<QuestionModel>? get getPrimaryApplicantQuesValue =>
      _primaryQuestionListStream.valueOrNull;

  set setPrimaryApplicantQuestionList(List<QuestionModel>? primaryApplicant) =>
      _primaryQuestionListStream.sink.add(primaryApplicant);

  // Secondary API Question List
  final BehaviorSubject<List<QuestionList>?> _secondaryQuestionListStream =
      BehaviorSubject<List<QuestionList>>();

  List<QuestionList>? get getSecondaryApplicantQuesValue =>
      _secondaryQuestionListStream.valueOrNull;

  set setSecondaryApplicantQuestionList(List<QuestionList>? primaryApplicant) =>
      _secondaryQuestionListStream.sink.add(primaryApplicant);

  final isLoadingQuestionAPI = BehaviorSubject<bool>.seeded(false);

  // [VISA QUESTION DETAILS API]
  Future<void> getVisaQuestionDetailAPI(
      BuildContext context, int applicant, VisaFeesBloc visaBloc) async {
    try {
      if (applicant == 2) {
        isLoadingQuestionAPI.sink.add(true);
      }
      var param =
          "visa_subclass_group_id=${getSelectedSubClassValue!.id}&applicant=$applicant";
      BaseResponseModel response =
          await VisaFeesRepository.getVisaQuestionDetails(param);
      printLog(
          "#VisaFeesBloc# @getVisaQuestionDetailAPI@ Response-$applicant :: ${response.data}");
      if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          response.flag == true) {
        VisaFeesQuestionModel model =
            VisaFeesQuestionModel.fromJson(response.data);
        if (model.flag == true &&
            model.data != null &&
            model.data!.isNotEmpty) {
          if (applicant == 1) {
            List<QuestionModel> list = [];
            for (var Q in model.data!) {
              list.add(QuestionModel(
                  title: "Primary Applicant",
                  questionId: Q.questionId,
                  question: Q.question ?? "",
                  type: Q.type,
                  options: Q.options,
                  selectedOption: false,
                  selectedSubclass: null));
            }
            _primaryQuestionListStream.sink.add(list);
          } else if (applicant == 2) {
            _secondaryQuestionListStream.sink.add(model.data!);
          }
        }
      } else {
        Utility.showToastErrorMessage(context, response.statusCode);
      }
      if (applicant == 2) {
        isLoadingQuestionAPI.sink.add(false);
        refreshApplicationList(visaBloc);
      }
    } catch (e) {
      printLog(e);
    }
  }

  void refreshApplicationList(VisaFeesBloc visaBloc) {
    List<VisaQuestionApplicantModel> applicantList = [];
    try {
      if (_primaryQuestionListStream.valueOrNull != null) {
        // [Primary Applicant]
        VisaQuestionApplicantModel model = VisaQuestionApplicantModel();
        model.title = "Primary Applicant";
        model.count = 0;
        model.isPrimaryApplicant = true;
        List<QuestionModel> qList = [];
        for (var question in _primaryQuestionListStream.valueOrNull ?? []) {
          qList.add(QuestionModel(
              title: model.title,
              questionId: question.questionId,
              question: question.question ?? "",
              type: question.type,
              options: question.options,
              selectedOption: question.selectedOption,
              selectedSubclass:
                  _visaQuestionSubclassListSubject.value.isNotEmpty
                      ? question.getSelectedVisaSubclass
                      : SubclassData()));
        }
        model.setQuestionList = qList;
        applicantList.add(model);
      }
      if (_secondaryQuestionListStream.valueOrNull != null) {
        // [Secondary Applicant]
        applicantList.add(secondaryApplicantQuestionModel());
      }
      _applicantListStream.sink.add(applicantList);
      if (applicantList.isEmpty) {
        GoRoutesPage.go(
            mode: NavigatorMode.replace,
            moveTo: RouteName.visaFeesDetail,
            param: visaBloc);
      }
    } catch (e) {
      printLog(e);
    }
  }

  //  ************************  [VISA PRICE]  *************************
  final _visaPriceDetail = BehaviorSubject<List<PriceDataModel>?>();
  final visaPriceSubclass = BehaviorSubject<List<PriceVisasubclassModel>?>();
  final visaPriceSubclassIndex = BehaviorSubject<int>.seeded(0);
  final _visaNotesDetail = BehaviorSubject<List<NotesDataModel>?>();
  final _isVisaPriceAAPILoading = BehaviorSubject<bool>();

  setPriceSubclassIndex(int index) {
    visaPriceSubclassIndex.sink.add(index);
    calculateVisaFeesPrice();
  }

  Future<void> getVisaPriceAPI(BuildContext context) async {
    _isVisaPriceAAPILoading.value = true;
    String param = "visa_subclass_group_id=${getSelectedSubClassValue!.id}";
    BaseResponseModel response =
        await VisaFeesRepository.getVisaPriceDio(param);
    if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        response.flag == true) {
      VisaFeesPriceModel model = VisaFeesPriceModel.fromJson(response.data);
      if (model.flag == true && model.data != null) {
        // Price model
        if (model.data!.price != null) {
          _visaPriceDetail.value = model.data!.price;
        } else {
          _visaPriceDetail.value = null;
        }
        // Visa subclass model
        if (model.data!.visasubclass != null) {
          visaPriceSubclass.value = model.data!.visasubclass;
        } else {
          visaPriceSubclass.value = null;
        }
        // Notes
        if (model.data!.notes != null) {
          _visaNotesDetail.value = model.data!.notes;
        } else {
          _visaNotesDetail.value = null;
        }
      } else {
        _visaPriceDetail.value = null;
        visaPriceSubclass.value = null;
        _visaNotesDetail.value = null;
      }
    } else {
      _visaPriceDetail.value = null;
      visaPriceSubclass.value = null;
      _visaNotesDetail.value = null;
      Utility.showToastErrorMessage(context, response.statusCode);
    }
    _isVisaPriceAAPILoading.value = false;
    // calculate the visa price
    calculateVisaFeesPrice();
  }

  //  ************************  [VISA FEES PRICE CALCULATION]  *************************

  List<VisaFeesPriceTableModel> _visaFeesPriceList = [];

  get getVisaFeesPriceTableList => _visaFeesPriceList;

  final selectedVisaFeesPriceTableModel =
      BehaviorSubject<VisaFeesPriceTableModel>();

  void calculateVisaFeesPrice() {
    try {
      String currencyShortName = "AUD";
      double currencyRate = 1; // Australian dollar

      CountryWithCurrencyModel? selectedCurrencyModel =
          selectedCountrySubject.valueOrNull;
      if (selectedCurrencyModel != null) {
        currencyShortName = selectedCurrencyModel.symbolCode ?? "AUD";
        currencyRate = selectedCurrencyModel.rate;
      }

      _visaFeesPriceList = [];
      if (_visaPriceDetail.valueOrNull != null) {
        if (visaPriceSubclass.valueOrNull != null) {
          for (var visaClass in visaPriceSubclass.valueOrNull ?? []) {
            List<PriceTableRowModel> tableRow = [];
            double subTotal = 0.0;
            double surcharges = 0.0;
            int nonIntCharge = 0;
            int subsequentCharge = 0;
            String surchargesImage = selectedPaymentMethod.valueOrNull != null
                ? selectedPaymentMethod.value?.vcIconPath ?? ""
                : "";
            double surchargesPercentage =
                selectedPaymentMethod.valueOrNull != null
                    ? selectedPaymentMethod.value?.charges ?? 0
                    : 0;
            double total = 0.0;
            List<PriceDataModel> priceListByVisaSubclass = [];
            for (var price in _visaPriceDetail.valueOrNull ?? []) {
              if (price.visaSubclassId == visaClass.visaSubclassId) {
                priceListByVisaSubclass.add(price);
              }
            }
            PriceDataModel priceModel = priceListByVisaSubclass[0];
            // ****************************************************
            // ************   [Primary Applicant]    **************
            // ****************************************************
            int isOnshore = 0;
            tableRow.add(PriceTableRowModel(
                label: "Main Applicant", feesAud: "", fees: 0, sequence: 0));
            if (getApplicantListValue != null &&
                (getApplicantListValue ?? []).isNotEmpty &&
                priceListByVisaSubclass.isNotEmpty) {
              if (getApplicantListValue![0].isPrimaryApplicant == true) {
                for (var question
                    in getApplicantListValue![0].questionList ?? []) {
                  // [QUESTION - 3]
                  if (question.questionId == "3") {
                    if (question.selectedOption) {
                      isOnshore = 1;
                      priceModel = priceListByVisaSubclass[0];
                    } else if (!question.selectedOption) {
                      priceModel = priceListByVisaSubclass[1];
                    }
                  }
                  // [QUESTION - 2]
                  if (question.questionId == "2") {
                    if (!question.selectedOption) {
                      nonIntCharge = priceModel.nonIntAppCharge ?? 0;
                    } else {
                      nonIntCharge = 0;
                    }
                  }
                  // [QUESTION - 4]
                  if (question.questionId == "4") {
                    if (question.selectedSubclass != null &&
                        question.selectedSubclass!.id != "0" &&
                        isOnshore == 1) {
                      subsequentCharge =
                          priceModel.subsequentTempAppCharge ?? 0;
                    } else {
                      subsequentCharge = 0;
                    }
                  }
                }
              }
            }
            // BASE APPLICATION FEES
            double basePrice = double.parse(
                ((priceModel.mainAppCharge ?? 0) * currencyRate)
                    .toStringAsFixed(2));
            tableRow.add(PriceTableRowModel(
                label: "Base Application Fee",
                feesAud:
                    "$currencyShortName ${((priceModel.mainAppCharge ?? 0) * currencyRate).toStringAsFixed(2)}",
                fees: basePrice,
                sequence: 1));
            subTotal = subTotal + (priceModel.mainAppCharge ?? 0);

            // SUBSEQUENT TEMP ENTRY FEE
            if (subsequentCharge > 0) {
              tableRow.add(
                PriceTableRowModel(
                    label: "Subsequent Temp Entry Fee",
                    feesAud: "$currencyShortName $subsequentCharge",
                    fees: double.parse(
                        (subsequentCharge * currencyRate).toStringAsFixed(2)),
                    sequence: 2),
              );
              subTotal = subTotal + subsequentCharge;
            }

            // ****************************************************
            // ***********   [Secondary Applicant]    *************
            // ****************************************************

            if (getApplicantListValue != null &&
                (getApplicantListValue ?? []).isNotEmpty) {
              for (VisaQuestionApplicantModel secondaryApplicant
                  in getApplicantListValue ?? []) {
                // to ignore primary applicant
                if (secondaryApplicant.isPrimaryApplicant) continue;

                tableRow.add(PriceTableRowModel(
                    label: secondaryApplicant.getTitle,
                    feesAud: "",
                    fees: 0,
                    sequence: 0));
                int alreadyHavingVisa = 0;
                for (QuestionModel question
                    in secondaryApplicant.getQuestionList) {
                  if (question.questionId == "5") {
                    if (question.selectedOption) {
                      alreadyHavingVisa = 1;
                      priceModel = priceListByVisaSubclass[0];
                    } else if (!question.selectedOption) {
                      priceModel = priceListByVisaSubclass[1];
                    }
                  }
                }

                for (QuestionModel question
                    in secondaryApplicant.getQuestionList) {
                  // [QUESTION - 1]
                  if (question.questionId == "1") {
                    if (question.selectedOption) {
                      // Base Application Fees
                      tableRow.add(PriceTableRowModel(
                          label: "Base Application Fee",
                          feesAud:
                              "$currencyShortName ${((priceModel.subAppChargeAbove18 ?? 0) * currencyRate).toStringAsFixed(2)}",
                          fees: double.parse(
                              ((priceModel.subAppChargeAbove18 ?? 0) *
                                      currencyRate)
                                  .toStringAsFixed(2)),
                          sequence: 1));
                      subTotal =
                          subTotal + (priceModel.subAppChargeAbove18 ?? 0);
                    } else if (!question.selectedOption) {
                      // Base Application Fees
                      tableRow.add(PriceTableRowModel(
                          label: "Base Application Fee",
                          feesAud:
                              "$currencyShortName ${((priceModel.subAppChargeBelow18 ?? 0) * currencyRate).toStringAsFixed(2)}",
                          fees: double.parse(
                              ((priceModel.subAppChargeBelow18 ?? 0) *
                                      currencyRate)
                                  .toStringAsFixed(2)),
                          sequence: 1));
                      subTotal =
                          subTotal + (priceModel.subAppChargeBelow18 ?? 0);
                    }
                  }
                  // [QUESTION - 5]
                  if (question.questionId == "5") {
                    if (question.selectedOption) {
                      alreadyHavingVisa = 1;
                    }
                  }
                  // [QUESTION - 8]
                  if (question.questionId == "8") {
                    if (question.selectedSubclass != null &&
                        question.selectedSubclass!.id != "0" &&
                        alreadyHavingVisa == 1) {
                      subsequentCharge =
                          priceModel.subsequentTempAppCharge ?? 0;
                      tableRow.add(PriceTableRowModel(
                          label: "Subsequent Temp Entry Fee",
                          feesAud:
                              "$currencyShortName ${((priceModel.subsequentTempAppCharge ?? 0) * currencyRate).toStringAsFixed(2)}",
                          fees: double.parse(
                              ((priceModel.subsequentTempAppCharge ?? 0) *
                                      currencyRate)
                                  .toStringAsFixed(2)),
                          sequence: 2));
                      subTotal =
                          subTotal + (priceModel.subsequentTempAppCharge ?? 0);
                    }
                  }
                }
              }
            }

            // ****************************************************
            // ***********   [ Total and Surcharge]    ************
            // ****************************************************
            surcharges = (subTotal * surchargesPercentage) / 100;
            total = subTotal + surcharges + nonIntCharge;

            List<String> visaNoteList = [];
            String refNotes = priceModel.ref ?? "";
            if (refNotes.isNotEmpty && _visaNotesDetail.valueOrNull != null) {
              refNotes = refNotes.replaceAll(" ", "");
              List<String> notes = refNotes.split("&");
              for (var singleNote in _visaNotesDetail.valueOrNull!) {
                if (notes.contains(singleNote.code!.trim())) {
                  visaNoteList.add(singleNote.note ?? "");
                }
              }
            } else {
              visaNoteList = [];
            }

            _visaFeesPriceList.add(VisaFeesPriceTableModel(
                visaSubclassName: visaClass.visaSubclass ?? "",
                subTotal:
                    double.parse((subTotal * currencyRate).toStringAsFixed(2)),
                surchargesPercentage: surchargesPercentage,
                surcharges: double.parse(
                    (surcharges * currencyRate).toStringAsFixed(2)),
                nonInternetCharge: double.parse(
                    (nonIntCharge * currencyRate).toStringAsFixed(2)),
                total: double.parse((total * currencyRate).toStringAsFixed(2)),
                priceTable: tableRow,
                currencyShortCode: currencyShortName,
                surchargeImage: surchargesImage,
                notesList: visaNoteList,
                currencyRate: currencyRate));
          } // END Visa sub class Loop
        }

        // Here we set default category for visa price table for 1st time
        if (_visaFeesPriceList.isNotEmpty &&
            selectedVisaFeesPriceTableModel.valueOrNull == null) {
          selectedVisaFeesPriceTableModel.value = _visaFeesPriceList[0];
        } else {
          if (visaPriceSubclass.value != null &&
              visaPriceSubclass.value!.isNotEmpty) {
            for (var visaCategoryRow in _visaFeesPriceList) {
              if (visaPriceSubclass.value != null &&
                  visaPriceSubclass
                          .value![visaPriceSubclassIndex.value].visaSubclass ==
                      visaCategoryRow.visaSubclassName) {
                selectedVisaFeesPriceTableModel.value = visaCategoryRow;
              }
            }
          }
        }
      }
    } catch (e) {
      printLog(e);
    }
  }

  //  ************************  [PAYMENT GATEWAY]  *************************
  final paymentMethodList = BehaviorSubject<List<PaymentMethodData>>();
  final selectedPaymentMethod = BehaviorSubject<PaymentMethodData?>();

  set setPaymentMethodList(List<PaymentMethodData> list) {
    paymentMethodList.value = list;
  }

  List<PaymentMethodData> get getPaymentMethodList => paymentMethodList.value;

  onClickPaymentMethod(PaymentMethodData data) {
    selectedPaymentMethod.value = data;
    calculateVisaFeesPrice();
  }

  Stream<PaymentMethodData?> get getSelectedPaymentData =>
      selectedPaymentMethod.stream;

  // [PAYMENT METHOD TYPE API]
  Future<void> getVisaPaymentMethodListAPI() async {
    BaseResponseModel response =
        await VisaFeesRepository.getVisaPaymentMethodListDio();
    if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        response.flag == true &&
        response.flag == true) {
      // print(result.body);
      VisaPaymentModel model = VisaPaymentModel.fromJson(response.data);
      if (model.flag == true && model.data != null) {
        setPaymentMethodList = model.data!;
        selectedPaymentMethod.value = getPaymentMethodList[0];
      } else {
        setPaymentMethodList = [];
        selectedPaymentMethod.value = null;
      }
    } else {
      setPaymentMethodList = [];
      selectedPaymentMethod.value = null;
    }
  }

  //  ************************  [CURRENCY]  *************************
  final searchCountryCodeList =
      BehaviorSubject<List<CountryWithCurrencyModel>>();
  final countryWithCurrencyList =
      BehaviorSubject<List<CountryWithCurrencyModel>>();
  final selectedCountrySubject = BehaviorSubject<CountryWithCurrencyModel>();

  // Set
  TextEditingController? countrySearchController;

  set setSearchCountryFieldController(controller) =>
      countrySearchController = controller;

  // Get
  Stream<List<CountryWithCurrencyModel>> get getCountryListStream =>
      countryWithCurrencyList.transform(streamTransformer);

  Stream<CountryWithCurrencyModel> get selectedCountryStream =>
      selectedCountrySubject.stream;

  CountryWithCurrencyModel? get getSelectedCountry =>
      selectedCountrySubject.stream.valueOrNull;

  BehaviorSubject<List<CountryWithCurrencyModel>> get getCountryList =>
      countryWithCurrencyList;

  Function(CountryWithCurrencyModel) get onChangeCountry =>
      selectedCountrySubject.sink.add;

  // onChange country selection
  set setDefaultSelectedCountry(country) {
    selectedCountrySubject.value = country;
  }

  set setSelectedCountry(country) {
    // "Rate for selected country is not available."
    selectedCountrySubject.value = country;
    calculateVisaFeesPrice();
  }

  // set CountryWithCurrencyModel list
  set setCountryWithCurrencyList(List<CountryWithCurrencyModel> list) {
    countryWithCurrencyList.value = list;
  }

  // country search
  onCountrySearch(query) {
    getCountryList.add(getCountryList.value);
  }

  clearCountrySearch() {
    setCountryWithCurrencyList = searchCountryCodeList.value;
  }

  // Find the matching data on Search Text
  StreamTransformer<List<CountryWithCurrencyModel>,
          List<CountryWithCurrencyModel>>
      get streamTransformer => StreamTransformer<List<CountryWithCurrencyModel>,
              List<CountryWithCurrencyModel>>.fromHandlers(
            handleData: (list, sink) {
              if ((countrySearchController?.text)!.isNotEmpty) {
                List<CountryWithCurrencyModel> newList = list.where(
                  (item) {
                    double inflationRate =
                        (item.rate != 0.0) ? 1.0 / item.rate : item.rate;
                    if (item.rate != 0.0 && inflationRate >= 0.0009) {
                      return item.symbolName!.toLowerCase().contains(
                              countrySearchController!.text.toLowerCase()) ||
                          item.symbolCode!.toLowerCase().contains(
                              countrySearchController!.text.toLowerCase());
                    } else {
                      return false;
                    }
                  },
                ).toList();
                return sink.add(newList);
              } else {
                return sink.add(list);
              }
            },
          );

  // Firebase Remote Config: for Country detail
  setupRemoteConfigForCountryList() async {
    String firebaseCountryData = await FirebaseRemoteConfigController.shared
        .Data(key: FirebaseRemoteConfigConstants.keyCountry);
    var jsonData = json.decode(firebaseCountryData);
    List<CountryWithCurrencyModel> countryList = (jsonData)
        .map<CountryWithCurrencyModel>((json) =>
            CountryWithCurrencyModel.fromJson(json as Map<String, dynamic>))
        .toList();

    /// read firebase database to get country wise currency    if (countryList.isNotEmpty) {
    final response = await FirebaseDatabaseController.getRealtimeData(
        key: FirebaseRealtimeDatabaseConstants.currencyListString);
    if (response != null) {
      final data = jsonEncode(response);
      CurrencyList model = CurrencyList.fromJson(jsonDecode(data));
      List<CurrencySymbolRateModel> currencySymbolRateModel = [];
      model.rates.forEach((key, value) {
        currencySymbolRateModel.add(
            CurrencySymbolRateModel(key.toString(), double.parse("$value")));
      });
      // add Currency Rate in country model
      for (var countryElement in countryList) {
        currencySymbolRateModel.any((currencyElement) {
          if (currencyElement.symbol == countryElement.symbolCode) {
            countryElement.rate = currencyElement.rate ?? 0.0;
            return true;
          } else {
            return false;
          }
        });
      }

      CountryWithCurrencyModel? defaultCurrency =
          countryList.firstWhere((element) => element.symbolCode == "AUD");
      setDefaultSelectedCountry = defaultCurrency;

      // set country list with currency rate
      setCountryWithCurrencyList = countryList;
      searchCountryCodeList.value = countryList;
    } else {
      setCountryWithCurrencyList = [];
      searchCountryCodeList.value = [];
    }
  }

  sendEmailWithTemplate(BuildContext context, String filename, String file,
      FirebaseFirestore fireStoreDb, String? email, String name) async {
    loadingEmail.sink.add(true);
    // LoadingWidget.show();
    String docId = "";
    var ref = fireStoreDb.collection(ConfigFields.configFieldEmails).doc();
    docId = ref.id;
    ref.set({
      "to": email,
      "template": {
        "name": StringHelper.visaFeesPdfTemplate,
        "data": {
          "subject": StringHelper.occusearchVisaFeesSubject,
          "username": name,
          "name": name,
          "filename": filename,
          "content": file,
          "encoding": 'base64',
        }
      }
    }).then((value) {
      handleResult(context, docId);
    });
  }

  Future<void> handleResult(BuildContext dialogContext, id) async {
    FirebaseFirestore.instance
        .collection(ConfigFields.configFieldEmails)
        .doc(id)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        Map<String, dynamic>? data = event.get("delivery");
        String status = data!["state"];
        printLog(data["state"]);

        if (status == ConfigFields.configFieldSuccess) {
          loadingEmail.sink.add(false);
          // LoadingWidget.hide();
          Toast.show(dialogContext,
              message: "Visa fees report pdf sent, Please check your email.",
              gravity: Toast.toastTop,
              type: Toast.toastSuccess,
              duration: 2);
        } else if (status == ConfigFields.configFieldError) {
          loadingEmail.sink.add(false);
          // LoadingWidget.hide();
          Toast.show(
              message: StringHelper.emailSendFailedMessage,
              dialogContext,
              gravity: Toast.toastTop,
              type: Toast.toastError,
              duration: 2);
        }
      }
    });
  }

  @override
  void dispose() {
    _visaSubclassListSubject.close();
    _visaQuestionSubclassListSubject.close();
    loadingStream.close();
    _searchController?.dispose();
    applicantControllerCount.close();
    _primaryQuestionListStream.close();
    _secondaryQuestionListStream.close();
    selectedPaymentMethod.close();
  }
}

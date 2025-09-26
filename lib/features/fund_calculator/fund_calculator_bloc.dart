// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/firebase/remote_config/firebase_remote_config_constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/fund_calculator/model/country_with_currency.dart';
import 'package:occusearch/features/fund_calculator/model/currency_symbole_rate.dart';
import 'package:occusearch/features/fund_calculator/model/firebase_currency_model.dart';
import 'package:occusearch/features/fund_calculator/model/fund_calculator_question_model.dart';
import 'package:occusearch/features/fund_calculator/model/summary_chart_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

@RxBloc()
class FundCalculatorBloc extends RxBlocTypeBase {
  FundCalculatorQuestionModel? _fundCalcQuestionData;
  CountryWithCurrencyModel? selectedCurrencyData;
  CountryWithCurrencyModel? defaultCurrency; // default currency

  /////SEARCH COUNTRY FOR SUMMARY PAGE [COUNTRY LIST-- CURRENCY] ////////////
  final searchCountryCodeList =
      BehaviorSubject<List<CountryWithCurrencyModel>>();
  final countryWithCurrencyList =
      BehaviorSubject<List<CountryWithCurrencyModel>>();

  final selectedCountrySubject = BehaviorSubject<CountryWithCurrencyModel>();

  // COUNTRY SEARCH CONTROLLER
  TextEditingController? countrySearchController;

  set setSearchFieldController(controller) =>
      countrySearchController = controller;

  set setCountryList(List<CountryWithCurrencyModel> list) =>
      countryWithCurrencyList.sink.add(list);

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

  // Search
  onSearch(query) {
    getCountryList.add(getCountryList.value);
  }

  // onChange country selection
  set setSelectedCountry(country) {
    selectedCountrySubject.value = country;
  }

  //set CountryWithCurrencyModel list
  set setCountryWithCurrencyList(List<CountryWithCurrencyModel> list) {
    countryWithCurrencyList.value = list;
  }

  clearSearch() {
    setCountryWithCurrencyList = searchCountryCodeList.value;
  }

  // Find the matching data on Search Text
  StreamTransformer<List<CountryWithCurrencyModel>,
          List<CountryWithCurrencyModel>>
      get streamTransformer => StreamTransformer<List<CountryWithCurrencyModel>,
              List<CountryWithCurrencyModel>>.fromHandlers(
            handleData: (list, sink) {
              if ((countrySearchController!.text).isNotEmpty) {
                List<CountryWithCurrencyModel> newList = list.where(
                  (item) {
                    return item.symbolName!.toLowerCase().contains(
                            countrySearchController!.text.toLowerCase()) ||
                        item.symbolCode!.toLowerCase().contains(
                            countrySearchController!.text.toLowerCase());
                  },
                ).toList();
                return sink.add(newList);
              } else {
                return sink.add(list);
              }
            },
          );

  ///////////////////////////////////////////////////////////////

  final spouseToggle = BehaviorSubject<bool>.seeded(false);

  // ############   [START] FUND CALCULATOR   ############

  // CURRENT INDEX
  final _currentIndex = BehaviorSubject<int>.seeded(0);

  Stream<int> get getCurrentIndex => _currentIndex.stream;

  int get getCurrentIndexValue => _currentIndex.value;

  set setCurrentIndex(index) => _currentIndex.sink.add(index);

  // CURRENT SELECTED QUESTION
  final _currentQuestionModelStream =
      BehaviorSubject<List<FundCalculatorQuestion>>();

  Stream<List<FundCalculatorQuestion>> get currentQuestion =>
      _currentQuestionModelStream.stream;

  set setCurrentQuestion(List<FundCalculatorQuestion> questionList) =>
      _currentQuestionModelStream.sink.add(questionList);

  // FUND CALCULATOR QUESTION LIST
  final _fundCalculatorQuestionStream =
      BehaviorSubject<List<FundCalculatorQuestion>>();

  Stream<List<FundCalculatorQuestion>> get getFundCalculatorListStream =>
      _fundCalculatorQuestionStream.stream;

  get getFundCalculatorListStreamValue =>
      _fundCalculatorQuestionStream.stream.valueOrNull;

  double totalFundAmount() {
    double totalAmount = 0.0;
    if (_fundCalculatorQuestionStream.valueOrNull != null) {
      _fundCalculatorQuestionStream.valueOrNull?.forEach((question) {
        totalAmount += question.answerAmount;
      });
    }
    return totalAmount;
  }

  // ############   [END] FUND CALCULATOR   ############

  // FUND CALCULATOR + OTHER LIVING SUMMARY CHART DATA LIST
  final _summaryChartStream = BehaviorSubject<List<SummaryChartData>>();

  get getSummaryChartList => _summaryChartStream.stream;

  set setSummaryChartList(list) => _summaryChartStream.sink.add(list);

  // SET

  // current showing question category
  String currentCategory = "";
  int noOfChildren = 0;

  // current question answer amount
  double _selectedQuesAmount = 0.0;
  double selectedQuesAmountWithCurrency = 0.0;

  double totalLivingCostAmount = 0;

  List<LivingCostSummaryData> livingCostSummary = [];

  set setCurrentCategory(String category) {
    currentCategory = category;
  }

  // ############   OTHER LIVING   ############

  //OTHER LIVING QUESTION LIST

  final _currentOtherLivingQuestionStream =
      BehaviorSubject<List<OtherLivingQuestion>>();

  Stream<List<OtherLivingQuestion>> get currentOtherLivingQuestion =>
      _currentOtherLivingQuestionStream.stream;

  set setOtherLivingCurrentQuestion(List<OtherLivingQuestion> questionList) =>
      _currentOtherLivingQuestionStream.sink.add(questionList);

  final _otherLivingCostModelStream =
      BehaviorSubject<List<OtherLivingQuestion>>();

  Stream<List<OtherLivingQuestion>> get getLivingCurrentQuestionStream =>
      _otherLivingCostModelStream.stream;

  set setOtherLivingListStream(data) =>
      _otherLivingCostModelStream.sink.add(data);

  get otherLivingListStreamValue =>
      _otherLivingCostModelStream.stream.valueOrNull;

  // Return: living cost question data
  List<OtherLivingQuestion>? get getLivingCostQuestionData =>
      _fundCalcQuestionData != null &&
              _fundCalcQuestionData!.otherLivingQuestion != null
          ? _fundCalcQuestionData!.otherLivingQuestion
          : null;

  //Total calculation other living questions
  double totalOtherLivingAmount() {
    double totalAmount = 0.0;
    if (_otherLivingCostModelStream.valueOrNull != null) {
      _otherLivingCostModelStream.valueOrNull?.forEach((question) {
        totalAmount += question.answerAmount;
      });
    }
    return totalAmount;
  }

  // Firebase realtime database for fundCalculator
  getFundCalculatorDataFromFirebaseRealtimeDB() async {
    final response = await FirebaseDatabaseController.getRealtimeData(
        key: FirebaseRealtimeDatabaseConstants.fundCalculatorListString);
    if (response != null) {
      final fundCalcData = jsonEncode(response);
      _fundCalcQuestionData =
          FundCalculatorQuestionModel.fromJson(jsonDecode(fundCalcData));
      await insertFundCalculatorQuestionListInDb(fundCalcData);
      await addQuestionsList(_fundCalcQuestionData);
    }
  }

  // Return: Fund calculator question by Index
  FundCalculatorQuestion getFundCalcQuestionData(int questionID) {
    if (_fundCalcQuestionData != null &&
        _fundCalcQuestionData?.fundCalculatorQuestion != null) {
      for (var qData in _fundCalcQuestionData!.fundCalculatorQuestion!) {
        if (qData.questionId == questionID) {
          setCurrentCategory = qData.category ?? "";
          if (questionID == 2 && qData.categoryWiseTotalAmt == 0.0) {
            qData.categoryWiseTotalAmt = qData.amount?.toDouble() ?? 0.0;
          }
          return qData;
        }
      }
    }
    return FundCalculatorQuestion();
  }

  // Return: Other living question by Index
  OtherLivingQuestion getOtherLeavingQuestionData(int questionID) {
    if (_fundCalcQuestionData != null &&
        _fundCalcQuestionData?.otherLivingQuestion != null) {
      for (var qData in _fundCalcQuestionData!.otherLivingQuestion!) {
        if (qData.questionId == questionID) {
          setCurrentCategory = qData.category ?? "";
          return qData;
        }
      }
    }
    return OtherLivingQuestion();
  }

  //Get fundCalculatorData if exist in local database then fetch from local otherwise from realtime DB
  getFundCalculatorData() async {
    //read data from config table
    var syncDate = await ConfigTable.read(
        strField: ConfigFields.configFieldFundCalculatorQuestionListSyncDate);
    var configFundCalculatorData = await ConfigTable.read(
        strField: ConfigFields.configFieldFundCalculatorQuestionList);

    if (syncDate?.fieldValue == Utility.getTodayDate() &&
        configFundCalculatorData?.fieldValue != null) {
      _fundCalcQuestionData = FundCalculatorQuestionModel.fromJson(
          jsonDecode(configFundCalculatorData?.fieldValue.toString() ?? ""));
      await addQuestionsList(_fundCalcQuestionData);
    } else {
      getFundCalculatorDataFromFirebaseRealtimeDB();
    }
  }

  addQuestionsList(FundCalculatorQuestionModel? fundCalcQuestionData) {
    _fundCalculatorQuestionStream.sink
        .add(_fundCalcQuestionData?.fundCalculatorQuestion ?? []);
    _otherLivingCostModelStream.sink
        .add(_fundCalcQuestionData?.otherLivingQuestion ?? []);
  }

  //Insert data in config table
  insertFundCalculatorQuestionListInDb(
      String strFundCalculatorQuestionListJson) async {
    ConfigTable? configTable = await ConfigTable.read(
        strField: ConfigFields.configFieldFundCalculatorQuestionListSyncDate);
    var configFundCalculatorData = await ConfigTable.read(
        strField: ConfigFields.configFieldFundCalculatorQuestionList);

    //if exist in table then update data
    if (configTable?.fieldValue != null &&
        configFundCalculatorData?.fieldValue != null) {
      await ConfigTable.update(
          strFieldValue: strFundCalculatorQuestionListJson,
          strFieldName: ConfigFields.configFieldFundCalculatorQuestionList);
      await ConfigTable.update(
          strFieldValue: Utility.getTodayDate(),
          strFieldName: ConfigFields.configFieldFundCalculatorQuestionListSyncDate);
    }
    //else insert data
    else {
      var configFundQuestionTable = ConfigTable(
          fieldName: ConfigFields.configFieldFundCalculatorQuestionList,
          fieldValue: strFundCalculatorQuestionListJson);
      await ConfigTable.insertTable(configFundQuestionTable.toJson());

      var configSyncDateTable = ConfigTable(
          fieldName: ConfigFields.configFieldFundCalculatorQuestionListSyncDate,
          fieldValue: Utility.getTodayDate());
      await ConfigTable.insertTable(configSyncDateTable.toJson());
    }
  }

  set setSelectedQuesAmount(double amt) {
    _selectedQuesAmount = amt;
    if (selectedCurrencyData != null) {
      selectedQuesAmountWithCurrency = double.parse(
          (_selectedQuesAmount * selectedCurrencyData!.rate)
              .toStringAsFixed(2));
    } else {
      selectedQuesAmountWithCurrency = _selectedQuesAmount;
    }
  }

  // ******* Currency *********

  // Firebase Remote Config: for Country detail
  setupRemoteConfigForCountryList() async {
    String firebaseCountryData = await FirebaseRemoteConfigController.shared
        .Data(key: FirebaseRemoteConfigConstants.keyCountry);
    var jsonData = json.decode(firebaseCountryData);

    List<CountryWithCurrencyModel> countryList = (jsonData)
        .map<CountryWithCurrencyModel>((json) =>
            CountryWithCurrencyModel.fromJson(json as Map<String, dynamic>))
        .toList();

    /// read firebase database to get country wise currency
    if (countryList.isNotEmpty) {
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

        defaultCurrency =
            countryList.firstWhere((element) => element.symbolCode == "AUD");
        if (defaultCurrency != null) {
          setCurrency(defaultCurrency!, false, false);
        }

        // set country list with currency rate
        setCountryWithCurrencyList = countryList;
        searchCountryCodeList.value = countryList;
      } else {
        setCountryWithCurrencyList = [];
        searchCountryCodeList.value = [];
      }
    }
  }

  // set currency rate
  setCurrency(CountryWithCurrencyModel model, bool isLivingCost,
      bool needFundTotalAmountInAUD) {
    if (model.rate == 0.0) {
      // "Rate for selected country is not available."
    } else {
      selectedCurrencyData = model;
      // current selected answer amount
      if (selectedCurrencyData != null) {
        selectedQuesAmountWithCurrency = double.parse(
            (_selectedQuesAmount * selectedCurrencyData!.rate)
                .toStringAsFixed(2));
      } else {
        selectedQuesAmountWithCurrency = _selectedQuesAmount;
      }
      if (isLivingCost) {
      } else {
        // To calculate total fund amount
        calculateFundTotal(needFundTotalAmountInAUD: needFundTotalAmountInAUD);
      }
    }
  }

  // *******  Calculate Fund Total  *******
  double fundTotal = 0.0;

  calculateFundTotal({bool needFundTotalAmountInAUD = false}) {
    fundTotal = 0.0;
    if (_fundCalcQuestionData != null &&
        _fundCalcQuestionData?.fundCalculatorQuestion != null) {
      for (FundCalculatorQuestion qData
          in _fundCalcQuestionData!.fundCalculatorQuestion!) {
        fundTotal += qData.answerAmount;
      }
      if (selectedCurrencyData != null && !needFundTotalAmountInAUD) {
        fundTotal = double.parse(
            (fundTotal * selectedCurrencyData!.rate).toStringAsFixed(2));
      }
    }
  }

  bool checkValidation(BuildContext context,
      {required int index, required bool checkValidation}) {
    try {
      if (index == 1) {
        final data = getFundCalcQuestionData(1);
        // Course Fee
        if (data.answerAmount == 0) {
          Toast.show(context,
              message: StringHelper.courseFeeValidation, type: Toast.toastError);
          return false;
        }
        setSelectedQuesAmount = data.answerAmount;
        return true;
      } else if (index == 2) {
        // Q: 2, 3 & 4
        // Living cost
        FundCalculatorQuestion qStudentVisaData = getFundCalcQuestionData(2);
        FundCalculatorQuestion qSpouseData = getFundCalcQuestionData(3);
        FundCalculatorQuestion qNoofChilsData = getFundCalcQuestionData(4);
        qStudentVisaData.answerAmount =
            double.parse("${qStudentVisaData.amount}");
        qStudentVisaData.answer = "${qStudentVisaData.amount}";
        // Total
        double noOfChildAmount = 0.0;
        try {
          noOfChildAmount = int.parse(qNoofChilsData.answer.isNotEmpty
                  ? qNoofChilsData.answer
                  : "0") *
              double.parse("${qNoofChilsData.amount}");
          setSelectedQuesAmount =
              ((qSpouseData.answer.isNotEmpty && qSpouseData.answer == "true")
                      ? qSpouseData.answerAmount
                      : 0.0) +
                  double.parse("${qStudentVisaData.amount}") +
                  noOfChildAmount;
          return true;
        } catch (e) {
          printLog(e);
          noOfChildAmount = 0.0;
          return false;
        }
      } else if (index == 3) {
        // Schooling cost
        final data = getFundCalcQuestionData(5);
        setSelectedQuesAmount = data.answerAmount;
        return true;
      } else if (index == 5) {
        // Travelling cost
        final data = getFundCalcQuestionData(6);
        if (data.answer.isEmpty) {
          Toast.show(
              message: StringHelper.selectLocationValidation,
              context,
              type: Toast.toastError);
          return false;
        }
        setSelectedQuesAmount = data.answerAmount;
        return true;
      } else {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  @override
  void dispose() {
    _fundCalculatorQuestionStream.close();
    _otherLivingCostModelStream.close();
    searchCountryCodeList.close();
    countryWithCurrencyList.close();
    _currentIndex.close();
    _currentQuestionModelStream.close();
    _currentOtherLivingQuestionStream.close();
    _summaryChartStream.close();
  }
}

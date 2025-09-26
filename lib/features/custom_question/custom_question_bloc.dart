// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/custom_question/model/custom_question_answer_model.dart';
import 'package:occusearch/features/custom_question/model/custom_question_model.dart';
import 'package:occusearch/features/custom_question/widgets/custom_question_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_bloc/rx_bloc.dart';

class CustomQuestionBloc extends RxBlocTypeBase {
  //Custom Question List
  static CustomQuestions? customQuestionsModel;

  // Variable
  static final customQuestionListValue = BehaviorSubject<List<CustomQuestions>>();
  static List<CustomQuestions> activeCustomQuestionList = [];

  //CustomQuestionListLength
  static final _questionLength = PublishSubject<int>();

  //Get of custom question
  static Stream<List<CustomQuestions>> get getCustomQuestionsListStream =>
      customQuestionListValue.stream;

  //Custom Question List length
  static Stream<int> get getQuestionLengthStream => _questionLength.stream;

  //Get of custom question
  static Stream<int> get getCurrentIndexStream => currentIndexValue.stream;

  static final currentIndexValue = BehaviorSubject<int>.seeded(0);

  //GET
  static int? get getCurrentIndex => currentIndexValue.valueOrNull;

  static set setCurrentIndexValue(value) {
    currentIndexValue.sink.add(value);
  }

  //Get of custom question pop result store value
  static Stream<String?> get getPopIndexStream => popIndexValue.stream;

  static final popIndexValue = BehaviorSubject<String?>.seeded("");

  //GET
  static String? get getPopIndex => popIndexValue.valueOrNull;

  static set setPopIndexValue(value) {
    popIndexValue.sink.add(value);
  }

  //FIRST ATTEMPT IN EDIT PROFILE SCREEN
  static Stream<bool?> get getFirstAttemptStream => firstAttemptValue.stream;

  static final firstAttemptValue = BehaviorSubject<bool?>.seeded(false);

  //GET
  static bool? get getFirstAttempt => firstAttemptValue.valueOrNull;

  static set setFirstAttemptValue(value) {
    firstAttemptValue.sink.add(value);
  }

  static TextEditingController? _searchController;

  // Variable
  static final _customOptionsStream = BehaviorSubject<List<CustomQuestionOptions>?>();

  // Set
  static set setSearchFieldController(controller) => _searchController = controller;

  static set setOptionsList(List<CustomQuestionOptions>? list) =>
      _customOptionsStream.sink.add(list);

  // Get
  static Stream<List<CustomQuestionOptions>?> get getOptionListStream =>
      _customOptionsStream
          // .debounceTime(const Duration(milliseconds: 100))
          .transform(optionStreamTransformer);

  static BehaviorSubject<List<CustomQuestionOptions>?> get getOptionsList =>
      _customOptionsStream;

  // Search
  static onSearch(query) {
    getOptionsList.add(getOptionsList.value);
  }

  /// [SEARCH IN CUSTOM QUESTION DROPDOWN OPTIONS LIST]
  static StreamTransformer<List<CustomQuestionOptions>?, List<CustomQuestionOptions>?>
      get optionStreamTransformer => StreamTransformer<
              List<CustomQuestionOptions>?,
              List<CustomQuestionOptions>?>.fromHandlers(
            handleData: (list, sink) {
              if (_searchController?.text.isNotEmpty == true) {
                List<CustomQuestionOptions>? newList = (list)?.where(
                  (item) {
                    return item.answer!
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


  ///DASHBOARD - TIMER CURRENT INDEX MANAGE
  static Stream<int> get getDashboardIndexStream => dashboardIndexValue.stream;
  static final dashboardIndexValue = BehaviorSubject<int>.seeded(0);
  //GET
  static int? get getDashboardIndex => dashboardIndexValue.valueOrNull;
  static set setDashboardIndexValue(value) {
    dashboardIndexValue.sink.add(value);
  }

  ///SET QUESTION LIST BASED ON OPTION SELECTION
  static void setCustomQuestionList(CustomQuestions questionData) {
    if (questionData.options != null) {
      for (var element in questionData.options!) {
        for (var custQuestion in activeCustomQuestionList) {
          if (element.optionId ==
              int.parse((questionData.answer?.isEmpty == true)
                  ? "0"
                  : questionData.answer.toString())) {
            if (element.childQuestionId != null &&
                element.childQuestionId != 0 &&
                custQuestion.questionId != 0 &&
                element.childQuestionId == custQuestion.questionId) {
              custQuestion.primary = true;
            }
          } else {
            if (element.childQuestionId != null &&
                element.childQuestionId != 0 &&
                custQuestion.questionId != 0 &&
                element.childQuestionId == custQuestion.questionId) {
              custQuestion.primary = false;
              custQuestion.answer = "";
            }
          }
        }
      }
    }
    customQuestionListValue.sink.add(activeCustomQuestionList
        .where((element) => element.primary == true)
        .toList());
  }

  //DATA FETCH FROM STATIC JSON
  /*
  Future<void> getCustomQuestionList1() async {
    try {
      //Fetch data from json
      String customQuestionData =
          await rootBundle.loadString(Constants.customQuestion);
      //decode json and store data into model
      CustomQuestionModel customQuestionModel =
          CustomQuestionModel.fromJson(json.decode(customQuestionData));
      List<CustomQuestions>? customQuestionsList =
          customQuestionModel.customQuestions;

      //Custom Question List length
      _questionLength.sink
          .add(customQuestionsList == null ? 0 : customQuestionsList.length);

      allCustomQuestionList = customQuestionsList ?? [];
      _customQuestionListValue.sink.add(customQuestionsList!
          .where((element) => element.primary == true)
          .toList());
    } catch (e) {
      printLog(e);
    }
  }
   */

  //FOR DASHBOARD CUSTOM QUESTION TIMER SET
  static setDashBoardIndexHandler(List<CustomQuestions>? pendingQuestionList){
    if(((pendingQuestionList?.length ?? 0) - 1) == (getDashboardIndex ?? 0)){
      setDashboardIndexValue = 0;
    }else{
      setDashboardIndexValue = (((getDashboardIndex ?? 0 - 1)) + 1);
    }
  }

  ///CALL GET CUSTOM QUESTIONS API
  static Future<void> getCustomQuestionList([BuildContext? context]) async {
    try {
      UserInfoData info = await SharedPreferenceController.getUserData();

      // Map<String, dynamic> param = {
      //   "leadidf": 510232,
      //   "companyidf": 11532,
      //   "branchidf": 0
      // };

      Map<String, dynamic> param = {
        "leadidf": info.userId ?? 0,
        "companyidf": info.companyId ?? 0,
        "branchidf": info.branchId ?? 0
      };

      BaseResponseModel result =
          await CustomQuestionRepository.getCustomQuestions(param);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        CustomQuestionModel model = CustomQuestionModel.fromJson(result.data);

        if (model.flag == true && model.data != null && model.data != null) {
          List<CustomQuestions>? customQuestionsList =
              model.data!.questions ?? [];


          //FOR STORING IN CONFIG TABLE
          final configCustomQuestionList = jsonEncode(customQuestionsList);
          await insertCustomQuestionListInDb(configCustomQuestionList);

          //for applying Primary Filtration
          applyPrimaryFiltrations(customQuestionsList);
        }
      } else {
        customQuestionListValue.value = [];
        // Utility.showToastErrorMessage(context, result.statusCode);
      }
    } catch (e) {
      printLog(e);
    }
  }

  ///APPLY FILTER BASED ON PRIMARY == TRUE
  static applyPrimaryFiltrations(List<CustomQuestions> customQuestionsList) {
    //primary true /false
    if (customQuestionsList.isNotEmpty) {
      //MAIN QUESTIONS LOOP
      for (var parentQuestion in customQuestionsList) {
        if(parentQuestion.answer != ""){
          parentQuestion.isAttempted = true;
        }
        if (parentQuestion.options?.isNotEmpty == true) {
          //OPTIONS LOOP
          for (CustomQuestionOptions answerOptions
          in parentQuestion.options ?? []) {
            //ALL QUESTIONS COMPARE LOOP
            for (var elementValue in customQuestionsList) {
              if (answerOptions.childQuestionId != null &&
                  answerOptions.childQuestionId != 0 &&
                  answerOptions.childQuestionId ==
                      elementValue.questionId) {
                //IF ANSWER ALREADY SUBMMITED AND FETCH DATA
                if (parentQuestion.answer == null ||
                    parentQuestion.answer !=
                        "${answerOptions.optionId}") {
                  elementValue.primary = false;
                }
                break;
              }
            }
          }
        }
      }
    }

    //ACTIVE QUESTIONS ACCORDING TO OPTION SELECTION
    activeCustomQuestionList = customQuestionsList;

    //FIRST TIME SHOW PRIMARY TRUE QUESTIONS LIST
    customQuestionsList = customQuestionsList
        .where((element) => element.primary == true)
        .toList();

    _questionLength.sink.add(
        customQuestionsList.isEmpty ? 0 : customQuestionsList.length);

    customQuestionListValue.sink.add(customQuestionsList);
  }

  ///SUBMIT ANSWER API CALL
 static Future<void> submitCustomQuestionsApi(BuildContext context,
     List<CustomQuestionAnswerModel> customQuestionsList,
     bool isFromEditProfileScreen,
     bool firstAttemptSnapShot,
     bool isFromLastQuestion,
     bool isFromWillDoLater,
     bool isFromDashboard
     ) async {
    try {
      UserInfoData info = await SharedPreferenceController.getUserData();

      Map<String, dynamic> param = {
        "leadidf": info.userId ?? 0,
        "companyidf": info.companyId ?? 0,
        "branchidf": info.branchId ?? 0,
        "questions": customQuestionsList
      };

      BaseResponseModel result = await CustomQuestionRepository.submitCustomQuestions(param);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        if(!isFromLastQuestion){
          Future.delayed(const Duration(seconds: 1), () {
            if ((!firstAttemptSnapShot && isFromEditProfileScreen) || firstAttemptSnapShot && !isFromDashboard) {
              context.popUntil(RouteName.editProfile);
              if(!isFromWillDoLater){
                return Toast.show(context, message: StringHelper.answerSubmitted);
              }
            }else if (isFromEditProfileScreen) {
              context.pop();
              if(!isFromWillDoLater) {
                return Toast.show(
                    context, message: StringHelper.answerSubmitted);
              }
            } else {
              GoRoutesPage.go(
                  mode: NavigatorMode.push,
                  moveTo: RouteName.home);
              if(!isFromWillDoLater) {
                return Toast.show(context, message: StringHelper.answerSubmitted);
              }
            }
          });
        }
      } else {
        // return Utility.showToastErrorMessage(context, result.statusCode);
      }
    } catch (e) {
      printLog(e);
    }
  }

  ///Get CustomQuestions if exist in local database then fetch from local otherwise from call API
  static getCustomQuestionData() async {
    //read data from config table
    var syncDate = await ConfigTable.read(
        strField: ConfigFields.configFieldCustomQuestionsListSyncDate);
    var configCustomQuestionData = await ConfigTable.read(strField: ConfigFields.configFieldCustomQuestionsList);

    if (syncDate?.fieldValue == Utility.getTodayDate() && configCustomQuestionData?.fieldValue != null) {
      //decode config table value
      var questionsDecodeVal  = json.decode((configCustomQuestionData?.fieldValue.toString() ?? "").trim()) as List;
      List<CustomQuestions>? customQuestionsList = questionsDecodeVal.map((tagJson) => CustomQuestions.fromJson(tagJson)).toList();

      applyPrimaryFiltrations(customQuestionsList);

    } else {
      /// API call
      getCustomQuestionList();
    }
  }

  ///Insert data in config table
  static insertCustomQuestionListInDb(String strCustomQuestionListJson) async {
    ConfigTable? configTable = await ConfigTable.read(
        strField: ConfigFields.configFieldCustomQuestionsListSyncDate);
    var configCustomQuestionData =
        await ConfigTable.read(strField: ConfigFields.configFieldCustomQuestionsList);

    //if exist in table then update data
    if (configTable?.fieldValue != null &&
        configCustomQuestionData?.fieldValue != null) {
      await ConfigTable.update(
          strFieldValue: strCustomQuestionListJson,
          strFieldName: ConfigFields.configFieldCustomQuestionsList);
      await ConfigTable.update(
          strFieldValue: Utility.getTodayDate(),
          strFieldName: ConfigFields.configFieldCustomQuestionsListSyncDate);
    }
    //else insert data
    else {
      var configFundQuestionTable = ConfigTable(
          fieldName: ConfigFields.configFieldCustomQuestionsList,
          fieldValue: strCustomQuestionListJson);
      await ConfigTable.insertTable(configFundQuestionTable.toJson());

      var configSyncDateTable = ConfigTable(
          fieldName: ConfigFields.configFieldCustomQuestionsListSyncDate,
          fieldValue: Utility.getTodayDate());
      await ConfigTable.insertTable(configSyncDateTable.toJson());
    }
  }


  ///SUBMIT QUESTION IN CONFIG TABLE [COMPARE VALUES AND ARRANGE AS PER SEQUENCES]
  static submitQuestionsToConfigTable(List<CustomQuestions> submitQuestionList) async{
    var configCustomQuestionData =
        await ConfigTable.read(strField: ConfigFields.configFieldCustomQuestionsList);
    if(configCustomQuestionData != null){

      //fetch and Decode list values
      var questionsDecodeVal  = json.decode((configCustomQuestionData.fieldValue.toString()).trim()) as List;
      List<CustomQuestions>? customQuestionsList = questionsDecodeVal.map((tagJson) => CustomQuestions.fromJson(tagJson)).toList();

      if(submitQuestionList.isNotEmpty){
        //HERE WE NEED REPLACE UPDATED QUESTION OBJECT IN ALL QUESTIONS LIST
        for(CustomQuestions que in submitQuestionList){
          var objectOfQuestion = CustomQuestions();
          var indexOfQuestion = customQuestionsList.indexWhere((questions) => questions.questionId == que.questionId);
          for(CustomQuestions customQuestions in customQuestionsList){
            if(que.questionId == customQuestions.questionId){
              objectOfQuestion = que;
              customQuestionsList.removeAt(indexOfQuestion);
              customQuestionsList.insert(indexOfQuestion, objectOfQuestion);
            }
          }
        }
      }

      //Store in table
      final configCustomQuestionList = jsonEncode(customQuestionsList);
      CustomQuestionBloc.insertCustomQuestionListInDb(configCustomQuestionList);

    }
  }

  ///FINAL SUBMIT ALL QUESTIONS TO CONFIG TABLE AND CALL SUBMIT QUESTIONS API
  static submitCustomQuestionAnswersList(
      {BuildContext? context,
      List<CustomQuestions>? customQuestionsList,
      bool? fromEditScreen,
      bool? firstAttemptFromEditScreen,bool? isFromLastQuestion,bool? isFromWillDoLater,bool? isFromDashboard}){
    List<CustomQuestions>? selectedOptionQuestionsList = customQuestionsList?.where((element) => element.answer != "").toList();
    List<CustomQuestionAnswerModel>?customQuestionsAnswerList = [];
    List<CustomQuestions>? submitQuestionList = customQuestionsList?.where((element) => element.answer != "").toList();
    for (CustomQuestions? value in submitQuestionList ?? []) {
      //DASHBOARD PENDING QUESTIONS
      value?.isAttempted = true;
      customQuestionsAnswerList.add(CustomQuestionAnswerModel(
        questionid: value?.questionId ?? 0,
        answer: value?.answer ?? "",
      ));
    }
    //SUBMIT CUSTOM QUESTION API CALL
    CustomQuestionBloc.submitCustomQuestionsApi(
        context!,
        customQuestionsAnswerList,
        fromEditScreen ?? false,
        firstAttemptFromEditScreen ?? false,
        isFromLastQuestion ?? false,
        isFromWillDoLater ?? false,
        isFromDashboard ?? false
    );

    //HERE WE STORE WHOLE LIST - BECAUSE USER SELECT OPTION AND PRESS WILL DO LATER
    CustomQuestionBloc.submitQuestionsToConfigTable(selectedOptionQuestionsList ?? []);
  }


  ///SELECTED VISA FEES NAME
  static visaSubTypeName({String? subVisaName,bool? subClassCode}){
    String subclasscode = "";
    String visatypename = subVisaName?.toLowerCase() ?? "";
    if (visatypename.contains("(subclass") ||
        visatypename.contains("( subclass")) {
      int startingIndex = visatypename.contains("(subclass")
          ? visatypename.indexOf("(subclass")
          : visatypename.indexOf("( subclass");
      int endIndex = visatypename.indexOf(")", startingIndex);
        subclasscode = subVisaName!.substring(startingIndex,
            visatypename.length > endIndex ? endIndex + 1 : endIndex);
        visatypename = subVisaName.replaceAll(subclasscode, "");
        subclasscode = subVisaName.substring(startingIndex + 1, endIndex);
    } else {
      visatypename = subVisaName!;
    }
    if(subClassCode == true){
      return "$subclasscode+$visatypename";
    }else{
      return visatypename;
    }
  }

  @override
  void dispose() {
    // _customQuestionListValue.close();
    // _customOptionsStream.close();
  }
}

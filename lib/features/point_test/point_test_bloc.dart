// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, library_prefixes

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:occusearch/common_widgets/loading_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/firebase/push_notification/push_notification.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/point_test/point_test_model/point_test_ques_model.dart';
import 'package:occusearch/features/point_test/point_test_model/point_test_save_response_model.dart';
import 'package:occusearch/features/point_test/point_test_model/save_point_test_request_model.dart';
import 'package:occusearch/features/point_test/point_test_repo.dart';
import 'package:occusearch/features/point_test/point_test_review/point_test_review_model/point_test_review_model/point_test_score_result_model.dart'
    as PointTestResultModel;
import 'package:occusearch/utility/rating/dynamic_rating_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

@RxBloc()
class PointTestBloc extends RxBlocTypeBase {
  PointTestReviewType? fromWhere;

  // CURRENT SELECTED QUESTION
  final ptAllQuesList = BehaviorSubject<List<Questionlist>>();

  Stream<List<Questionlist>> get getPTAllQuesList => ptAllQuesList.stream;

  set setPTAllQuesList(List<Questionlist> questionList) {
    ptAllQuesList.sink.add(questionList);
  }

  late PageController _pageController;

// [Display in Listview.builder()]
  // CURRENT SELECTED QUESTION
  final visibleQuestionList = BehaviorSubject<List<Questionlist>>();

  Stream<List<Questionlist>> get getVisibleQuestionList =>
      visibleQuestionList.stream;

  set setVisibleQuestionList(List<Questionlist> questionList) {
    visibleQuestionList.sink.add(questionList);
  }

  // Total point test list of question
  final pointTestQuesList = BehaviorSubject<List<Questionlist>>();

  Stream<List<Questionlist>> get getPointTestQuesList =>
      pointTestQuesList.stream;

  set setPointTestQuesList(List<Questionlist> questionList) {
    pointTestQuesList.sink.add(questionList);
  }

  // [Total User Answer Score]
  final totalScoreCount = BehaviorSubject<int>.seeded(0);

  Stream<int> get getTotalScoreCount => totalScoreCount.stream;

  set setTotalScoreCount(int index) {
    totalScoreCount.sink.add(index);
  }

  // [API Response Error Message]
  String errorMsg = ""; //email verify
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  // GET
  Stream<bool> get loadingStream => _isLoadingSubject.stream;

  final pageViewIndex = BehaviorSubject<int>.seeded(0);

  // Get
  Stream<int> get getPageViewIndex => pageViewIndex.stream;

  int get getPageViewIndexValue => pageViewIndex.value;

  set setPageViewIndex(index) => pageViewIndex.sink.add(index);

  //To stream select/deselect in current question data
  final activeQuestion = BehaviorSubject<Questionlist>();

  Stream<Questionlist> get getActiveQuestion => activeQuestion.stream;

  set setActiveQuestion(questionData) => activeQuestion.sink.add(questionData);

  int questionIdForEdit = 0; // Question ID if user come from Edit Question mode
  int? errorCode;

  // [API Response JSON Question Model]
  PointTestQuestionModelData? pointTestQuestionModel;

  @override
  void dispose() {}

  void setupPointTestQuestionTestData(
      dynamic args, PageController pageController, BuildContext context) {
    _pageController = pageController;
    questionIdForEdit = 0;
    PointTestMode mode = PointTestMode.NEW_TEST;
    if (args != null && args != "") {
      // print(args!['mode'] as PointTestMode);
      if (args!['mode'] != null && args!['mode'] != "") {
        try {
          mode = args!['mode'] as PointTestMode;
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
      if (args!['question_ID'] != null && args!['question_ID'] != "") {
        try {
          questionIdForEdit = args!['question_ID'] as int;
        } catch (e) {
          printLog(e);
        }
      }
      // To hold the route name reference from which screen user came...
      fromWhere = PointTestReviewType.DASHBOARD;
      if (args!['from_where'] != null && args!['from_where'] != "") {
        try {
          fromWhere = args!['from_where'] as PointTestReviewType;
        } catch (e) {
          printLog(e);
        }
      }
    }
    // Call API for Question data or read from database
    getPointTestQuestionList(mode, context);
  }

  Future<void> getPointTestQuestionList(
      PointTestMode mode, BuildContext context) async {
    try {
      setQuestionList = [];
      errorMsg = "";
      _isLoadingSubject.sink.add(true);

      if (await shouldFetchPointTestQuestionListFromRemote()) {
        if (NetworkController.isInternetConnected == false) {
          _isLoadingSubject.sink.add(false);
          setPTAllQuesList = [];
          errorMsg = StringHelper.internetConnection;
          errorCode = Constants.statusCodeForNoInternet;
          return;
        }
        // GET Point Test Question List from Firebase RealTime database
        DatabaseReference databaseReference = FirebaseDatabase.instance
            .ref(FirebaseRealtimeDatabaseConstants.pointTestQuestionListString);
        await databaseReference.once().then((event) async {
          if (event.snapshot.exists) {
            errorCode = Constants.statusCodeForApiData;
            _isLoadingSubject.sink.add(false);
            final data = jsonEncode(event.snapshot.value);
            pointTestQuestionModel =
                PointTestQuestionModelData.fromJson(jsonDecode(data));

            if (pointTestQuestionModel != null &&
                pointTestQuestionModel!.questionlist != null) {
              setPTAllQuesList = pointTestQuestionModel!.questionlist ?? [];
              ptAllQuesList.value
                  .sort((a, b) => a.priority.compareTo(b.priority));
              // Insert Point test question into database
              PointTestRepository.insertPointTestQuestionListInDb(
                  jsonEncode(pointTestQuestionModel));
            } else {
              setPTAllQuesList = [];
              errorMsg = StringHelper.failedToGetQuestionErrorMessage;
              Toast.show(context,
                  message: errorMsg,
                  type: Toast.toastError,
                  gravity: Toast.toastTop,
                  duration: 2);
            }
            // Prepared point test question
            if (mode == PointTestMode.EDIT_ALL_QTEST) {
              preparedPointTestQuestionForEdit(ptAllQuesList.value);
            } else if (mode == PointTestMode.EDIT_QTEST) {
              preparedPointTestQuestionForEdit(ptAllQuesList.value);
            } else {
              // Here we filter the primary question
              setPrimaryAskQuestion();
            }
          } else {
            _isLoadingSubject.sink.add(false);
            setPTAllQuesList = [];
            errorMsg = StringHelper.failedToGetQuestionErrorMessage;
            Toast.show(context,
                message: errorMsg,
                type: Toast.toastError,
                gravity: Toast.toastTop,
                duration: 2);
          }
        });
      } else {
        pointTestQuestionModel =
            await PointTestRepository.getPointTestQuestionListFromDb();
        // set default 1st Question here...
        if (pointTestQuestionModel != null &&
            pointTestQuestionModel!.questionlist != null) {
          setPTAllQuesList = pointTestQuestionModel!.questionlist!;
          ptAllQuesList.value.sort((a, b) => a.priority.compareTo(b.priority));
          // set default 1st Question here...
          PointTestRepository.insertPointTestQuestionListInDb(
              jsonEncode(pointTestQuestionModel));
          errorCode = Constants.statusCodeForCacheData;
        } else {
          setPTAllQuesList = [];
        }
        _isLoadingSubject.sink.add(false);
        // Prepared point test question
        if (mode == PointTestMode.EDIT_ALL_QTEST) {
          preparedPointTestQuestionForEdit(ptAllQuesList.value);
        } else if (mode == PointTestMode.EDIT_QTEST) {
          preparedPointTestQuestionForEdit(ptAllQuesList.value);
        } else {
          // Here we filter the primary question
          setPrimaryAskQuestion();
        }
      }
    } catch (e) {
      _isLoadingSubject.sink.add(false);
      debugPrint(e.toString());
    } finally {}
    // Calculate Total Point test score
    calculateTotalScore();
  }

  Future<bool> shouldFetchPointTestQuestionListFromRemote() async {
    /*check today's date with the date in database for question list sync.
    If date is mismatched, question list will be fetched from API and response will be saved(updated) in local database.
    If date is same, then question list will be fetched from db.*/

    var configTable = await ConfigTable.read(
        strField: ConfigFields.pointTestQuestionListSyncDate);
    String strLastSyncDate = configTable?.fieldValue ?? '';
    if (strLastSyncDate != "") {
      return strLastSyncDate != Utility.getTodayDate();
    } else {
      return true;
    }
  }

  set setQuestionList(List<Questionlist> list) {
    setPointTestQuesList = list;
    setVisibleQuestionList = [];
    for (var element in pointTestQuesList.value) {
      if (element.isActiveQues) {
        visibleQuestionList.value.add(element);
      }
    }
    //notifyListeners();

    // If user come from particular question edit mode then here we set ques. page builder index
    int position = visibleQuestionList.value
        .indexWhere((element) => element.id == questionIdForEdit);
    if (position != -1 && position != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(position,
              // To move next question by calling onPageChanged()
              curve: Curves.linearToEaseOut,
              duration: const Duration(milliseconds: 750));
        }
      });
    }
  }

  // We set primary question...
  setPrimaryAskQuestion() {
    List<Questionlist> temp = [];
    List<Questionlist> primaryQList = [];
    List<Questionlist> dependedQList = [];
    List<int> makeActiveQuestion = [];
    if (ptAllQuesList.value.isNotEmpty) {
      for (var Q in ptAllQuesList.value) {
        bool flag = false; // [FALSE] = Primary Question
        int refQID = 0;
        for (var ques in ptAllQuesList.value) {
          // Question List
          for (var option in ques.option!) {
            // Option List
            if (option.displayquestion != null) {
              for (var optionQID in option.displayquestion!) {
                // Add user selected answer option ref. Qid, if user come from edit mode and
                if (option.isSelected && optionQID.qid != null) {
                  makeActiveQuestion.add(optionQID.qid!);
                }
                // Question ID
                if (optionQID.qid == Q.id) {
                  flag = true;
                  refQID = ques.id == null ? 0 : ques.id!;
                  break;
                }
              }
            }
          }
        }
        Q.refQuesID = refQID; // parent question ID
        Q.isPrimaryQues = !flag;
        Q.isActiveQues = !flag;
        !flag ? primaryQList.add(Q) : dependedQList.add(Q);
        temp.add(Q);
      }
      // To make all question in sequence...
      makeActiveQuestion.toSet().toList(); // remove duplicate data
      for (int i = 0; i < temp.length; i++) {
        temp[i].isActiveQues = temp[i].isActiveQues
            ? temp[i].isActiveQues
            : makeActiveQuestion.any((element) => element == temp[i].id);
      }
      setQuestionList = temp;
    }
    // set new active question to display
    activeQuestion.value = visibleQuestionList.value[pageViewIndex.value];
    calculateTotalScore();
  }

  // calculate total score based on selected answer
  calculateTotalScore() {
    if (visibleQuestionList.value.isNotEmpty) {
      totalScoreCount.value = 0;
      _isLoadingSubject.sink.add(true);
      for (var question in visibleQuestionList.value) {
        if (question.isActiveQues) {
          for (var option in question.option!) {
            if (option.isSelected) {
              totalScoreCount.value =
                  totalScoreCount.value + int.parse(option.ovalue!);
            }
          }
        }
      }
    }
  }

  void preparedPointTestQuestionForEdit(List<Questionlist> questionList) async {
    var configPointTestData =
        await ConfigTable.read(strField: ConfigFields.pointTestResultList);
    List<PointTestResultModel.QuestionScorelist> pointTestResult = [];
    List<Questionlist> ptAllQuesList = [];
    // Check if results are available in db or call API
    if (configPointTestData != null) {
      // Convert Point test result question String into List<QuestionData>
      PointTestResultModel.PointTestResultModel pointTestResultModel =
          PointTestResultModel.PointTestResultModel.fromJson(
              jsonDecode(configPointTestData.fieldValue!));

      if (pointTestResultModel.flag == true &&
          pointTestResultModel.data != null &&
          pointTestResultModel.data![0].questionlist != null &&
          pointTestResultModel.data![0].questionlist!.isNotEmpty) {
        pointTestResult = pointTestResultModel.data![0].questionlist ?? [];
      }
      if (questionList.isNotEmpty && pointTestResult.isNotEmpty) {
        // Point test all question data
        for (var question in questionList) {
          Questionlist qData = question;
          // Result Question data
          for (var qAnswer in pointTestResult) {
            if (qData.id == qAnswer.id && qAnswer.option != null) {
              for (var answerOptions in qAnswer.option!) {
                int index = qData.option!
                    .indexWhere((element) => element.oid == answerOptions.oid);
                if (index != -1) {
                  // Answer id already selected...
                  qData.option![index].isSelected = true;
                }
              }
            }
          }
          ptAllQuesList.add(qData);
        }
        setPTAllQuesList = ptAllQuesList;
      }
      // Here we filter the primary question
      setPrimaryAskQuestion();
    } else {
      // Here we filter the primary question
      setPrimaryAskQuestion();
    }
  }

  // [needToValidate] [IF(TRUE)] need to give answer mandatory [else] skip the question without giving answer to the current showing question
  handleQuestionToDisplay(
      {Questionlist? currentVisibleQuestionData,
      required BuildContext context,
      required PointTestQuesStatus status,
      required bool needToValidate,
      required PageController pageController,
      int? userId}) {
    _pageController = pageController; //check
    if (status == PointTestQuesStatus.TEST_COMPLETION) {
      if (NetworkController.isInternetConnected) {
        // SAVE Point Test Data
        savePointTestData(context, userId!);
      } else {
        Toast.show(context,
            message: StringHelper.internetConnection, type: Toast.toastError);
      }
    } else {
      if (status == PointTestQuesStatus.PREVIOUD_QUESTION) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.animateToPage(pageViewIndex.value - 1,
                // To move next question by calling onPageChanged()
                curve: Curves.linearToEaseOut,
                duration: const Duration(milliseconds: 750));
          }
        });
      } else if (status == PointTestQuesStatus.NEXT_QUESTION) {
        if (currentVisibleQuestionData != null) {
          int selectedOptionID = 0;
          for (var option in currentVisibleQuestionData.option!) {
            if (option.isSelected) {
              selectedOptionID = option.oid ?? 0;
              break;
            }
          }
          // by calling this function, remove or add question in visibleQuestionList and move to next question
          onOptionSelection(currentVisibleQuestionData, selectedOptionID,
              SelectedOptionType.NEXT_QUESTION);
        }
      }
      // Recalculate Point test score
      calculateTotalScore();
      //}
    }
  }

  // [SAVE] Http API calling to get Point test question list...
  savePointTestData(BuildContext context, int userid) {
    try {
      FirebaseAnalyticLog.shared.eventTracking(
          screenName: RouteName.pointTestQuestionScreen,
          actionEvent: FBActionEvent.fbActionSubmit,
          other: "");

      List<SaveQuestionlist> requestJSON = [];
      List<SelectedAnswers> sa = [];
      SavePointTestModel model = SavePointTestModel();
      SaveQuestionlist questionList = SaveQuestionlist();
      if (pointTestQuestionModel != null &&
          pointTestQuestionModel!.questionlist != null) {
        model.userId = userid;
        for (var quesModel in pointTestQuestionModel!.questionlist!) {
          questionList = SaveQuestionlist();
          questionList.id = quesModel.id;
          questionList.qname = quesModel.qname;
          questionList.qtype = quesModel.qtype;
          SaveOption saveOption = SaveOption();
          for (var options in visibleQuestionList.value) {
            if (options.isActiveQues && options.id == quesModel.id) {
              for (var selectedOption in options.option!) {
                // Check if question open is selected or not
                if (selectedOption.isSelected) {
                  saveOption = SaveOption();
                  saveOption.oid = selectedOption.oid;
                  saveOption.oname = selectedOption.oname;
                  saveOption.ovalue = selectedOption.ovalue;
                  saveOption.isSelected = true;
                  saveOption.displayquestion = [];
                }
              }
            }
          }
          if (saveOption.oid != null) {
            questionList.option = [saveOption];
            requestJSON.add(questionList);
          }
        }
        SelectedAnswers selectedAns = SelectedAnswers();
        selectedAns.calculatortype = pointTestQuestionModel!.calculatortype;
        selectedAns.sourceurl = pointTestQuestionModel!.sourceurl;
        selectedAns.totalpoint = pointTestQuestionModel!.totalpoint;
        selectedAns.minimumreqpoint = pointTestQuestionModel!.minimumreqpoint;
        selectedAns.questionlist = requestJSON;
        sa = [selectedAns];
        model.selectedAnswers = sa;
        if (model.selectedAnswers != null &&
            model.selectedAnswers!.isNotEmpty &&
            model.selectedAnswers![0].questionlist != null &&
            model.selectedAnswers![0].questionlist!.isNotEmpty) {
          // Call API to Save Point test...
          //model.selectedAnswers[0]?.questionlist;
          callAPIToSavePointTest(context, model);
        } else {
          Toast.show(context,
              message: StringHelper.pointTestAttemptAnswerMsg,
              type: Toast.toastError,
              duration: 3);
        }
      } else {
        Toast.show(context,
            message: StringHelper.pointTestAttemptAnswerMsg,
            type: Toast.toastError,
            duration: 3);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // CALL API to Save/Update Point test data
  Future<void> callAPIToSavePointTest(BuildContext context, model) async {
    try {
      LoadingWidget.show();
      // Subscribe Firebase Notification Point Text Topic
      await FirebaseMessaging.instance.subscribeToTopic(
          FirebaseNotificationConstants
              .firebaseNotificationTopicPointCalculator);

      BaseResponseModel result =
          await PointTestRepository.callAPIToSavePointTest(
              context, jsonEncode(model));

      if (result.statusCode == Constants.statusCodeForApiData &&
          result.flag == true) {
        PointTestSaveResponseModel response =
            PointTestSaveResponseModel.fromJson(result.data);
        if (response.flag == true) {
          LoadingWidget.hide();

          // increase local count of dynamic rating according to module into stored data of shared preference...
          DynamicRatingCalculation.updateRatingLocalCountByModuleName(
              SharedPreferenceConstants.pointTest); //Dynamic rating pending

          Toast.show(context,
              message: response.message ??
                  StringHelper.pointTestCompletedSuccessfullyMsg,
              type: Toast.toastSuccess,
              gravity: Toast.toastTop);

          GoRoutesPage.go(
              mode: NavigatorMode.replace,
              moveTo: RouteName.pointTestReviewScreen,
              param: PointTestReviewType.POINTTEST);
        } else {
          LoadingWidget.hide();
          errorMsg = StringHelper.pointTestFailedToSubmit;
          Toast.show(context,
              message: response.message ?? errorMsg, type: Toast.toastError);
        }
      } else {
        if (result.statusCode == Constants.statusCodeForNoInternet) {
          errorMsg = StringHelper.internetConnection;
        } else {
          errorMsg = StringHelper.pointTestFailedToSubmit;
        }
        Toast.show(context,
            message: errorMsg, gravity: Toast.toastTop, type: Toast.toastError);
        LoadingWidget.hide();
      }
    } catch (e) {
      Toast.show(context, message: e.toString(), type: Toast.toastError);
      debugPrint(errorMsg);
      LoadingWidget.hide();
    }
  }

  /*
  *     When user select any answer option that will updated from here
  *     Here we handle which answer are selected question wise...
  * */
  onOptionSelection(
      Questionlist visibleQuestionData, int optionID, SelectedOptionType type) {
    bool isAnyOptionUserSelected = false;
    int a = 0;
    for (var element in visibleQuestionData.option!) {
      // If any option is selected
      if (!isAnyOptionUserSelected) {
        isAnyOptionUserSelected = element.oid == optionID
            ? !visibleQuestionData.option![a].isSelected
            : false;
      }

      if (type != SelectedOptionType.NEXT_QUESTION) {
        // only execute below statement if user select or unselect any answer/option...
        visibleQuestionData.option![a].isSelected = element.oid == optionID
            ? !visibleQuestionData.option![a].isSelected
            : false;
      }
      a++;
    }

    try {
      // [START]
      for (int i = 0; i < pointTestQuesList.value.length; i++) {
        // Here we check if is there any active question found then we just inactive
        // that question to avoid other unselected option question
        for (var option in visibleQuestionData.option!) {
          if (option.displayquestion != null) {
            // All the unselected option Loop...
            for (var optionQID in option.displayquestion!) {
              // Option QuestionID and pointTestQuesList.QuestionID match then inactive them
              if (optionQID.qid == pointTestQuesList.value[i].id &&
                  !pointTestQuesList.value[i].isPrimaryQues) {
                // remove
                pointTestQuesList.value[i].isActiveQues = false;
                visibleQuestionList.value.removeWhere((element) {
                  return element.id == pointTestQuesList.value[i].id;
                });
              }
              if (option.oid == optionID &&
                  isAnyOptionUserSelected &&
                  pointTestQuesList.value[i].id == optionQID.qid) {
                // add
                pointTestQuesList.value[i].isActiveQues = true;
                visibleQuestionList.value.removeWhere((element) =>
                    element.id ==
                    pointTestQuesList
                        .value[i].id); // remove duplicate question if have any
                visibleQuestionList.value.add(pointTestQuesList.value[i]);
              }
            }
          }
        }
      }

      // sorting question list by question id
      try {
        if (visibleQuestionList.value.isNotEmpty &&
            visibleQuestionList.value[0].priority == 0) {
          visibleQuestionList.value.sort((a, b) => a.id!.compareTo(b.id!));
        } else {
          visibleQuestionList.value
              .sort((a, b) => a.priority.compareTo(b.priority));
        }
      } catch (e) {
        printLog(e);
        visibleQuestionList.value.sort((a, b) => a.id!.compareTo(b.id!));
      }

      // Auto move to next question
      if (visibleQuestionList.value.length - 1 > pageViewIndex.value &&
              (isAnyOptionUserSelected &&
                  type == SelectedOptionType.OPTION_SELECTION) ||
          type == SelectedOptionType.NEXT_QUESTION) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(pageViewIndex.value + 1,
                // To move next question by calling onPageChanged()
                curve: Curves.linearToEaseOut,
                duration: const Duration(milliseconds: 750));
          }
        });
      }
      //pointTestBloc.activeQuestion.value = questionData;
      // [END]
    } catch (e) {
      printLog(e);
    }

    calculateTotalScore(); // call() to calculate total score
  }
}

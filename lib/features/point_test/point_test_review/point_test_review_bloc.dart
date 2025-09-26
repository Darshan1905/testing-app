// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/point_test/point_test_model/point_test_ques_model.dart';
import 'package:occusearch/features/point_test/point_test_repo.dart';
import 'package:occusearch/features/point_test/point_test_review/point_test_review_model/point_test_review_model/point_test_score_result_model.dart';
import 'package:occusearch/features/point_test/point_test_review/point_test_review_repo.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

@RxBloc()
class PointTestReviewBloc extends RxBlocTypeBase {
  BuildContext? _context;
  bool loading = false;
  String errorMsg = ""; // API Error Message
  int? errorCode;
  String pointTestResultJSONStringData = ""; // store api result to generate pdf
  List<QuestionScorelist> reviewQuestionList = [];

  double maxPointValue = 0.0;
  final minPointValue = BehaviorSubject<int>.seeded(65);
  double progressBarValue = 0.0;

  final userPointsScore = BehaviorSubject<int>.seeded(0);

  set setUserPointsScore(index) => userPointsScore.sink.add(index);

  Stream<int> get getUserPointsScore => userPointsScore.stream;

  final loadingShare = BehaviorSubject<bool>.seeded(false);
  final loadingEmail = BehaviorSubject<bool>.seeded(false);

  //int userPointsScore = 0;
  String pointTestPdfLink = "";

  PointTestQuestionModelData? pointTestQuestionModel; // Question API response
  // List<Questionlist> ptAllQuesList = [];

  final ptAllQuesList = BehaviorSubject<List<Questionlist>>();

  Stream<List<Questionlist>> get getPtAllQuesList => ptAllQuesList.stream;

  set setPtAllQuesList(List<Questionlist> questionList) {
    ptAllQuesList.sink.add(questionList);
  }

  set setLoaderValue(bool flag) {
    loading = flag;
  }

  @override
  void dispose() {}

  // [Question List] Http API calling to get Point test question list...
  Future<void> getPointTestQuestionList(BuildContext context, userid) async {
    try {
      errorMsg = "";
      if (await shouldFetchPointTestQuestionListFromRemote()) {
        setLoaderValue = true;
        if (NetworkController.isInternetConnected == false) {
          errorCode = Constants.statusCodeForNoInternet;
          setLoaderValue = false;
          setPtAllQuesList = [];
          errorMsg = StringHelper.internetConnection;
          return;
        }
        // GET Point Test Question List from Firebase RealTime database
        DatabaseReference databaseReference = FirebaseDatabase.instance
            .ref(FirebaseRealtimeDatabaseConstants.pointTestQuestionListString);
        await databaseReference.once().then((event) async {
          if (event.snapshot.exists) {
            errorCode = Constants.statusCodeForApiData;
            final data = jsonEncode(event.snapshot.value);
            pointTestQuestionModel =
                PointTestQuestionModelData.fromJson(jsonDecode(data));
            if (pointTestQuestionModel != null &&
                pointTestQuestionModel!.questionlist != null) {
              setPtAllQuesList = pointTestQuestionModel!.questionlist ?? [];
              // Save Question list into Local database
              PointTestRepository.insertPointTestQuestionListInDb(
                  jsonEncode(pointTestQuestionModel));
              //to get result for question list attempted and not attempted
              getPointTestResult(isFromShare: false, userId: userid);
              setLoaderValue = false;
            } else {
              setLoaderValue = false;
              setPtAllQuesList = [];
              errorMsg = StringHelper.failedToGetQuestionErrorMessage;
              Toast.show(context, message: errorMsg);
            }
          } else {
            setLoaderValue = false;
            setPtAllQuesList = [];
            errorMsg = StringHelper.failedToGetQuestionErrorMessage;
            Toast.show(context, message: errorMsg);
          }
        });
      } else {
        errorCode = Constants.statusCodeForCacheData;
        pointTestQuestionModel =
            await PointTestRepository.getPointTestQuestionListFromDb();
        // set default 1st Question here...
        if (pointTestQuestionModel != null &&
            pointTestQuestionModel!.questionlist != null) {
          setPtAllQuesList = pointTestQuestionModel!.questionlist!;
          //to get result for question list attempted and not attempted
          getPointTestResult(isFromShare: false, userId: userid);
        } else {
          setPtAllQuesList = [];
        }
      }
    } catch (e) {
      setLoaderValue = false;
      debugPrint(e.toString());
    }
  }

  Future<bool> shouldFetchPointTestQuestionListFromRemote() async {
    /*check today's date with the date in database for question list sync.
    If date is mismatched, question list will be fetched from API and response will be saved(updated) in local database.
    If date is same, then question list will be fetched from db.*/

    var configTable = await ConfigTable.read(
        strField: ConfigFields.pointTestQuestionListSyncDate);
    printLog(configTable?.fieldValue);
    String strLastSyncDate = configTable?.fieldValue ?? '';
    if (strLastSyncDate != "") {
      return strLastSyncDate != Utility.getTodayDate();
    } else {
      return true;
    }
  }

  sendEmailWithTemplate(BuildContext context, String filename, String file,
      FirebaseFirestore fireStoreDb, String? email, String name) async {
    //LoadingWidget.show();
    String docId = "";
    var ref = fireStoreDb.collection(ConfigFields.configFieldEmails).doc();
    docId = ref.id;
    ref.set({
      "to": email,
      "template": {
        "name": StringHelper.pointTestTemplate,
        "data": {
          "subject": StringHelper.occusearchPointScoreSubject,
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

  Future<void> handleResult(BuildContext context, id) async {
    FirebaseFirestore.instance
        .collection(ConfigFields.configFieldEmails)
        .doc(id)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        Map<String, dynamic>? data = event.get("delivery");
        String status = data!["state"];
        // print(data["state"]);

        if (status == ConfigFields.configFieldSuccess) {
          //LoadingWidget.hide();
          loadingEmail.sink.add(false);
          Toast.show(
            context,
            message: StringHelper.pointTestPDFSentMessage,
            gravity: Toast.toastTop,
            duration: 1,
          );
        } else if (status == ConfigFields.configFieldError) {
          //LoadingWidget.hide();
          loadingEmail.sink.add(false);
          Toast.show(context,
              message: StringHelper.emailSendFailedMessage,
              gravity: Toast.toastTop,
              duration: 2);
        }
      }
    });
  }

  // Http API calling to get Point test score...
  Future<bool> getPointTestResult(
      {required bool isFromShare, required userId}) async {
    // isFromShare == [TRUE] if user called this function by clicking on Email or Share button
    final completer = Completer<bool>();

    try {
      reviewQuestionList = [];
      errorMsg = "";

      var param = {NetworkAPIConstant.reqResKeys.userId: userId ?? 0};

      var configTable =
          await ConfigTable.read(strField: ConfigFields.pointTestResultList);

      if (configTable != null && isFromShare) {
        // Convert Point test result question String into List<QuestionData>
        PointTestResultModel pointTestResultModel =
            PointTestResultModel.fromJson(jsonDecode(configTable.fieldValue!));

        // For generate point test pdf file
        pointTestResultJSONStringData = configTable.fieldValue!;

        reviewQuestionList = pointTestResultModel.data![0].questionlist!;

        setTotalPointScoreQuestionList();
        // To calculate the Point test score
        int pointValue = 0;
        for (var quesValue in pointTestResultModel.data![0].questionlist!) {
          for (var element in quesValue.option!) {
            pointValue += int.parse(element.ovalue ?? "0");
          }
        }

        setPointTestResultValue(
          pointValue,
          int.parse(pointTestResultModel.data![0].minimumreqpoint ?? "0"),
          double.parse(pointTestResultModel.data![0].totalpoint ?? "0.0"),
        );
        completer.complete(true);
      } else {
        //setLoaderValue = true;
        BaseResponseModel result =
            await PointTestReviewRepository.getPointTestResult(param);

        if (result.statusCode == Constants.statusCodeForApiData &&
            result.flag == true) {
          PointTestResultModel pointTestResultModel =
              PointTestResultModel.fromJson(result.data);
          if (pointTestResultModel.flag == true &&
              pointTestResultModel.data != null &&
              pointTestResultModel.data![0].questionlist != null &&
              pointTestResultModel.data![0].questionlist!.isNotEmpty) {
            pointTestResultJSONStringData = jsonEncode(
                PointTestResultModel.fromJson(
                    result.data)); // For generate point test pdf file
            reviewQuestionList = pointTestResultModel.data![0].questionlist!;
            setTotalPointScoreQuestionList();

            // Total user point score
            int pointValue = 0;

            for (var quesValue in pointTestResultModel.data![0].questionlist!) {
              for (var element in quesValue.option!) {
                pointValue += int.parse(element.ovalue ?? "0");
              }
            }

            // Store data in DB a config table  if null or update the same

            var configTable = await ConfigTable.read(
                strField: ConfigFields.pointTestResultList);

            if (configTable != null) {
              ConfigTable.deleteConfigData(
                  strField: ConfigFields.pointTestResultList);
            }

            var configPointTestQuestionTable = ConfigTable(
                fieldName: ConfigFields.pointTestResultList,
                fieldValue: jsonEncode(result.data));

            ConfigTable.insertTable(configPointTestQuestionTable.toJson());

            // To calculate the Point test score
            setPointTestResultValue(
              pointValue,
              int.parse(pointTestResultModel.data![0].minimumreqpoint ?? "0"),
              double.parse(pointTestResultModel.data![0].totalpoint ?? "0.0"),
            );
            setLoaderValue = false;
            completer.complete(true);
          } else {
            reviewQuestionList = [];
            setLoaderValue = false;
            completer.complete(true);
          }
        } else if (result.statusCode == Constants.statusCodeForNoInternet) {
          // display point test review data when no internet connection
          var configPointTestData = await ConfigTable.read(
              strField: ConfigFields.pointTestResultList);
          if (configPointTestData != null) {
            int pointValue = 0;
            PointTestResultModel pointTestResultModel =
                PointTestResultModel.fromJson(
                    jsonDecode(configPointTestData.fieldValue!));
            for (var quesValue in pointTestResultModel.data![0].questionlist!) {
              for (var element in quesValue.option!) {
                pointValue += int.parse(element.ovalue ?? "0");
              }
            }
            reviewQuestionList =
                pointTestResultModel.data![0].questionlist ?? [];
            setTotalPointScoreQuestionList();
            setPointTestResultValue(
              pointValue,
              int.parse(pointTestResultModel.data![0].minimumreqpoint ?? "0"),
              double.parse(pointTestResultModel.data![0].totalpoint ?? "0.0"),
            );
            setLoaderValue = false;
            completer.complete(true);
          } else {
            errorMsg = StringHelper.internetConnection;
            Toast.show(_context!,
                message: errorMsg,
                gravity: Toast.toastTop,
                type: Toast.toastError);
            setLoaderValue = false;
            reviewQuestionList = [];
            completer.complete(true);
          }
        } else {
          errorMsg = StringHelper.pointTestFailedToGetPointScore;
          Toast.show(_context!, message: errorMsg, gravity: Toast.toastTop);
          setLoaderValue = false;
          reviewQuestionList = [];
          completer.complete(true);
        }
      }
    } catch (e) {
      completer.complete(false);
      setLoaderValue = false;
      debugPrint(e.toString());
      reviewQuestionList = [];
    }
    return completer.future;
  }

  //Get total point score question list with which questions are attended
  setTotalPointScoreQuestionList() async {
    pointTestQuestionModel ??=
        await PointTestRepository.getPointTestQuestionListFromDb();
    if (pointTestQuestionModel != null &&
        pointTestQuestionModel!.questionlist != null) {
      setPtAllQuesList = pointTestQuestionModel!.questionlist!;

      // To set option selected if user have give answer...
      for (int i = 0; i < ptAllQuesList.value.length; i++) {
        // condition true if question id == answer question id match
        int foundIndex = reviewQuestionList
            .indexWhere((element) => element.id == ptAllQuesList.value[i].id);
        if (foundIndex != -1) {
          ptAllQuesList.value[i].isAttendQuestion = true;
          for (var answeredRow in reviewQuestionList[foundIndex].option!) {
            if (ptAllQuesList.value[i].option != null) {
              for (int j = 0; j < ptAllQuesList.value[i].option!.length; j++) {
                // if user answer/option id is match and selected
                if (answeredRow.oid == ptAllQuesList.value[i].option![j].oid &&
                    answeredRow.isSelected == true) {
                  ptAllQuesList.value[i].option![j].isSelected = true;
                }
              }
            }
          }
        }
      }

      // to add or remove un-necessary question from list
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
        var seen = <int>{};
        // remove duplicate data
        List<int> uniquelist =
            makeActiveQuestion.where((country) => seen.add(country)).toList();

        for (int i = 0; i < temp.length; i++) {
          temp[i].isActiveQues = temp[i].isActiveQues
              ? temp[i].isActiveQues
              : uniquelist.any((element) => element == temp[i].id);
        }

        temp.removeWhere(
            (element) => !element.isPrimaryQues && !element.isActiveQues);

        setPtAllQuesList = temp;
      }
    }
  }

  void setPointTestResultValue(
      int userPoints, int minPoints, double totalPoints) {
    maxPointValue = totalPoints;
    minPointValue.value = minPoints;
    setUserPointsScore = userPoints;
    progressBarValue = (userPoints * 100) / totalPoints;
  }

  Stream<int> get getMinPointValue => minPointValue.stream;
}

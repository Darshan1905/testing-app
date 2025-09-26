// ignore_for_file: depend_on_referenced_packages

import 'package:occusearch/utility/utils.dart';
import 'package:rxdart/rxdart.dart';

class CustomQuestionModel {
  CustomQuestionModel({
      this.flag, 
      this.message, 
      this.outdata, 
      this.outdata1, 
      this.data, 
      this.bytedata,});

  CustomQuestionModel.fromJson(dynamic json) {
    flag = json['flag'];
    message = json['message'];
    outdata = json['outdata'];
    outdata1 = json['outdata1'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    bytedata = json['bytedata'];
  }
  bool? flag;
  String? message;
  dynamic outdata;
  dynamic outdata1;
  Data? data;
  dynamic bytedata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['flag'] = flag;
    map['message'] = message;
    map['outdata'] = outdata;
    map['outdata1'] = outdata1;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['bytedata'] = bytedata;
    return map;
  }

}

class Data {
  Data({
    this.questions,});

  Data.fromJson(dynamic json) {
    if (json['questions'] != null) {
      questions = [];
      json['questions'].forEach((v) {
        questions?.add(CustomQuestions.fromJson(v));
      });
    }
  }
  List<CustomQuestions>? questions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (questions != null) {
      map['questions'] = questions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CustomQuestions {
  CustomQuestions({
    this.questionId,
    this.question,
    this.type,
    this.sequence,
    this.isRequired,
    this.answer,
    this.options,});

  CustomQuestions.fromJson(dynamic json) {
    questionId = json['questionid'];
    question = json['Question'];
    type = json['type'];
    sequence = json['sequence'];
    isRequired = json['isrequired'];
    answer = json['answer'];
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options?.add(CustomQuestionOptions.fromJson(v));
      });
    }
  }
  int? questionId;
  String? question;
  String? type;
  int? sequence;
  bool? isRequired;
  String? answer; // we set all selected here -User's answer [option id]
  List<CustomQuestionOptions>? options;
  bool? primary = true; // default true set by our side and then change based on user option selection - [childQuestionId]
  bool? isAttempted = false; // For manage pending dashboard custom questions

  //To store answer given by user
  final _userAnswer = BehaviorSubject<String>.seeded("");

  //GET
  Stream<String> get answerStream => _userAnswer.stream;

  //SET
  void setCustomQuestionAnswer(String ans, bool isFromDashboard) {
    answer = ans;
    _userAnswer.sink.add(ans);
    printLog("Question answer : ${_userAnswer.value}");

    //IF WE CAME FROM DASHBOARD AND ANSWER NOT NULL
    if(isFromDashboard){
      isAttempted = false;
    }
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['questionid'] = questionId;
    map['Question'] = question;
    map['type'] = type;
    map['sequence'] = sequence;
    map['isrequired'] = isRequired;
    map['answer'] = answer;
    if (options != null) {
      map['options'] = options?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CustomQuestionOptions {
  CustomQuestionOptions({
    this.optionId,
    this.childQuestionId,
    this.answer,});

  CustomQuestionOptions.fromJson(dynamic json) {
    optionId = json['optionid'];
    childQuestionId = json['child_question_id'];
    answer = json['answer'];
  }
  int? optionId;
  int? childQuestionId;
  String? answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['optionid'] = optionId;
    map['child_question_id'] = childQuestionId;
    map['answer'] = answer;
    return map;
  }

}


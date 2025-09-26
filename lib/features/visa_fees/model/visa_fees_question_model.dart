class VisaFeesQuestionModel {
  bool? flag;
  String? message;
  List<QuestionList>? data;

  VisaFeesQuestionModel({this.flag, this.message, this.data});

  VisaFeesQuestionModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <QuestionList>[];
      json['data'].forEach((v) {
        data!.add(QuestionList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionList {
  String? questionId;
  String? question;
  String? type;
  String? options;

  QuestionList({this.questionId, this.question, this.type, this.options});

  QuestionList.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    question = json['question'];
    type = json['type'];
    options = json['options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question'] = question;
    data['type'] = type;
    data['options'] = options;
    return data;
  }
}

class CustomQuestionAnswerModel {
   CustomQuestionAnswerModel({
      this.questionid,
      this.answer,
   });

   CustomQuestionAnswerModel.fromJson(dynamic json) {
      questionid = json['questionid'];
      answer = json['answer'];
   }
   int? questionid;
   String? answer;

   Map<String, dynamic> toJson() {
      final map = <String, dynamic>{};
      map['questionid'] = questionid;
      map['answer'] = answer;
      return map;
   }
}
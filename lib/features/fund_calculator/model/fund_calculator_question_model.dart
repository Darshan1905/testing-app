import 'dart:ui';
import 'package:occusearch/utility/utils.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';

class FundCalculatorQuestionModel {
  List<FundCalculatorQuestion>? fundCalculatorQuestion;
  double fundTotal = 0.0; // Total fund
  List<OtherLivingQuestion>? otherLivingQuestion;
  double livingTotal = 0.0;

  FundCalculatorQuestionModel(
      {this.fundCalculatorQuestion, this.otherLivingQuestion});

  FundCalculatorQuestionModel.fromJson(Map<String, dynamic> json) {
    if (json['fund_calculator_question'] != null) {
      fundCalculatorQuestion = <FundCalculatorQuestion>[];
      json['fund_calculator_question'].forEach((v) {
        fundCalculatorQuestion!.add(FundCalculatorQuestion.fromJson(v));
      });
    }
    if (json['other_living_question'] != null) {
      otherLivingQuestion = <OtherLivingQuestion>[];
      json['other_living_question'].forEach((v) {
        otherLivingQuestion!.add(OtherLivingQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fundCalculatorQuestion != null) {
      data['fund_calculator_question'] =
          fundCalculatorQuestion!.map((v) => v.toJson()).toList();
    }
    if (otherLivingQuestion != null) {
      data['other_living_question'] =
          otherLivingQuestion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FundCalculatorQuestion {
  num? amount;
  String? category;
  bool? mandatory;
  String? note;
  int? questionId;
  String? questionLabel;
  String? questionTitle;
  List<Options>? options;
  String answer = ""; // user given answer [String, double, int, boolean etc]
  double answerAmount = 0.0; // amount based on user given answer
  double categoryWiseTotalAmt = 0.0; // category group wise amount total
  String selectedOptionValue = ""; // selected option value name
  int? percentage = 0; // percentage set

  // WHATEVER ANSWER USER GIVE, WE STORE HERE
  final _answer = BehaviorSubject<String>.seeded("");

  clearAnswer() => _answer.sink.add('');

  Stream<String> get answerStream => _answer.stream;

  get getAnswerStreamValue => _answer.stream.value;

  void setAnswer(String ans, double amount) {
    answer = ans;
    answerAmount = amount;
    categoryWiseTotalAmt = amount;
    _answer.sink.add(ans);
    printLog("Question answer : ${_answer.value}");
  }

  FundCalculatorQuestion(
      {this.amount,
      this.category,
      this.mandatory,
      this.note,
      this.questionId,
      this.questionLabel,
      this.questionTitle,
      this.options});

  FundCalculatorQuestion.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    category = json['category'];
    mandatory = json['mandatory'];
    note = json['note'];
    questionId = json['question_id'];
    questionLabel = json['question_label'];
    questionTitle = json['question_title'];
    answer = json['answer'] ?? "";
    answerAmount = json['answerAmount'] ?? 0.0;
    categoryWiseTotalAmt = json['categoryWiseTotalAmt'] ?? 0.0;
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['category'] = category;
    data['mandatory'] = mandatory;
    data['note'] = note;
    data['question_id'] = questionId;
    data['question_label'] = questionLabel;
    data['question_title'] = questionTitle;
    data['answer'] = answer;
    data['answerAmount'] = answerAmount;
    data['categoryWiseTotalAmt'] = categoryWiseTotalAmt;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  num? amount;
  String? option;
  int? optionId;
  bool isSelected = false; // user is selected this or not

  Options({this.amount, this.option, this.optionId});

  Options.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    option = json['option'];
    optionId = json['option_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['option'] = option;
    data['option_id'] = optionId;
    return data;
  }
}

// *************** Living cost model class  **************

class OtherLivingQuestion {
  String? category;
  String? note;
  List<AccommodationOptions>? accommodationOptions;
  List<LivingCostOptions>? options;
  int? questionId;
  String? questionTitle;

  String? answer = ""; // user given answer [String, double, int, boolean etc]
  double? estimatedCost;
  double answerAmount = 0.0; // amount based on user given answer
  double categoryWiseTotalAmt = 0.0; // category group wise amount total
  String? selectedAnswer = ""; // FOR SUMMARY PAGE NAME DISPLAY
  int? percentage = 0; //other living percentage store

  // WHATEVER ANSWER USER GIVE, WE STORE HERE
  final _answer = BehaviorSubject<String>.seeded("");

  clearAnswer() => _answer.sink.add('');

  Stream<String> get answerStream => _answer.stream;

  void setAnswerOtherLiving(String ans, double amount,
      [OtherLivingQuestion? questionData]) {
    answer = ans;
    answerAmount = amount;
    categoryWiseTotalAmt = amount;
    _answer.sink.add(ans);
    printLog("Question answer : ${_answer.value}");
  }

  OtherLivingQuestion(
      {this.category,
      this.note,
      this.accommodationOptions,
      this.options,
      this.questionId,
      this.questionTitle});

  OtherLivingQuestion.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    note = json['note'];
    if (json['accommodation_options'] != null) {
      accommodationOptions = <AccommodationOptions>[];
      json['accommodation_options'].forEach((v) {
        accommodationOptions!.add(AccommodationOptions.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = <LivingCostOptions>[];
      json['options'].forEach((v) {
        options!.add(LivingCostOptions.fromJson(v));
      });
    }
    questionId = json['question_id'];
    questionTitle = json['question_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['note'] = note;
    if (accommodationOptions != null) {
      data['accommodation_options'] =
          accommodationOptions!.map((v) => v.toJson()).toList();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['question_id'] = questionId;
    data['question_title'] = questionTitle;
    return data;
  }
}

class AccommodationOptions {
  List<StudyCityAmount>? studyCityAmount;
  String? option;
  int? optionId;

  var isSelected = false;

  AccommodationOptions({this.studyCityAmount, this.option, this.optionId});

  AccommodationOptions.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    optionId = json['option_id'];
    if (json['study_city_amount'] != null) {
      studyCityAmount = <StudyCityAmount>[];
      json['study_city_amount'].forEach((v) {
        studyCityAmount!.add(StudyCityAmount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['option'] = option;
    data['option_id'] = optionId;
    if (studyCityAmount != null) {
      data['study_city_amount'] =
          studyCityAmount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudyCityAmount {
  int? cityAmount;
  int? cityId;
  String? cityRangeAmount;
  int? suburbsAmount;
  String? suburbsRangeAmount;

  StudyCityAmount(
      {this.cityAmount,
      this.cityId,
      this.cityRangeAmount,
      this.suburbsAmount,
      this.suburbsRangeAmount});

  StudyCityAmount.fromJson(Map<String, dynamic> json) {
    cityAmount = json['city_amount'];
    cityId = json['city_id'];
    cityRangeAmount = json['city_range_amount'];
    suburbsAmount = json['suburbs_amount'];
    suburbsRangeAmount = json['suburbs_range_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city_amount'] = cityAmount;
    data['city_id'] = cityId;
    data['city_range_amount'] = cityRangeAmount;
    data['suburbs_amount'] = suburbsAmount;
    data['suburbs_range_amount'] = suburbsRangeAmount;
    return data;
  }
}

class LivingCostOptions {
  int? amount;
  String? option;
  String? optionAmount;
  int? optionId;

  bool isSelected = false; //selected options

  LivingCostOptions(
      {this.amount, this.option, this.optionId, this.optionAmount});

  LivingCostOptions.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    option = json['option'];
    optionId = json['option_id'];
    optionAmount = json['option_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['option'] = option;
    data['option_id'] = optionId;
    data['option_amount'] = optionAmount;
    return data;
  }
}

class LivingCostSummaryData {
  final String category;
  final double categoryCost;
  final String answer;
  final String categoryIcon;
  double percentage;
  final Color themeColor;

  LivingCostSummaryData(this.category, this.categoryCost, this.answer,
      this.categoryIcon, this.percentage, this.themeColor);
}

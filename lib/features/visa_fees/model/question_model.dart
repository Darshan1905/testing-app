// ignore_for_file: depend_on_referenced_packages

import 'package:occusearch/features/visa_fees/model/visa_subclass_model.dart';
import 'package:rxdart/rxdart.dart';

class VisaQuestionApplicantModel {
  String title = "";
  int count = 0;
  bool isPrimaryApplicant = false;
  List<QuestionModel>? questionList;

  set setPrimaryApplicant(isPrimaryApplicant) =>
      this.isPrimaryApplicant = isPrimaryApplicant;

  String get getTitle => title;

  set setTitle(title) => this.title = title;

  set setQuestionList(questionList) => this.questionList = questionList;

  List<QuestionModel> get getQuestionList => questionList ?? [];

  VisaQuestionApplicantModel copyWith(String title, int count,
      bool isPrimaryApplicant, List<QuestionModel>? questionList) {
    VisaQuestionApplicantModel model = VisaQuestionApplicantModel();
    model.title = title;
    model.count = count;
    model.isPrimaryApplicant = isPrimaryApplicant;
    List<QuestionModel> temp = [];
    questionList?.forEach((question) {
      temp.add(QuestionModel(
              title: question.getTitle,
              questionId: question.getQuestionID,
              question: question.question,
              type: question.type,
              options: question.options,
              selectedOption: question.selectedOption,
              selectedSubclass: question.selectedSubclass)
          .copyWith(
              title: question.getTitle,
              questionId: question.getQuestionID,
              question: question.question,
              type: question.type,
              options: question.options,
              selectedOption: question.selectedOption,
              selectedSubclass: question.selectedSubclass));
    });
    model.questionList = temp;
    return model;
  }
}

class QuestionModel {
  String? title;
  String? questionId;
  String? question;
  String? type;
  String? options;
  bool selectedOption; // user selected option
  SubclassData? selectedSubclass;

  QuestionModel({
    required this.title,
    required this.questionId,
    required this.question,
    required this.type,
    required this.options,
    required this.selectedOption,
    this.selectedSubclass,
  });

  QuestionModel copyWith({
    required String? title,
    required String? questionId,
    required String? question,
    required String? type,
    required String? options,
    required bool selectedOption,
    SubclassData? selectedSubclass,
  }) {
    setOptionStream = selectedOption;
    if (selectedSubclass != null) {
      setSubclassStream = selectedSubclass;
    }
    return QuestionModel(
        title: title,
        questionId: questionId,
        question: question,
        type: type,
        options: options,
        selectedOption: selectedOption,
        selectedSubclass: selectedSubclass);
  }

  // RADIO BUTTON SELECTION
  final selectedOptionStream = BehaviorSubject<bool>.seeded(false);

  set setOptionStream(bool flag) {
    selectedOptionStream.sink.add(flag);
    selectedOption = flag;
  }

  // SUBCLASS SELECTION
  final selectedSubclassStream = BehaviorSubject<SubclassData>();

  set setSubclassStream(SubclassData subClass) {
    selectedSubclassStream.sink.add(subClass);
    selectedSubclass = subClass;
  }

  set setTitle(title) => this.title = title;

  set setQuestionID(id) => questionId = id;

  set setSelectedOption(option) => selectedOption = option;

  set setSelectedSubclass(subclass) => selectedSubclass = subclass;

  String get getTitle => title ?? "";

  String get getQuestionID => questionId ?? "";

  bool get getSelectedOption => selectedOption;

  SubclassData get getSelectedVisaSubclass =>
      selectedSubclass ?? SubclassData();
}

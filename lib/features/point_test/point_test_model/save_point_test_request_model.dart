class SavePointTestModel {
  int? userId;
  List<SelectedAnswers>? selectedAnswers;

  SavePointTestModel({this.userId, this.selectedAnswers});

  SavePointTestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    if (json['selectedAnswers'] != null) {
      selectedAnswers = <SelectedAnswers>[];
      json['selectedAnswers'].forEach((v) {
        selectedAnswers!.add(SelectedAnswers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (selectedAnswers != null) {
      data['selectedAnswers'] =
          selectedAnswers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectedAnswers {
  String? calculatortype;
  String? sourceurl;
  String? minimumreqpoint;
  String? totalpoint;
  List<SaveQuestionlist>? questionlist;

  SelectedAnswers({this.calculatortype, this.sourceurl, this.questionlist});

  SelectedAnswers.fromJson(Map<String, dynamic> json) {
    calculatortype = json['calculatortype'];
    sourceurl = json['sourceurl'];
    minimumreqpoint = json['minimumreqpoint'];
    totalpoint = json['totalpoint'];
    if (json['questionlist'] != null) {
      questionlist = <SaveQuestionlist>[];
      json['questionlist'].forEach((v) {
        questionlist!.add(SaveQuestionlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['calculatortype'] = calculatortype;
    data['sourceurl'] = sourceurl;
    data['minimumreqpoint'] = minimumreqpoint;
    data['totalpoint'] = totalpoint;
    if (questionlist != null) {
      data['questionlist'] = questionlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SaveQuestionlist {
  int? id;
  String? qname;
  String? qtype;
  List<SaveOption>? option;

  SaveQuestionlist({this.id, this.qname, this.qtype, this.option});

  SaveQuestionlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qname = json['qname'];
    qtype = json['qtype'];
    if (json['option'] != null) {
      option = <SaveOption>[];
      json['option'].forEach((v) {
        option!.add(SaveOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['qname'] = qname;
    data['qtype'] = qtype;
    if (option != null) {
      data['option'] = option!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SaveOption {
  int? oid;
  String? oname;
  String? ovalue;
  List<Displayquestion>? displayquestion;
  bool? isSelected;

  SaveOption(
      {this.oid,
      this.oname,
      this.ovalue,
      this.displayquestion,
      this.isSelected});

  SaveOption.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    oname = json['oname'];
    ovalue = json['ovalue'];
    if (json['displayquestion'] != null) {
      displayquestion = <Displayquestion>[];
      json['displayquestion'].forEach((v) {
        displayquestion!.add(Displayquestion.fromJson(v));
      });
    }
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['oname'] = oname;
    data['ovalue'] = ovalue;
    if (displayquestion != null) {
      data['displayquestion'] =
          displayquestion!.map((v) => v.toJson()).toList();
    }
    data['isSelected'] = isSelected;
    return data;
  }
}

class Displayquestion {
  int? qid;

  Displayquestion({this.qid});

  Displayquestion.fromJson(Map<String, dynamic> json) {
    qid = json['qid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qid'] = qid;
    return data;
  }
}

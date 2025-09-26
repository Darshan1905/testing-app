class PointTestResultModel {
  bool? flag;
  String? message;
  List<Data>? data;

  PointTestResultModel(
      {this.flag,
      this.message,
      this.data});

  PointTestResultModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? calculatortype;
  String? sourceurl;
  String? minimumreqpoint;
  String? totalpoint;
  List<QuestionScorelist>? questionlist;

  Data(
      {this.calculatortype,
      this.sourceurl,
      this.minimumreqpoint,
      this.totalpoint,
      this.questionlist});

  Data.fromJson(Map<String, dynamic> json) {
    calculatortype = json['calculatortype'];
    sourceurl = json['sourceurl'];
    minimumreqpoint = json['minimumreqpoint'];
    totalpoint = json['totalpoint'];
    if (json['questionlist'] != null) {
      questionlist = <QuestionScorelist>[];
      json['questionlist'].forEach((v) {
        questionlist!.add(QuestionScorelist.fromJson(v));
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

class QuestionScorelist {
  int? id;  // Question ID
  String? qname;
  String? qtype;
  List<Option>? option;

  QuestionScorelist({this.id, this.qname, this.qtype, this.option});

  QuestionScorelist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qname = json['qname'];
    qtype = json['qtype'];
    if (json['option'] != null) {
      option = <Option>[];
      json['option'].forEach((v) {
        option!.add(Option.fromJson(v));
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

class Option {
  int? oid;
  String? oname;
  String? ovalue;
  bool? isSelected;

  Option({this.oid, this.oname, this.ovalue, this.isSelected});

  Option.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    oname = json['oname'];
    ovalue = json['ovalue'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['oname'] = oname;
    data['ovalue'] = ovalue;
    data['isSelected'] = isSelected;
    return data;
  }
}

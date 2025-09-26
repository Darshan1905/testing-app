import 'package:occusearch/data_provider/api_service/base_response_model.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';

class PointTestQuesModel extends BaseResponseModel {
  List<PointTestQuestionModelData>? pointTestQuesData;

  PointTestQuesModel({this.pointTestQuesData});

  PointTestQuesModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PointTestQuestionModelData>[];
      json['data'].forEach((v) {
        data!.add(PointTestQuestionModelData.fromJson(v));
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

class PointTestQuestionModelData {
  String? calculatortype;
  String? sourceurl;
  String? minimumreqpoint;
  String? totalpoint;
  List<Questionlist>? questionlist;

  PointTestQuestionModelData(
      {this.calculatortype, this.sourceurl, this.questionlist});

  PointTestQuestionModelData.fromJson(Map<String, dynamic> json) {
    calculatortype = json['calculatortype'];
    sourceurl = json['sourceurl'];
    minimumreqpoint = json['minimumreqpoint'];
    totalpoint = json['totalpoint'];
    if (json['questionlist'] != null) {
      questionlist = <Questionlist>[];
      json['questionlist'].forEach((v) {
        questionlist!.add(Questionlist.fromJson(v));
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

class Questionlist {
  int? id; // Question ID
  String? qname;
  String? qtype;
  bool isPrimaryQues = false; // [TRUE] question is primary
  bool isActiveQues = false; // [TRUE] question is visible/displayable
  int refQuesID = 0; // If question is not primary, give parent question ID
  bool isAttendQuestion =
      false; // Review point test screen only: To set flag if question is attend by user
  int priority = 0;
  List<Option>? option;

  Questionlist({this.id, this.qname, this.qtype, this.option});

  Questionlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qname = json['qname'];
    qtype = json['qtype'];
    priority = json['priority'] ?? 0;
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
    data['priority'] = priority;
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
  List<Displayquestion>? displayquestion;
  bool isSelected1 = false;
  final selection = BehaviorSubject<
      bool>(); //Added this var to reflect instant selection to the option selection(select/deselect)

  get isSelected => isSelected1;

  set isSelected(flag) {
    isSelected1 = flag;
    selection.sink.add(flag);
  }

  Option({this.oid, this.oname, this.ovalue, this.displayquestion});

  Option.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    oname = json['oname'];
    ovalue = json['ovalue'];
    if (json['displayquestion'] != null) {
      displayquestion = <Displayquestion>[];
      json['displayquestion'].forEach((v) {
        displayquestion!.add(Displayquestion.fromJson(v));
      });
    }
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

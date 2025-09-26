class PointTestReviewQuesModel {
  bool? flag;
  String? message;
  List<Data>? data;

  PointTestReviewQuesModel({this.flag, this.message, this.data});

  PointTestReviewQuesModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? qname;
  String? qtype;
  int? oid;
  String? oname;
  String? ovalue;

  Data({this.id, this.qname, this.qtype, this.oid, this.oname, this.ovalue});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qname = json['qname'];
    qtype = json['qtype'];
    oid = json['oid'];
    oname = json['oname'];
    ovalue = json['ovalue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['qname'] = qname;
    data['qtype'] = qtype;
    data['oid'] = oid;
    data['oname'] = oname;
    data['ovalue'] = ovalue;
    return data;
  }
}
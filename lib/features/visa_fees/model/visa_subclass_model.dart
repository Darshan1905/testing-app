import 'package:occusearch/constants/constants.dart';

class VisaSubclassModel {
  bool? flag;
  String? message;
  List<SubclassData>? data;

  VisaSubclassModel({this.flag, this.message, this.data});

  VisaSubclassModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubclassData>[];
      json['data'].forEach((v) {
        data!.add(SubclassData.fromJson(v));
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

class SubclassData {
  String? id;
  String? name;
  int? type;
  String? alphabet = "";
  Color alphabetColor = Utility.getRandomBGVisaListScreenColor();

  SubclassData({this.id, this.name, this.type});

  SubclassData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    //alphabet added
    if(name != null){
      alphabet = name?.substring(0, 1).toUpperCase();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}

class AlphabetCategory {
  String? alphabet;
  List<SubclassData>? list;
  AlphabetCategory({this.alphabet, this.list});
}


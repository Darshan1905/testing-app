// ignore_for_file: depend_on_referenced_packages

import 'package:occusearch/utility/utils.dart';
import 'package:rxdart/rxdart.dart';

class CoursesFilterModel {
  bool? flag;
  String? message;
  Data? data;

  CoursesFilterModel({this.flag, this.message, this.data});

  CoursesFilterModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<FilterModel>? broad;
  List<FilterModel>? narrow;
  List<FilterModel>? detailed;
  List<FilterModel>? state;
  List<FilterModel>? courseLevel;

  Data({this.broad, this.narrow, this.detailed, this.state, this.courseLevel});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['broad'] != null) {
      broad = <FilterModel>[];
      json['broad'].forEach((v) {
        broad!.add(FilterModel.fromJson(v));
      });
    }
    if (json['narrow'] != null) {
      narrow = <FilterModel>[];
      json['narrow'].forEach((v) {
        narrow!.add(FilterModel.fromJson(v));
      });
    }
    if (json['detailed'] != null) {
      detailed = <FilterModel>[];
      json['detailed'].forEach((v) {
        detailed!.add(FilterModel.fromJson(v));
      });
    }
    if (json['state'] != null) {
      state = <FilterModel>[];
      json['state'].forEach((v) {
        state!.add(FilterModel.fromJson(v));
      });
    }
    if (json['course_level'] != null) {
      courseLevel = <FilterModel>[];
      json['course_level'].forEach((v) {
        courseLevel!.add(FilterModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (broad != null) {
      data['broad'] = broad!.map((v) => v.toJson()).toList();
    }
    if (narrow != null) {
      data['narrow'] = narrow!.map((v) => v.toJson()).toList();
    }
    if (detailed != null) {
      data['detailed'] = detailed!.map((v) => v.toJson()).toList();
    }
    if (state != null) {
      data['state'] = state!.map((v) => v.toJson()).toList();
    }
    if (courseLevel != null) {
      data['course_level'] = courseLevel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterModel {
  String? id;
  String? name;
  String? value;

  FilterModel.fromJson(Map<String, dynamic> json) {
    // Split name data for handling filter data for course level, broad and so on
    // to display only checked value related in all remaining course blocs.
    name = json['name'];
    final regExp = RegExp('[A-Z]');
    final isAllInUpperCase = regExp.hasMatch(name ?? "");
    if (json['name'] != null && json['name'] != '' && (json['name'] as String).contains("-")) {
      List<String> substrings = name!.trim().split("-");
      id = substrings[0].trim();
      value = substrings[1].trimLeft();
    }else if(isAllInUpperCase){
         name=Utility.getFullNameOfAUState(name ?? "");
         id = json['name'];
         value = json['name'];
    } else {
      id = json['name'];
      value = json['name'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class FilterModelData {
  String? title;
  String? apiKey;
  final selectedAnswerStream = BehaviorSubject<FilterModel?>();
  bool isDepended = false;
  int dependedIndex = 0;
  List<FilterModel>? filterList;

  FilterModelData(this.title, this.apiKey, this.filterList, this.isDepended,
      this.dependedIndex);
}

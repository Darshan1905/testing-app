import 'package:occusearch/features/occupation_search/occupation_detail_model/so_state_eligibility_detail_model.dart';

class StateEligibilityStateWiseModel {
  bool? flag;
  String? message;
  String visaTypeCode = "0";
  String visaTypeTitle = "";
  StateEligibilityData? data;

  StateEligibilityStateWiseModel({this.flag, this.message, this.data});

  StateEligibilityStateWiseModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null
        ? StateEligibilityData.fromJson(json['data'])
        : null;
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

class StateEligibilityData {
  List<StateEligibilityDetailRowData>? stateList;

  StateEligibilityData({this.stateList});

  StateEligibilityData.fromJson(Map<String, dynamic> json) {
    if (json['state_list'] != null) {
      stateList = <StateEligibilityDetailRowData>[];
      json['state_list'].forEach((v) {
        stateList!.add(StateEligibilityDetailRowData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stateList != null) {
      data['state_list'] = stateList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateEligibilityDetailRowData {
  String? stateId;
  String? state;
  String? territoryNomination;
  String? link;
  String? condition;
  int? isOpen;
  String? classColor;
  List<StateCondition>? stateCondition;
  bool isExpanded = false;

  StateEligibilityDetailRowData(
      {this.stateId,
      this.state,
      this.territoryNomination,
      this.link,
      this.condition,
      this.isOpen,
      this.classColor,
      this.stateCondition});

  StateEligibilityDetailRowData.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    state = json['state'];
    territoryNomination = json['territory_nomination'];
    link = json['link'];
    condition = json['condition'];
    isOpen = json['is_open'];
    classColor = json['class'];
    if (json['stateCondition'] != null) {
      stateCondition = <StateCondition>[];
      json['stateCondition'].forEach((v) {
        stateCondition!.add(StateCondition.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state_id'] = stateId;
    data['state'] = state;
    data['territory_nomination'] = territoryNomination;
    data['link'] = link;
    data['condition'] = condition;
    data['is_open'] = isOpen;
    data['class'] = classColor;
    if (stateCondition != null) {
      data['stateCondition'] =
          stateCondition!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateCondition {
  String? state;
  String? region;
  String? occupationCode;
  String? visaType;
  String? condition;
  String? link;
  bool isExpanded = false;
  StateEligibilityDetailModel? stateEligibilityDetailModel;
  bool? isGeneralEligibilityExpanded = false;
  bool? isSpecialRequirementExpanded = false;
  bool? isOccRequirementExpanded = false;

  StateCondition(
      {this.state,
      this.region,
      this.occupationCode,
      this.visaType,
      this.condition,
      this.link});

  StateCondition.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    region = json['region'];
    occupationCode = json['occupation_code'];
    visaType = json['visa_type'];
    condition = json['condition'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['region'] = region;
    data['occupation_code'] = occupationCode;
    data['visa_type'] = visaType;
    data['condition'] = condition;
    data['link'] = link;
    return data;
  }
}

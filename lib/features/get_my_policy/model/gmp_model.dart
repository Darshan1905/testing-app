class GetMyPolicyModel {
  List<PolicyData>? oVHCVisaType;
  List<PolicyData>? oVHCCoverType;
  List<PolicyData>? oVHCProviders;
  List<PolicyData>? oSHCCoverType;

  GetMyPolicyModel({this.oVHCVisaType, this.oVHCCoverType, this.oVHCProviders, this.oSHCCoverType});

  GetMyPolicyModel.fromJson(Map<String, dynamic> json) {
    if (json['OVHC_Visa_Type'] != null) {
      oVHCVisaType = <PolicyData>[];
      json['OVHC_Visa_Type'].forEach((v) {
        oVHCVisaType!.add(PolicyData.fromJson(v));
      });
    }
    if (json['OVHC_Cover_Type'] != null) {
      oVHCCoverType = <PolicyData>[];
      json['OVHC_Cover_Type'].forEach((v) {
        oVHCCoverType!.add(PolicyData.fromJson(v));
      });
    }
    if (json['OVHC_Providers'] != null) {
      oVHCProviders = <PolicyData>[];
      json['OVHC_Providers'].forEach((v) {
        oVHCProviders!.add(PolicyData.fromJson(v));
      });
    }
    if (json['OSHC_Cover_Type'] != null) {
      oSHCCoverType = <PolicyData>[];
      json['OSHC_Cover_Type'].forEach((v) {
        oSHCCoverType!.add(PolicyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (oVHCVisaType != null) {
      data['OVHC_Visa_Type'] = oVHCVisaType!.map((v) => v.toJson()).toList();
    }
    if (oVHCCoverType != null) {
      data['OVHC_Cover_Type'] = oVHCCoverType!.map((v) => v.toJson()).toList();
    }
    if (oVHCProviders != null) {
      data['OVHC_Providers'] = oVHCProviders!.map((v) => v.toJson()).toList();
    }
    if (oSHCCoverType != null) {
      data['OSHC_Cover_Type'] = oSHCCoverType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PolicyData {
  int? id;
  String? name;
  String? subClass;

  PolicyData({this.id, this.name, this.subClass});

  PolicyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subClass = json['sub_class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sub_class'] = subClass;
    return data;
  }
}

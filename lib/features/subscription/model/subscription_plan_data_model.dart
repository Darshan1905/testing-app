class SubscriptionPlanDataModel {
  bool? flag;
  String? message;
  dynamic outdata;
  dynamic outdata1;
  List<SubscriptionPlanData>? data;
  dynamic bytedata;

  SubscriptionPlanDataModel(
      {this.flag,
        this.message,
        this.outdata,
        this.outdata1,
        this.data,
        this.bytedata});

  SubscriptionPlanDataModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    outdata = json['outdata'];
    outdata1 = json['outdata1'];
    if (json['data'] != null) {
      data = <SubscriptionPlanData>[];
      json['data'].forEach((v) {
        data!.add(SubscriptionPlanData.fromJson(v));
      });
    }
    bytedata = json['bytedata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    data['outdata'] = outdata;
    data['outdata1'] = outdata1;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['bytedata'] = bytedata;
    return data;
  }
}

class SubscriptionPlanData {
  int? planId;
  String? name;
  String? description;
  double? planPrice;
  String? planBillingCycle;
  String? planDuration;
  List<Features>? features;
  String? productID;

  SubscriptionPlanData(
      {this.planId,
        this.name,
        this.description,
        this.planPrice,
        this.planBillingCycle,
        this.planDuration,
        this.features,
        this.productID});

  SubscriptionPlanData.fromJson(Map<String, dynamic> json) {
    planId = json['PlanId'];
    name = json['Name'];
    description = json['Description'];
    planPrice = json['PlanPrice'];
    planBillingCycle = json['PlanBillingCycle'];
    planDuration = json['PlanDuration'];
    if (json['Features'] != null) {
      features = <Features>[];
      json['Features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
    productID = json['productID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PlanId'] = planId;
    data['Name'] = name;
    data['Description'] = description;
    data['PlanPrice'] = planPrice;
    data['PlanBillingCycle'] = planBillingCycle;
    data['PlanDuration'] = planDuration;
    if (features != null) {
      data['Features'] = features!.map((v) => v.toJson()).toList();
    }
    data['productID'] = productID;
    return data;
  }
}

class Features {
  int? featureId;
  String? featureName;
  String? featureDetail;
  int? isPriority;
  String? featureDesc;
  String? isActive;

  Features(
      {this.featureId, this.featureName, this.featureDetail, this.isActive});

  Features.fromJson(Map<String, dynamic> json) {
    featureId = json['featureId'];
    featureName = json['feature_name'];
    featureDetail = json['featureDetail'];
    featureDesc = json['featuredesc'];
    isPriority = json['isPriority'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['featureId'] = featureId;
    data['feature_name'] = featureName;
    data['featureDetail'] = featureDetail;
    data['featuredesc'] = featureDesc;
    data['isPriority'] = isPriority;
    data['is_active'] = isActive;
    return data;
  }
}

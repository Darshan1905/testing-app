class PlanCompareModel {
  String? featureName;
  dynamic featureDesc;
  dynamic freePlan;
  dynamic basicPlan; //basic plan
  dynamic premiumPlan;

  PlanCompareModel(
      {this.featureName,
      this.featureDesc,
      this.freePlan,
      this.basicPlan,
      this.premiumPlan});

  PlanCompareModel.fromJson(Map<String, dynamic> json) {
    featureName = json['feature_name'];
    featureDesc = json['featureDesc'];
    freePlan = json['free_plan'];
    basicPlan = json['basic_plan'];
    premiumPlan = json['premium_plan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feature_name'] = featureName;
    data['featureDesc'] = featureDesc;
    data['free_plan'] = freePlan;
    data['basic_plan'] = basicPlan;
    data['premium_plan'] = premiumPlan;
    return data;
  }
}

class MySubscriptionPlanTransHistoryModel {
  bool? flag;
  String? message;
  dynamic outdata;
  dynamic outdata1;
  List<SubPlanTransHistoryData>? data;
  dynamic bytedata;

  MySubscriptionPlanTransHistoryModel(
      {this.flag,
      this.message,
      this.outdata,
      this.outdata1,
      this.data,
      this.bytedata});

  MySubscriptionPlanTransHistoryModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    outdata = json['outdata'];
    outdata1 = json['outdata1'];
    if (json['data'] != null) {
      data = <SubPlanTransHistoryData>[];
      json['data'].forEach((v) {
        data!.add(SubPlanTransHistoryData.fromJson(v));
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

class SubPlanTransHistoryData {
  int? subscriptionId;
  String? orderId;
  String? productID;
  int? planId;
  String? name;
  String? description;
  String? price;
  String? billingCycle;
  String? startDate;
  String? endDate;
  int? remainingDays;
  String? currency;

  SubPlanTransHistoryData(
      {this.subscriptionId,
      this.orderId,
      this.productID,
      this.planId,
      this.name,
      this.description,
      this.price,
      this.billingCycle,
      this.startDate,
      this.endDate,
      this.remainingDays,
      this.currency});

  SubPlanTransHistoryData.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscription_id'];
    orderId = json['orderId'];
    productID = json['productID'];
    planId = json['plan_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    billingCycle = json['billing_cycle'];
    if (json['start_date'] != null) {
      startDate = json['start_date'];

    }
    endDate = json['end_date'];
    remainingDays = json['remaining_days'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscription_id'] = subscriptionId;
    data['orderId'] = orderId;
    data['productID'] = productID;
    data['plan_id'] = planId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['billing_cycle'] = billingCycle;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['remaining_days'] = remainingDays;
    data['currency'] = currency;
    return data;
  }
}

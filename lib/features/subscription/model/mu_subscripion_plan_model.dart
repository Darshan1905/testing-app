class MySubscriptionPlanModel {
  bool? flag;
  String? message;
  dynamic outdata;
  dynamic outdata1;
  List<MySubscriptionPlanData>? data;
  dynamic bytedata;

  MySubscriptionPlanModel(
      {this.flag,
      this.message,
      this.outdata,
      this.outdata1,
      this.data,
      this.bytedata});

  MySubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    outdata = json['outdata'];
    outdata1 = json['outdata1'];
    if (json['data'] != null) {
      data = <MySubscriptionPlanData>[];
      json['data'].forEach((v) {
        data!.add(MySubscriptionPlanData.fromJson(v));
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

class MySubscriptionPlanData {
  int? subscriptionId;
  int? planId;
  String? orderId;
  String? productID;
  String? name;
  String? description;
  String? price;
  String? billingCycle;
  String? startDate;
  String? endDate;
  int? remainingDays;
  String? currency;
  bool? isdelete;

  MySubscriptionPlanData(
      {this.subscriptionId,
      this.planId,
      this.orderId,
      this.productID,
      this.name,
      this.description,
      this.price,
      this.billingCycle,
      this.startDate,
      this.endDate,
      this.remainingDays,
      this.currency,
      this.isdelete});

  MySubscriptionPlanData.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscription_id'];
    planId = json['plan_id'];
    orderId = json['orderId'];
    productID = json['productID'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    billingCycle = json['billing_cycle'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    remainingDays = json['remaining_days'];
    currency = json['currency'];
    isdelete = json['isdelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscription_id'] = subscriptionId;
    data['plan_id'] = planId;
    data['orderId'] = orderId;
    data['productID'] = productID;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['billing_cycle'] = billingCycle;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['remaining_days'] = remainingDays;
    data['currency'] = currency;
    data['isdelete'] = isdelete;
    return data;
  }
}

class VisaPaymentModel {
  bool? flag;
  String? message;
  List<PaymentMethodData>? data;

  VisaPaymentModel({this.flag, this.message, this.data});

  VisaPaymentModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PaymentMethodData>[];
      json['data'].forEach((v) {
        data!.add(PaymentMethodData.fromJson(v));
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

class PaymentMethodData {
  String? cardId;
  String? cardType;
  double? charges;
  String? icon;
  String? vcIconPath;

  PaymentMethodData({this.cardId, this.cardType, this.charges, this.icon, this.vcIconPath});

  PaymentMethodData.fromJson(Map<String, dynamic> json) {
    cardId = json['card_id'];
    cardType = json['card_type'];
    charges = json['charges'] == 0 ? 0.0 : json['charges'];
    icon = json['icon'];
    vcIconPath = json['vc_icon_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['card_id'] = cardId;
    data['card_type'] = cardType;
    data['charges'] = charges;
    data['icon'] = icon;
    data['vc_icon_path'] = vcIconPath;
    return data;
  }
}
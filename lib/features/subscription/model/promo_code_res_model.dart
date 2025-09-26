class PromoCodeResModel {
  bool? flag;
  String? message;
  Data? data;

  PromoCodeResModel(
      {this.flag,
        this.message,
        this.data});

  PromoCodeResModel.fromJson(Map<String, dynamic> json) {
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
  int? isPromoCodeUsed;
  String? promoCode;

  Data({this.isPromoCodeUsed, this.promoCode});

  Data.fromJson(Map<String, dynamic> json) {
    isPromoCodeUsed = json['isPromoCodeUsed'];
    promoCode = json['promocode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isPromoCodeUsed'] = isPromoCodeUsed;
    data['promocode'] = promoCode;
    return data;
  }
}
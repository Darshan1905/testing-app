class BuySubscriptionModel {
  String? subscriptionId;
  String? currency;
  String? price;
  String? orderId;
  String? productID;
  String? purchaseToken;
  bool? isAutoRenewing;
  String? quantity;
  String? source;
  String? transactionDate;
  String? status;
  String? startDate;
  String? endDate;
  String? promoCode;

  BuySubscriptionModel(
      {this.subscriptionId,
        this.currency,
        this.price,
        this.orderId,
        this.productID,
        this.purchaseToken,
        this.isAutoRenewing,
        this.quantity,
        this.source,
        this.transactionDate,
        this.status,
        this.startDate,
        this.endDate,
        this.promoCode});

  BuySubscriptionModel.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscriptionId'];
    currency = json['currency'];
    price = json['price'];
    orderId = json['orderId'];
    productID = json['productID'];
    purchaseToken = json['purchaseToken'];
    isAutoRenewing = json['isAutoRenewing'];
    quantity = json['quantity'];
    source = json['source'];
    transactionDate = json['transactionDate'];
    status = json['status'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    promoCode = json['promoCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscriptionId'] = subscriptionId;
    data['currency'] = currency;
    data['price'] = price;
    data['orderId'] = orderId;
    data['productID'] = productID;
    data['purchaseToken'] = purchaseToken;
    data['isAutoRenewing'] = isAutoRenewing;
    data['quantity'] = quantity;
    data['source'] = source;
    data['transactionDate'] = transactionDate;
    data['status'] = status;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['promoCode'] = promoCode;
    return data;
  }
}

class SubscriptionAussizzData {
  String? subscriptionAussizzText;
  String? noOfDays;

  SubscriptionAussizzData({this.subscriptionAussizzText, this.noOfDays});

  SubscriptionAussizzData.fromJson(Map<String, dynamic> json) {
    subscriptionAussizzText = json['subscription_aussizz_text'];
    noOfDays = json['no_of_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscription_aussizz_text'] = subscriptionAussizzText;
    data['no_of_days'] = noOfDays;
    return data;
  }
}
class CountryWithCurrencyModel {
  String? name;
  String? dialCode;
  String? code;
  String? symbolCode;
  String? symbolName;
  String? flag;
  double rate = 1.0; // We fetch rate data from firebase database

  CountryWithCurrencyModel(
      {this.name, this.dialCode, this.code, this.symbolCode, this.symbolName,this.flag});

  CountryWithCurrencyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dialCode = json['dial_code'];
    code = json['code'];
    symbolCode = json['symbol_code'];
    symbolName = json['symbol_name'];
    flag = json['flag'];
    rate = json['rate'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dial_code'] = dialCode;
    data['code'] = code;
    data['symbol_code'] = symbolCode;
    data['symbol_name'] = symbolName;
    data['flag'] = flag;
    data['rate'] = rate;
    return data;
  }
}
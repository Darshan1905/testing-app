class CountryModel {
  String? name; // Australia
  String? dialCode; // +61
  String? code; // AU
  String? symbolCode; // AUD
  String? symbolName; // Australian Dollar
  String? flag; // australia.svg

  CountryModel(
      {this.name,
      this.dialCode,
      this.code,
      this.symbolCode,
      this.symbolName,
      this.flag});

  CountryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dialCode = json['dial_code'];
    code = json['code'];
    symbolCode = json['symbol_code'];
    symbolName = json['symbol_name'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dial_code'] = dialCode;
    data['code'] = code;
    data['symbol_code'] = symbolCode;
    data['symbol_name'] = symbolName;
    data['flag'] = flag;
    return data;
  }
}

class VisaGrantModel {
  VisaGrantModel({
      this.dateOfBirth, 
      this.name, 
      this.passportCountry, 
      this.passportNumber, 
      this.transactionReferenceNumber, 
      this.visaGrantNumber,});

  VisaGrantModel.fromJson(dynamic json) {
    dateOfBirth = json['date_of_birth'];
    name = json['name'];
    passportCountry = json['passport_country'];
    passportNumber = json['passport_number'];
    transactionReferenceNumber = json['transaction_reference_number'];
    visaGrantNumber = json['visa_grant_number'];
  }
  String? dateOfBirth;
  String? name;
  String? passportCountry;
  String? passportNumber;
  String? transactionReferenceNumber;
  String? visaGrantNumber;
VisaGrantModel copyWith({  String? dateOfBirth,
  String? name,
  String? passportCountry,
  String? passportNumber,
  String? transactionReferenceNumber,
  String? visaGrantNumber,
}) => VisaGrantModel(  dateOfBirth: dateOfBirth ?? this.dateOfBirth,
  name: name ?? this.name,
  passportCountry: passportCountry ?? this.passportCountry,
  passportNumber: passportNumber ?? this.passportNumber,
  transactionReferenceNumber: transactionReferenceNumber ?? this.transactionReferenceNumber,
  visaGrantNumber: visaGrantNumber ?? this.visaGrantNumber,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date_of_birth'] = dateOfBirth;
    map['name'] = name;
    map['passport_country'] = passportCountry;
    map['passport_number'] = passportNumber;
    map['transaction_reference_number'] = transactionReferenceNumber;
    map['visa_grant_number'] = visaGrantNumber;
    return map;
  }

}
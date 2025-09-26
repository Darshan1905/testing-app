class PassportModel {
  PassportModel({
      this.birthDate, 
      this.country, 
      this.documentNumber, 
      this.documentType, 
      this.expiryDate, 
      this.name, 
      this.nationality, 
      this.personalNumber, 
      this.sex, 
      this.surname,});

  PassportModel.fromJson(dynamic json) {
    birthDate = json['birth_date'];
    country = json['country'];
    documentNumber = json['document_number'];
    documentType = json['document_type'];
    expiryDate = json['expiry_date'];
    name = json['name'];
    nationality = json['nationality'];
    personalNumber = json['personal_number'];
    sex = json['sex'];
    surname = json['surname'];
  }
  String? birthDate;
  String? country;
  String? documentNumber;
  String? documentType;
  String? expiryDate;
  String? name;
  String? nationality;
  String? personalNumber;
  String? sex;
  String? surname;
PassportModel copyWith({  String? birthDate,
  String? country,
  String? documentNumber,
  String? documentType,
  String? expiryDate,
  String? name,
  String? nationality,
  String? personalNumber,
  String? sex,
  String? surname,
}) => PassportModel(  birthDate: birthDate ?? this.birthDate,
  country: country ?? this.country,
  documentNumber: documentNumber ?? this.documentNumber,
  documentType: documentType ?? this.documentType,
  expiryDate: expiryDate ?? this.expiryDate,
  name: name ?? this.name,
  nationality: nationality ?? this.nationality,
  personalNumber: personalNumber ?? this.personalNumber,
  sex: sex ?? this.sex,
  surname: surname ?? this.surname,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['birth_date'] = birthDate;
    map['country'] = country;
    map['document_number'] = documentNumber;
    map['document_type'] = documentType;
    map['expiry_date'] = expiryDate;
    map['name'] = name;
    map['nationality'] = nationality;
    map['personal_number'] = personalNumber;
    map['sex'] = sex;
    map['surname'] = surname;
    return map;
  }

}
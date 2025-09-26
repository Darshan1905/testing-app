class VisaFeesPriceModel {
  bool? flag;
  String? message;
  VisaQuestionPriceModel? data;

  VisaFeesPriceModel({this.flag, this.message, this.data});

  VisaFeesPriceModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    data = json['data'] != null
        ? VisaQuestionPriceModel.fromJson(json['data'])
        : null;
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

class VisaQuestionPriceModel {
  List<Question1>? question1;
  List<Question2>? question2;
  List<PriceDataModel>? price;
  List<PriceVisasubclassModel>? visasubclass;
  List<NotesDataModel>? notes;

  VisaQuestionPriceModel(
      {this.question1,
      this.question2,
      this.price,
      this.visasubclass,
      this.notes});

  VisaQuestionPriceModel.fromJson(Map<String, dynamic> json) {
    if (json['question1'] != null) {
      question1 = <Question1>[];
      json['question1'].forEach((v) {
        question1!.add(Question1.fromJson(v));
      });
    }
    if (json['question2'] != null) {
      question2 = <Question2>[];
      json['question2'].forEach((v) {
        question2!.add(Question2.fromJson(v));
      });
    }
    if (json['price'] != null) {
      price = <PriceDataModel>[];
      json['price'].forEach((v) {
        price!.add(PriceDataModel.fromJson(v));
      });
    }
    if (json['visasubclass'] != null) {
      visasubclass = <PriceVisasubclassModel>[];
      json['visasubclass'].forEach((v) {
        visasubclass!.add(PriceVisasubclassModel.fromJson(v));
      });
    }
    if (json['notes'] != null) {
      notes = <NotesDataModel>[];
      json['notes'].forEach((v) {
        notes!.add(NotesDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (question1 != null) {
      data['question1'] = question1!.map((v) => v.toJson()).toList();
    }
    if (question2 != null) {
      data['question2'] = question2!.map((v) => v.toJson()).toList();
    }
    if (price != null) {
      data['price'] = price!.map((v) => v.toJson()).toList();
    }
    if (visasubclass != null) {
      data['visasubclass'] = visasubclass!.map((v) => v.toJson()).toList();
    }
    if (notes != null) {
      data['notes'] = notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Question1 {
  String? questionId;

  Question1({this.questionId});

  Question1.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    return data;
  }
}

class Question2 {
  String? questionId;

  Question2({this.questionId});

  Question2.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    return data;
  }
}

class PriceDataModel {
  String? priceId;
  String? visaSubclassId;
  String? ref;
  String? visaSubclass;
  int? mainAppCharge;
  int? nonIntAppCharge;
  int? subAppChargeAbove18;
  int? subAppChargeBelow18;
  int? subsequentTempAppCharge;
  int? onshoreOffshore;
  String? visaTypeSections;

  PriceDataModel(
      {this.priceId,
      this.visaSubclassId,
      this.ref,
      this.visaSubclass,
      this.mainAppCharge,
      this.nonIntAppCharge,
      this.subAppChargeAbove18,
      this.subAppChargeBelow18,
      this.subsequentTempAppCharge,
      this.onshoreOffshore,
      this.visaTypeSections});

  PriceDataModel.fromJson(Map<String, dynamic> json) {
    priceId = json['price_id'];
    visaSubclassId = json['visa_subclass_id'];
    ref = json['ref'];
    visaSubclass = json['visa_subclass'];
    mainAppCharge = json['main_app_charge'];
    nonIntAppCharge = json['non_int_app_charge'];
    subAppChargeAbove18 = json['sub_app_charge_above_18'];
    subAppChargeBelow18 = json['sub_app_charge_below_18'];
    subsequentTempAppCharge = json['subsequent_temp_app_charge'];
    onshoreOffshore = json['onshore_offshore'];
    visaTypeSections = json['visa_type_sections'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price_id'] = priceId;
    data['visa_subclass_id'] = visaSubclassId;
    data['ref'] = ref;
    data['visa_subclass'] = visaSubclass;
    data['main_app_charge'] = mainAppCharge;
    data['non_int_app_charge'] = nonIntAppCharge;
    data['sub_app_charge_above_18'] = subAppChargeAbove18;
    data['sub_app_charge_below_18'] = subAppChargeBelow18;
    data['subsequent_temp_app_charge'] = subsequentTempAppCharge;
    data['onshore_offshore'] = onshoreOffshore;
    data['visa_type_sections'] = visaTypeSections;
    return data;
  }
}

class PriceVisasubclassModel {
  String? visaSubclassId;
  String? visaSubclass;
  int? type;
  int? isActive;
  String? visaSubclassGroupId;

  PriceVisasubclassModel(
      {this.visaSubclassId,
      this.visaSubclass,
      this.type,
      this.isActive,
      this.visaSubclassGroupId});

  PriceVisasubclassModel.fromJson(Map<String, dynamic> json) {
    visaSubclassId = json['visa_subclass_id'];
    visaSubclass = json['visa_subclass'];
    type = json['type'];
    isActive = json['is_active'];
    visaSubclassGroupId = json['visa_subclass_group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['visa_subclass_id'] = visaSubclassId;
    data['visa_subclass'] = visaSubclass;
    data['type'] = type;
    data['is_active'] = isActive;
    data['visa_subclass_group_id'] = visaSubclassGroupId;
    return data;
  }
}

class NotesDataModel {
  String? noteId;
  String? code = "";
  String? note;

  NotesDataModel({this.noteId, this.code, this.note});

  NotesDataModel.fromJson(Map<String, dynamic> json) {
    noteId = json['note_id'];
    code = json['code'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note_id'] = noteId;
    data['code'] = code;
    data['note'] = note;
    return data;
  }
}

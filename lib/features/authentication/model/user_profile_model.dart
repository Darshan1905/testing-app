class UserDataModel {
  bool? flag;
  String? message;
  String? outdata;
  String? outdata1;
  UserInfoData? data;
  String? bytedata;

  UserDataModel(
      {this.flag,
      this.message,
      this.outdata,
      this.outdata1,
      this.data,
      this.bytedata});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    message = json['message'];
    outdata = json['outdata'];
    outdata1 = json['outdata1'];
    data = json['data'] != null ? UserInfoData.fromJson(json['data']) : null;
    bytedata = json['bytedata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flag'] = flag;
    data['message'] = message;
    data['outdata'] = outdata;
    data['outdata1'] = outdata1;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['bytedata'] = bytedata;
    return data;
  }
}

class UserInfoData {
  int? userId; // 79524848
  String? leadCode; // LEAD22122714647
  String? name; // Aakansha Bhatt
  String? phone; // 98765432999
  String? email; // testing1@gmail.com
  String? dateOfBirth; // 13-September-2000
  String? profilePicture; //
  String? deviceId; // e08d64a634681350987
  String? countryCode; // IN
  int? companyId; // 11533
  int? branchId; // 0
  String? productID;
  int? subscriptionId;
  int? planId;
  String? subName;
  bool? isDelete;
  int? subRemainingDays;
  String? subsStartDate;
  String? subEndDate;

  UserInfoData(
      this.userId,
      this.leadCode,
      this.name,
      this.phone,
      this.email,
      this.dateOfBirth,
      this.profilePicture,
      this.deviceId,
      this.countryCode,
      this.companyId,
      this.branchId,
      this.productID,
      this.subscriptionId,
      this.planId,
      this.subName,
      this.isDelete,
      this.subRemainingDays,
      this.subsStartDate,
      this.subEndDate);

  UserInfoData.fromJson(Map<String, dynamic> json) {
    userId = json['userid'];
    leadCode = json['leadcode'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    dateOfBirth = json['dateofbirth'];
    profilePicture = json['profilepicture'];
    deviceId = json['deviceid'];
    countryCode = json['countrycode'];
    companyId = json['companyidf'];
    branchId = json['branchidf'];
    productID = json['productID'];
    subscriptionId = json['subscriptionid'];
    planId = json['planid'];
    subName = json['subname'];
    isDelete = json['isdelete'];
    subRemainingDays = json['subremainingdays'];
    subsStartDate = json['subsstartdate'];
    subEndDate = json['subenddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userId;
    data['leadcode'] = leadCode;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['dateofbirth'] = dateOfBirth;
    data['profilepicture'] = profilePicture;
    data['deviceid'] = deviceId;
    data['countrycode'] = countryCode;
    data['companyidf'] = companyId;
    data['branchidf'] = branchId;
    data['productID'] = productID;
    data['subscriptionid'] = subscriptionId;
    data['planid'] = planId;
    data['subname'] = subName;
    data['isdelete'] = isDelete;
    data['subremainingdays'] = subRemainingDays;
    data['subsstartdate'] = subsStartDate;
    data['subenddate'] = subEndDate;

    return data;
  }
}

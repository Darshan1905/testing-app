// ignore_for_file: constant_identifier_names

import 'package:occusearch/features/country/model/country_model.dart';

enum OTPtype { MOBILE, EMAIL }

class OtpParameterModel {
  static const String keyMobileNumber = "mobile_number";
  static const String keyEmailAddress = "email_address";
  static const String keyCountryModel = "country_model";
  static const String keyFirebaseVerificationID = "firebase_verification_id";
  static const String keyRouteName = "navigation";
  static const String keyType = "type";
  static const String keyIsDeleteAccount = "isDeleteAccount";
  static const String keyOtp = "OTP";
  static const String keyFullName = "full_name";

  static Map<String, dynamic> parameter(
      {String? mobileNumber = '',
      String? emailAddress = '',
      CountryModel? countryModel,
      String? firebaseVerificationID = '',
      String? routeName = '',
      OTPtype? type = OTPtype.MOBILE,
      bool isDeleteAccount = false,
      String? otp = '',
      String? fullName = ''}) {
    Map<String, dynamic> param = {
      keyMobileNumber: mobileNumber,
      keyEmailAddress: emailAddress,
      keyCountryModel: countryModel,
      keyFirebaseVerificationID: firebaseVerificationID,
      keyRouteName: routeName,
      keyType: "$type",
      keyIsDeleteAccount: isDeleteAccount,
      keyOtp: otp,
      keyFullName: fullName
    };
    return param;
  }
}

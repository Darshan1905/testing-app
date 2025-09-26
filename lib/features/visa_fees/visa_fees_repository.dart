import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/constants/constants.dart';

class VisaFeesRepository {
  //Insert data in config table
  static Future<void> insertVisaSubclassDataIntoDB(String strVisaSubclassDataJson) async {
    ConfigTable? configTable =
        await ConfigTable.read(strField: ConfigFields.configFieldVisaSubclassSyncDate);
    var configFundCalculatorData =
        await ConfigTable.read(strField: ConfigFields.configFieldVisaSubclass);

    //if exist in table then update data
    if (configTable?.fieldValue != null && configFundCalculatorData?.fieldValue != null) {
      await ConfigTable.update(
          strFieldValue: strVisaSubclassDataJson,
          strFieldName: ConfigFields.configFieldVisaSubclass);
      await ConfigTable.update(
          strFieldValue: Utility.getTodayDate(),
          strFieldName: ConfigFields.configFieldVisaSubclassSyncDate);
    }
    //else insert data
    else {
      var configFundQuestionTable = ConfigTable(
          fieldName: ConfigFields.configFieldVisaSubclass, fieldValue: strVisaSubclassDataJson);
      await ConfigTable.insertTable(configFundQuestionTable.toJson());

      var configSyncDateTable = ConfigTable(
          fieldName: ConfigFields.configFieldVisaSubclassSyncDate,
          fieldValue: Utility.getTodayDate());
      await ConfigTable.insertTable(configSyncDateTable.toJson());
    }
  }

  // Visa Fees question detail API
  static Future<BaseResponseModel> getVisaQuestionDetails(String param) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.visaFees!.visaQuestionDetailUrl!}?$param";
    BaseResponseModel response = await APIProvider.get(url,
        dioOptions: DioOptions(encryptionType: EncryptionType.anzscoEncryption));
    return response;
  }

  // Payment Method API
  static Future<BaseResponseModel> getVisaPaymentMethodListDio() async {
    String url =
        FirebaseRemoteConfigController.shared.dynamicEndUrl!.visaFees!.visaPaymentMethodUrl!;
    printLog(url);
    BaseResponseModel response = await APIProvider.get(url,
        dioOptions: DioOptions(encryptionType: EncryptionType.anzscoEncryption));
    return response;
  }

  // Price Method API
  static Future<BaseResponseModel> getVisaPriceDio(String param) async {
    String url =
        "${FirebaseRemoteConfigController.shared.dynamicEndUrl!.visaFees!.visaPriceDetailUrl!}?$param";
    BaseResponseModel response = await APIProvider.get(url,
        dioOptions: DioOptions(encryptionType: EncryptionType.anzscoEncryption));
    return response;
  }
}

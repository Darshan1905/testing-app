// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_all_visa_type/so_all_visa_type_repo.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_all_visa_type_model.dart';
import 'package:occusearch/resources/string_helper.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SoAllVisaTypeBloc extends RxBlocTypeBase {
  String errorMsg = "";
  BuildContext? _context;
  bool loader = false;

  /* Loading status getter, setter*/
  bool get loading => loader;

  set loading(bool loading) {
    loader = loading;
  }

  //ALL VISA TYPE LIST STREAM
  final allVisaTypeListStream = BehaviorSubject<List<VisaTypeRow>>();

  List<VisaTypeRow> get getVisaTypeList => allVisaTypeListStream.stream.value;

  set setAllVisaTypeList(List<VisaTypeRow> visaList) {
    allVisaTypeListStream.sink.add(visaList);
  }

  // [ALL VISA TYPE] API CALLING
  Future<void> callAllVisaTypeDetail(String occupationID) async {
    if (allVisaTypeListStream.valueOrNull != null) {
      return;
    }
    try {
      loading = true;
      errorMsg = "";
      String param = "occupation_code=$occupationID";

      BaseResponseModel result =
          await SoAllVisaTypeRepo.getAllVisaTypeAPICall(param);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        AllVisaTypeModel visaModel = AllVisaTypeModel.fromJson(result.data);
        if (visaModel.flag == true &&
            visaModel.data != null &&
            visaModel.data!.isNotEmpty) {
          // ALL VISA TYPE LIST
          setAllVisaTypeList = visaModel.data!;
        }
        errorMsg = visaModel.message.toString();
        loading = false;
      } else {
        if (result.statusCode == NetworkAPIConstant.statusCodeNoInternet) {
          errorMsg = StringHelper.internetConnection;
        } else {
          errorMsg = StringHelper.occupationFailToGetVisaTypeDetail;
        }
        loading = false;
        Toast.show(_context!,
            message: errorMsg, gravity: Toast.toastTop, type: Toast.toastError);
      }
    } catch (e) {
      setAllVisaTypeList = [];
      loading = false;
      errorMsg = e.toString();
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {}
}

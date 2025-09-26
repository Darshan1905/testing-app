// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/search_occupation_other_info_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_accessing_auth_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/resources/string_helper.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'so_accessing_auth_detail_repo.dart';

class SoAccessingAuthDetailBloc extends RxBlocTypeBase {
  List<AccessingAuthModel> accessingAuthList = [];
  String errorMsg = "";
  BuildContext? _context;

  /*Loading status getter, setter */
  bool loader = false;

  bool get loading => loader;

  set loading(bool loading) {
    loader = loading;
  }

  setBloc(BuildContext context) {
    _context = context;
  }

  // EXAM SELECTED NAME
  String strExamSelectedName = 'CAE';

  set setExam(String strExam) {
    strExamSelectedName = strExam;
  }

  String get getSelectedExam => strExamSelectedName;

  //ACCESSING AUTH STREAM
  final accessingAuthModelStream =
      BehaviorSubject<List<AccessingAuthModel>>.seeded([]);

  set setAccessingAuthorityDetail(List<AccessingAuthModel> accessingAuthList) {
    accessingAuthModelStream.sink.add(accessingAuthList);
  }

  clearProviderData() {
    setAccessingAuthorityDetail = [];
  }

  // [ACCESSING AUTHORITY DETAILS] API CALLING
  Future<void> callAccessingAuthorityDetail(
      String occupationID, OccupationDetailBloc? searchOccupationBloc) async {
    if (accessingAuthModelStream.valueOrNull != null) {
      return;
    }
    try {
      loading = true;
      errorMsg = "";
      String param = "short_name=$occupationID";
      BaseResponseModel result =
          await SoAccessingAuthDetailRepo.getAccessingAuthorityDetails(param);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        AccessingAuthDetailModel accessingModel =
            AccessingAuthDetailModel.fromJson(result.data);
        loading = false;
        errorMsg = accessingModel.message.toString();
        if (accessingModel.flag == true &&
            accessingModel.data != null &&
            accessingModel.data!.isNotEmpty) {
          // ACCESSING AUTHORITY DETAILS
          accessingAuthList.add(accessingModel.data![0]);

          List<OtherInfoRow> assessingAuthList =
              searchOccupationBloc?.getAssessingAuthList ?? [];

          if (accessingAuthList.length == assessingAuthList.length) {
            setAccessingAuthorityDetail = accessingAuthList;
          }
        }
      } else {
        if (result.statusCode == NetworkAPIConstant.statusCodeNoInternet) {
          errorMsg = StringHelper.internetConnection;
        } else {
          errorMsg =
              StringHelper.occupationFailToGetAssessingAuthorityDetail;
        }
        loading = false;
        Toast.show(
            message: errorMsg,
            _context!,
            gravity: Toast.toastTop,
            type: Toast.toastError);
      }
    } catch (e) {
      loading = false;
      errorMsg = e.toString();
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
  }
}

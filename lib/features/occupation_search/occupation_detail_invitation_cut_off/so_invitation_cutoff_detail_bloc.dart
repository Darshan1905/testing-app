import 'package:flutter/material.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_accessing_auth_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/so_invitation_cut_off_model.dart';

// ignore: depend_on_referenced_packages
import 'package:rx_bloc/rx_bloc.dart';
import 'so_invitation_cutoff_detail_repo.dart';

class SoInvitationCutOffDetailBloc extends RxBlocTypeBase {
  String errorMsg = "";
  AccessingAuthModel? accessingAuthModel;
  String type = "";

  set setType(type) {
    this.type = type;
  }

  AccessingAuthModel get getAccessingAuthorityDetail =>
      accessingAuthModel ?? AccessingAuthModel();

  //Invitation Cut Off
  InvitationCutOffModel invitationCutOffModel = InvitationCutOffModel();

  // [Invitation Cut offs List]
  List<InvitationCutOffRow> invitationCutOffsList = [];

  List<InvitationCutOffRow> get getInvitationCutOffsList =>
      invitationCutOffsList;

  set setInvitationCutOffsList(List<InvitationCutOffRow> pointScoreList) {
    if (pointScoreList.isNotEmpty) {
      invitationCutOffsList.add(InvitationCutOffRow(
          months: "Year", effectiveDate: "", pointScore: 0));
      invitationCutOffsList.addAll(pointScoreList);
    } else {
      invitationCutOffsList = pointScoreList;
    }
  }

  // [INVITATION CUT OFF DETAILS] API CALLING
  Future<void> callInvitationCutOffDetail(int ugCode, String type) async {
    try {
      //Utility.showLoadingView(_context!);
      errorMsg = "";
      String param = "ug_code=$ugCode&type$type";
      await SoInvitationCutOffDetailRepo.getInvitationCutOffDetails(param);
      /*result.listen((result) {
        print(result.body);

        BaseResponseModel responseModel = BaseResponseModel.fromJson(jsonDecode(result.body), result.statusCode);

        //Firebase API Tracking Log
        // FirebaseAnalyticLog.shared.apiRequestTracking(
        //     API: FirebaseManageRemoteConfig.shared.dynamicEndUrl!
        //         .searchOccupation!.getInvitationCutOffDetail!,
        //     requestType: API_REQUEST_TYPE_GET,
        //     requestJSON: param,
        //     responseMessage: responseModel.message,
        //     responseStatusCode: responseModel.statusCode);

        if (result.statusCode ==  NetworkAPIConstant.statusCodeSuccess) {
          invitationCutOffModel =
              InvitationCutOffModel.fromJson(jsonDecode(result.body));
         // Utility.endLoadingView(_context!);
          errorMsg = invitationCutOffModel.message.toString();
          if (invitationCutOffModel.flag == true &&
              invitationCutOffModel.data != null &&
              invitationCutOffModel.data!.isNotEmpty) {
            // INVITATION CUT OFF DETAILS
            setInvitationCutOffsList = invitationCutOffModel.data!;
            
          }
        } else {
         // Utility.endLoadingView(_context!);
          errorMsg = "Failed to get invitation cut off details.";
          Toast.show(message: errorMsg, _context!);
        }
      });*/
    } catch (e) {
      //Utility.endLoadingView(_context!);
      errorMsg = e.toString();
      debugPrint(e.toString());
    }
  }

  clearProviderData() {
    invitationCutOffsList = [];
  }

  @override
  void dispose() {}
}

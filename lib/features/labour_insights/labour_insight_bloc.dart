// ignore_for_file: depend_on_referenced_packages

import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/features/labour_insights/labour_insight_repository.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_detail_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LabourInsightBloc extends RxBlocTypeBase {
  //Unit Group and General Detail API variable List
  final unitGroupDetailsDataObject = BehaviorSubject<UnitGroupDetailData>();

  UnitGroupDetailData get getCourseDetailsData =>
      unitGroupDetailsDataObject.stream.value;

  set setCourseDetailsData(UnitGroupDetailData unitGroupDetailData) {
    unitGroupDetailsDataObject.sink.add(unitGroupDetailData);
  }

  //Loader
  final isLabourLoading = BehaviorSubject<bool>.seeded(false);

  //Labour Insight Detail API Call
  Future<void> getLabourInsightsDetailData(
      BuildContext context, String code, bool isFromOccupation) async {
    if (unitGroupDetailsDataObject.valueOrNull != null &&
        unitGroupDetailsDataObject.value.code != null &&
        unitGroupDetailsDataObject.value.code != "" &&
        unitGroupDetailsDataObject.value.code == code) {
      return;
    }
    try {
      isLabourLoading.sink.add(true);
      BaseResponseModel result =
          await LabourInsightRepository.getLabourInsightDetailData(code,
              isOccupationData: isFromOccupation);

      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true &&
          result.data != null &&
          result.data is Map<String, dynamic>) {
        UnitGroupDetailDataModel model =
            UnitGroupDetailDataModel.fromJson(result.data);

        if (model.flag == true && model.data != null) {
          setCourseDetailsData = model.data!;
        }
        isLabourLoading.sink.add(false);
      } else {
        // ignore: use_build_context_synchronously
        Utility.showToastErrorMessage(context, result.statusCode);
        isLabourLoading.sink.add(false);
      }
    } catch (e) {
      printLog(e);
    }
  }

  // view more summary in labour insight details
  final isViewMoreSubject = BehaviorSubject<bool>.seeded(false);

  bool get getViewMoreSubjectValue => isViewMoreSubject.stream.value;

  @override
  void dispose() {}
}

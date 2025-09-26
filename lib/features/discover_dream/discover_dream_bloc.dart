// ignore_for_file: depend_on_referenced_packages

import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/features/cricos_course/course_list/model/employment_insights_australia.dart';
import 'package:occusearch/features/discover_dream/discover_dream_repository.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class DiscoverDreamBloc extends RxBlocTypeBase {
  String errorMsg = "";

  /* Loading status getter, setter*/
  final isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  // GET
  Stream<bool> get loadingStream => isLoadingSubject.stream;

  //marketPlaceData model
  final marketPlaceDataStream = BehaviorSubject<MarketPlaceData?>();

  Stream<MarketPlaceData?> get getMarketPlaceDataStream =>
      marketPlaceDataStream.stream;

  final largestEmployeeOccuListStream =
      BehaviorSubject<List<LargestEmployingOccupations>?>();

  Stream<List<LargestEmployingOccupations>?>
      get getLargestEmployeeOccuListStream =>
          largestEmployeeOccuListStream.stream;

  final projectedEmpGrowthByIndustryStream =
      BehaviorSubject<List<ProjectedEmpGrowthByIndustry>?>();

  Stream<List<ProjectedEmpGrowthByIndustry>?>
      get getProjectedEmpGrowthByIndustryStream =>
          projectedEmpGrowthByIndustryStream.stream;

  Future<void> getMarketPlaceAustraliaData() async {
    try {
      isLoadingSubject.sink.add(true);
      BaseResponseModel response =
          await DiscoverDreamRepository.getMarketPlaceAustraliaData();
      if ((response.statusCode == NetworkAPIConstant.statusCodeSuccess ||
              response.statusCode == NetworkAPIConstant.statusCodeCaching) &&
          response.flag == true) {
        EmploymentInsightsForAustralia employmentInsightsForAustralia =
            EmploymentInsightsForAustralia.fromJson(response.data);

        MarketPlaceData? marketPlaceData = employmentInsightsForAustralia.data;

        if (marketPlaceData != null) {
          marketPlaceDataStream.sink.add(marketPlaceData);
          largestEmployeeOccuListStream.sink
              .add(marketPlaceData.largestEmployingOccupations);
          projectedEmpGrowthByIndustryStream.sink
              .add(marketPlaceData.projectedEmpGrowthByIndustry);
        } else {
          marketPlaceDataStream.sink.add(marketPlaceData);
          largestEmployeeOccuListStream.value = [];
          projectedEmpGrowthByIndustryStream.value = [];
        }
        isLoadingSubject.sink.add(false);
      } else {
        isLoadingSubject.sink.add(false);
      }
    } catch (e) {
      isLoadingSubject.sink.add(false);
      errorMsg = e.toString();
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {}
}

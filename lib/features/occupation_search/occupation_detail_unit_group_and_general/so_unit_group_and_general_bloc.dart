// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/api_service/base_response_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/unit_group_and_general_detail_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/model/related_courses_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SoUnitGroupAndGeneralBloc extends RxBlocTypeBase {
  // [Related Courses List]
  final relatedCoursesListStream = BehaviorSubject<List<RelatedCoursesList>>();

  Stream<List<RelatedCoursesList>> get getRelatedCoursesListStream =>
      relatedCoursesListStream.stream;

  set setRelatedCoursesListStream(List<RelatedCoursesList> relatedCoursesList) {
    relatedCoursesListStream.value = relatedCoursesList;
  }

  final relatedCourseLoading = BehaviorSubject<bool>.seeded(false);

  Future<void> getRelatedCoursesData(BuildContext context,
      [OccupationOtherInfoData? occupationOtherInfoData]) async {
    try {
      String param =
          "occ_code=${occupationOtherInfoData?.occupationCode.toString() ?? ""}";
      relatedCourseLoading.sink.add(true);
      BaseResponseModel response =
          await SoUnitGroupAndGeneralRepository.getRelatedCoursesData(param);

      if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          response.flag == true) {
        relatedCourseLoading.sink.add(false);
        RelatedCoursesModel relatedCoursesModel =
            RelatedCoursesModel.fromJson(response.data);

        if (relatedCoursesModel.flag == true &&
            relatedCoursesModel.data != null &&
            relatedCoursesModel.data != null) {
          setRelatedCoursesListStream =
              relatedCoursesModel.data?.courseList ?? [];
        }
      } else {
        // ignore: use_build_context_synchronously
        Toast.show(context,
            message: response.message ?? "", gravity: Toast.toastTop);
        relatedCourseLoading.sink.add(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {}
}

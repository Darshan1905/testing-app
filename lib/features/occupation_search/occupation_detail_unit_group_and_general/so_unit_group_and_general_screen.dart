import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_accessing_auth_details/so_accessing_auth_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_model/search_occupation_other_info_model.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/so_unit_group_and_general_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/widgets/assessing_auth_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/widgets/caveats_information_list_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/widgets/description_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/widgets/employment_statistic_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/widgets/osca_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/widgets/related_occupations_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/widgets/skill_level_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/widgets/source_and_task_widget.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_unit_group_and_general/widgets/specialization_widget.dart';

class SoUnitGroupAndGeneralScreen extends BaseApp {
  const SoUnitGroupAndGeneralScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _SoUnitGroupScreenState();
}

class _SoUnitGroupScreenState extends BaseState {
  SoUnitGroupAndGeneralBloc? soUnitGroupBloc;
  SoAccessingAuthDetailBloc soAccessingAuthDetailBloc =
      SoAccessingAuthDetailBloc();

  OccupationDetailBloc? searchOccupationBloc;

  @override
  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  initData() async {
    List<OtherInfoRow> assessingAuthList =
        searchOccupationBloc?.getAssessingAuthList ?? [];
    if (assessingAuthList.isNotEmpty) {
      for (OtherInfoRow otherRowInfo in assessingAuthList) {
        soAccessingAuthDetailBloc.callAccessingAuthorityDetail(
            otherRowInfo.title ?? '', searchOccupationBloc);
      }
    }

    /*soUnitGroupBloc?.getRelatedCoursesData(
        context,
        (searchOccupationBloc?.getOccupationOtherInfoData ?? [])
            as OccupationOtherInfoData?);*/
  }

  @override
  onResume() {}

  @override
  Widget body(BuildContext context) {
    searchOccupationBloc ??= RxBlocProvider.of<OccupationDetailBloc>(context);
    soUnitGroupBloc ??= RxBlocProvider.of<SoUnitGroupAndGeneralBloc>(context);
    return RxMultiBlocProvider(
      providers: [
        RxBlocProvider<SoAccessingAuthDetailBloc>(
            create: (context) => soAccessingAuthDetailBloc),
      ],
      child: Container(
        width: double.infinity,
        color: AppColorStyle.backgroundVariant(context),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
            child: Column(
              children: [
                //Description Widget
                const DescriptionWidget(),
                //Skill Level Widget
                SkillLevelWidget(),
                //Related Occupation List
                RelatedOccupationWidget(globalBloc: globalBloc),
                //Related Courses List
                // const RelatedCoursesWidget(),
                //Assessing Authority
                const AssessingAuthorityWidget(),
                //OSCA Widget
                const OSCAWidget(),
                //Specialization Widget
                const SpecializationWidget(),
                //Source and Task Widget
                const SourceAndTaskWidget(),
                // Caveats Widget
                const CaveatsInfoListWidget(),
                // Employee Statistic Widget
                const EmploymentStatisticsWidget(),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

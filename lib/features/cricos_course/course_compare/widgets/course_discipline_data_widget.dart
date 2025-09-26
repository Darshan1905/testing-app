import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_compare/widgets/row_title_name_with_backgrounds.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';

class CourseDisciplineDataWidget extends StatelessWidget {
  const CourseDisciplineDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);
    return Column(
      children: [
        const RowTitleNameWithBlueBG(title: StringHelper.courseDiscipline),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: (coursesBloc.selectedPrimaryCourseDetailObject
                                    .value.foeBroadField1 !=
                                null &&
                            coursesBloc.selectedPrimaryCourseDetailObject.value
                                .foeBroadField1!.isNotEmpty),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Constants.commonPadding,
                              vertical: 10.0),
                          child: Text(
                              "${StringHelper.broadField} ${coursesBloc.selectedPrimaryCourseDetailObject.value.foeBroadField1}",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                      ),
                      Visibility(
                        visible: (coursesBloc.selectedPrimaryCourseDetailObject
                                    .value.foeNarrowField1 !=
                                null &&
                            coursesBloc.selectedPrimaryCourseDetailObject.value
                                .foeNarrowField1!.isNotEmpty),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Constants.commonPadding,
                              vertical: 10.0),
                          child: Text(
                              "${StringHelper.narrowField} ${coursesBloc.selectedPrimaryCourseDetailObject.value.foeNarrowField1}",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                      ),
                      Visibility(
                        visible: (coursesBloc.selectedPrimaryCourseDetailObject
                                    .value.foeDetailedField1 !=
                                null &&
                            coursesBloc.selectedPrimaryCourseDetailObject.value
                                .foeDetailedField1!.isNotEmpty),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Constants.commonPadding,
                              vertical: 10.0),
                          child: Text(
                              "${StringHelper.detailedField} ${coursesBloc.selectedPrimaryCourseDetailObject.value.foeDetailedField1}",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: AppColorStyle.primarySurface2(context),
                thickness: 1.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: (coursesBloc
                                    .selectedSecondaryCourseDetailObject
                                    .value
                                    .foeBroadField1 !=
                                null &&
                            coursesBloc.selectedSecondaryCourseDetailObject
                                .value.foeBroadField1!.isNotEmpty),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Constants.commonPadding,
                              vertical: 10.0),
                          child: Text(
                              "${StringHelper.broadField} ${coursesBloc.selectedSecondaryCourseDetailObject.value.foeBroadField1}",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                      ),
                      Visibility(
                        visible: (coursesBloc
                                    .selectedSecondaryCourseDetailObject
                                    .value
                                    .foeNarrowField1 !=
                                null &&
                            coursesBloc.selectedSecondaryCourseDetailObject
                                .value.foeNarrowField1!.isNotEmpty),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Constants.commonPadding,
                              vertical: 10.0),
                          child: Text(
                              "${StringHelper.narrowField} ${coursesBloc.selectedSecondaryCourseDetailObject.value.foeNarrowField1}",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                      ),
                      Visibility(
                        visible: (coursesBloc
                                    .selectedSecondaryCourseDetailObject
                                    .value
                                    .foeDetailedField1 !=
                                null &&
                            coursesBloc.selectedSecondaryCourseDetailObject
                                .value.foeDetailedField1!.isNotEmpty),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Constants.commonPadding,
                              vertical: 10.0),
                          child: Text(
                              "${StringHelper.detailedField} ${coursesBloc.selectedSecondaryCourseDetailObject.value.foeDetailedField1}",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.captionRegular(
                                  context, AppColorStyle.text(context))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

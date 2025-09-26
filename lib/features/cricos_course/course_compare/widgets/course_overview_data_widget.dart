import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_compare/widgets/row_title_name_with_backgrounds.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';

class CourseOverviewDataWidget extends StatelessWidget {
  const CourseOverviewDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowTitleNameWithBlueBG(
            title: StringHelper.overView, isTitleOverview: true),

        //Study Mode
        const RowTitleOverviewWidgetGrayBG(title: StringHelper.dualCourse),
        IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      coursesBloc.selectedPrimaryCourseDetailObject.value
                              .dualQualification ??
                          "",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.text(context))),
                ),
              ),
              VerticalDivider(
                color: AppColorStyle.primarySurface2(context),
                thickness: 1.0,
              ),
              Expanded(
                child: Text(
                    coursesBloc.selectedSecondaryCourseDetailObject.value
                            .dualQualification ??
                        "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.captionRegular(
                        context, AppColorStyle.text(context))),
              )
            ],
          ),
        ),

        //Delivery Mode
        const RowTitleOverviewWidgetGrayBG(title: StringHelper.instituteType),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      coursesBloc.selectedPrimaryCourseDetailObject.value
                              .instituteType ??
                          "",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.text(context))),
                ),
              ),
              VerticalDivider(
                color: AppColorStyle.primarySurface2(context),
                thickness: 1.0,
              ),
              Expanded(
                child: Text(
                    coursesBloc.selectedSecondaryCourseDetailObject.value
                            .instituteType ??
                        "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.captionRegular(
                        context, AppColorStyle.text(context))),
              )
            ],
          ),
        ),

        //Duration
        const RowTitleOverviewWidgetGrayBG(title: StringHelper.duration),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      "${Utility.getYearFromWeek(int.parse(coursesBloc.selectedPrimaryCourseDetailObject.value.durationWeeks ?? "0"))} year",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.text(context))),
                ),
              ),
              VerticalDivider(
                color: AppColorStyle.primarySurface2(context),
                thickness: 1.0,
              ),
              Expanded(
                child: Text(
                    "${Utility.getYearFromWeek(int.parse(coursesBloc.selectedSecondaryCourseDetailObject.value.durationWeeks ?? "0"))} year",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.captionRegular(
                        context, AppColorStyle.text(context))),
              )
            ],
          ),
        ),

        //Study Level
        const RowTitleOverviewWidgetGrayBG(title: StringHelper.courseLevel),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      coursesBloc.selectedPrimaryCourseDetailObject.value
                              .courseLevel ??
                          "",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.text(context))),
                ),
              ),
              VerticalDivider(
                color: AppColorStyle.primarySurface2(context),
                thickness: 1.0,
              ),
              Expanded(
                child: Text(
                    coursesBloc.selectedSecondaryCourseDetailObject.value
                            .courseLevel ??
                        "",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.captionRegular(
                        context, AppColorStyle.text(context))),
              )
            ],
          ),
        ),

        //Intake
        const RowTitleOverviewWidgetGrayBG(title: StringHelper.intake),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      /*
                      coursesBloc.selectedPrimaryCourseDetailObject.value
                              .intakeMonth ??*/
                      "-",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.text(context))),
                ),
              ),
              VerticalDivider(
                color: AppColorStyle.primarySurface2(context),
                thickness: 1.0,
              ),
              Expanded(
                child: Text(
                    /*
                      coursesBloc.selectedSecondaryCourseDetailObject.value
                              .intakeMonth ??*/
                    "-",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.captionRegular(
                        context, AppColorStyle.text(context))),
              )
            ],
          ),
        ),

        //Study Mode
        const RowTitleOverviewWidgetGrayBG(
            title: "${StringHelper.tuitionFee} (AUD)"),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      (coursesBloc.selectedPrimaryCourseDetailObject.value
                                      .tutionFee !=
                                  null &&
                              coursesBloc.selectedPrimaryCourseDetailObject
                                  .value.tutionFee!.isNotEmpty)
                          ? "\$ ${Utility.getDoubleAmountFormat(amount: double.parse(coursesBloc.selectedPrimaryCourseDetailObject.value.tutionFee ?? "0"))}"
                          : "-",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.text(context))),
                ),
              ),
              VerticalDivider(
                color: AppColorStyle.primarySurface2(context),
                thickness: 1.0,
              ),
              Expanded(
                child: Text(
                    (coursesBloc.selectedSecondaryCourseDetailObject.value
                                    .tutionFee !=
                                null &&
                            coursesBloc.selectedSecondaryCourseDetailObject
                                .value.tutionFee!.isNotEmpty)
                        ? "\$ ${Utility.getDoubleAmountFormat(amount: double.parse(coursesBloc.selectedSecondaryCourseDetailObject.value.tutionFee ?? "0"))}"
                        : "-",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.captionRegular(
                        context, AppColorStyle.text(context))),
              )
            ],
          ),
        ),
      ],
    );
  }
}

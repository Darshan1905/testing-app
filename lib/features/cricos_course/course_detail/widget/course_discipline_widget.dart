import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_detail/model/course_detail_model.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';

class CourseDisciplineWidget extends StatelessWidget {
  const CourseDisciplineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);

    final CourseDetailData? courseDetail =
        coursesBloc.courseDetailsDataObject.valueOrNull;
    if (courseDetail == null) {
      return const SizedBox();
    }
    return Visibility(
      visible: (courseDetail.foeBroadField1?.isNotEmpty != null &&
              courseDetail.foeBroadField1!.isNotEmpty ||
          courseDetail.foeNarrowField1?.isNotEmpty != null &&
              courseDetail.foeNarrowField1!.isNotEmpty ||
          courseDetail.foeDetailedField1?.isNotEmpty != null &&
              courseDetail.foeDetailedField1!.isNotEmpty),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.commonPadding, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(StringHelper.courseDiscipline,
                style: AppTextStyle.titleSemiBold(
                    context, AppColorStyle.text(context))),
            const SizedBox(height: 15.0),
            Visibility(
              visible: courseDetail.foeBroadField1?.isNotEmpty ?? false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(StringHelper.broadField,
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.textDetail(context))),
                  const SizedBox(height: 5.0),
                  Text(courseDetail.foeBroadField1 ?? "",
                      style: AppTextStyle.detailsSemiBold(
                          context, AppColorStyle.text(context))),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            Visibility(
              visible: courseDetail.foeNarrowField1?.isNotEmpty ?? false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${StringHelper.narrowField}  ",
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.textDetail(context))),
                  const SizedBox(height: 5.0),
                  Text(courseDetail.foeNarrowField1 ?? "",
                      style: AppTextStyle.detailsSemiBold(
                          context, AppColorStyle.text(context))),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            Visibility(
              visible: courseDetail.foeDetailedField1?.isNotEmpty ?? false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      StringHelper.detailedField,
                      style: AppTextStyle.captionRegular(
                          context, AppColorStyle.textDetail(context))),
                  const SizedBox(height: 5.0),
                  Text(courseDetail.foeDetailedField1 ?? "",
                      style: AppTextStyle.detailsSemiBold(
                          context, AppColorStyle.text(context))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

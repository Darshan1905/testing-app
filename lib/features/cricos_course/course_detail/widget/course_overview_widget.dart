import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_detail/model/course_detail_model.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';

class CourseOverviewWidget extends StatelessWidget {
  const CourseOverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);

    final CourseDetailData? courseDetail =
        coursesBloc.courseDetailsDataObject.valueOrNull;
    if (courseDetail == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.commonPadding, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview of course
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Overview of this",
                  style: AppTextStyle.titleSemiBold(
                    context,
                    AppColorStyle.text(context),
                  ),
                ),
                TextSpan(
                  text: " Course",
                  style: AppTextStyle.titleBold(
                    context,
                    AppColorStyle.primary(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          // [DUAL COURSE + COURSE LEVEL + INSTITUTE TYPE
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeConstant.blueVariant,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                IconsSVG.studyModeIcon,
                                width: 24,
                                height: 24,
                              ),
                            )),
                        const SizedBox(height: 5.0),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    courseDetail.workComponent!.isNotEmpty
                                        ? courseDetail.workComponent.toString()
                                        : "-",
                                    style: AppTextStyle.detailsSemiBold(
                                        context, AppColorStyle.text(context))),
                                const SizedBox(height: 5.0),
                                Text(StringHelper.dualCourse,
                                    style: AppTextStyle.captionRegular(
                                        context, ThemeConstant.textHint)),
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                  child: Container(
                    color: AppColorStyle.surfaceVariant(context),
                    width: 0.3,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeConstant.yellowVariant),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: SvgPicture.asset(
                                IconsSVG.graduationCap,
                                width: 24,
                                height: 24,
                              ),
                            )),
                        const SizedBox(height: 5.0),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                    courseDetail.courseLevel!.isNotEmpty
                                        ? courseDetail.courseLevel.toString()
                                        : "-",
                                    style: AppTextStyle.detailsSemiBold(
                                        context, AppColorStyle.text(context)),
                                    textAlign: TextAlign.center),
                                const SizedBox(height: 5.0),
                                Text(StringHelper.courseLevel,
                                    style: AppTextStyle.captionRegular(
                                        context, ThemeConstant.textHint))
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                  child: Container(
                    color: AppColorStyle.surfaceVariant(context),
                    width: 0.3,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeConstant.greenVariant),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: SvgPicture.asset(
                                IconsSVG.deliveryModeIcon,
                                width: 24,
                                height: 24,
                              ),
                            )),
                        const SizedBox(height: 5.0),
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    courseDetail.instituteType!.isNotEmpty
                                        ? courseDetail.instituteType.toString()
                                        : "-",
                                    style: AppTextStyle.detailsSemiBold(
                                        context, AppColorStyle.text(context))),
                                const SizedBox(height: 5.0),
                                Text(StringHelper.instituteType,
                                    style: AppTextStyle.captionRegular(
                                        context, ThemeConstant.textHint))
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Container(color: AppColorStyle.surfaceVariant(context), height: 0.3),
          const SizedBox(height: 15.0),
          // [INTAKE + DURATION + TUITION FEES]
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeConstant.pinkVariant,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                IconsSVG.intakeCalenderIcon,
                                width: 24,
                                height: 24,
                              ),
                            )),
                        const SizedBox(height: 5.0),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    courseDetail.intakeMonth!.isNotEmpty
                                        ? courseDetail.intakeMonth.toString()
                                        : "-",
                                    style: AppTextStyle.detailsSemiBold(
                                        context, AppColorStyle.text(context))),
                                const SizedBox(height: 5.0),
                                Text(StringHelper.intake,
                                    style: AppTextStyle.captionRegular(
                                        context, ThemeConstant.textHint))
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  child: Container(
                    color: AppColorStyle.surfaceVariant(context),
                    width: 0.3,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeConstant.purpleText),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: SvgPicture.asset(
                                IconsSVG.timerIcon,
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  ThemeConstant.purple,
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                        const SizedBox(height: 5.0),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: courseDetail
                                                .durationWeeks!.isNotEmpty
                                            ? Utility.getYearFromWeek(int.parse(
                                                courseDetail.durationWeeks ??
                                                    "1"))
                                            : "-",
                                        style: AppTextStyle.detailsSemiBold(
                                          context,
                                          AppColorStyle.text(context),
                                        ),
                                      ),
                                      TextSpan(
                                        text: " years",
                                        style: AppTextStyle.detailsSemiBold(
                                          context,
                                          AppColorStyle.text(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(StringHelper.duration,
                                    style: AppTextStyle.captionRegular(
                                        context, ThemeConstant.textHint))
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  child: Container(
                    color: AppColorStyle.surfaceVariant(context),
                    width: 0.3,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeConstant.cyanText,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                IconsSVG.tutionFeesIcon,
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  ThemeConstant.cyan,
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                        const SizedBox(height: 5.0),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    (courseDetail.tutionFee != null &&
                                            courseDetail.tutionFee!.isNotEmpty)
                                        ? "\$ ${Utility.getDoubleAmountFormat(amount: double.parse(courseDetail.tutionFee ?? "0"))}"
                                        : "-",
                                    softWrap: true,
                                    style: AppTextStyle.detailsSemiBold(
                                        context, AppColorStyle.text(context))),
                                const SizedBox(height: 5.0),
                                Text("${StringHelper.tuitionFee} (AUD)",
                                    style: AppTextStyle.captionRegular(
                                        context, ThemeConstant.textHint))
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

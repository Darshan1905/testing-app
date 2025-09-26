import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';

// ignore: must_be_immutable
class CourseCompareHeaderSectionWidget extends StatelessWidget {
  int selectedCourseForApiCall;

  CourseCompareHeaderSectionWidget(
      {Key? key, required this.selectedCourseForApiCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);

    return Container(
      color: AppColorStyle.primary(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Row(
                children: [
                  InkWellWidget(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      IconsSVG.arrowBack,
                      colorFilter: ColorFilter.mode(
                        AppColorStyle.textWhite(context),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    StringHelper.compareCourses,
                    style: AppTextStyle.titleSemiBold(
                        context, AppColorStyle.textWhite(context)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 5.0, left: 5.0),
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: AppColorStyle.primaryVariant1(context),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      coursesBloc
                                              .selectedPrimaryCourseDetailObject
                                              .value
                                              .courseName ??
                                          "",
                                      style: AppTextStyle.detailsSemiBold(
                                          context,
                                          AppColorStyle.textWhite(context))),
                                  const SizedBox(height: 10.0),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: AppColorStyle.primary(context),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        child: Text(
                                            "${StringHelper.cricosText} ${coursesBloc.selectedPrimaryCourseDetailObject.value.courseCode}",
                                            style: AppTextStyle.captionRegular(
                                                context,
                                                AppColorStyle.textWhite(
                                                    context))),
                                      )),
                                  const SizedBox(height: 10.0),
                                  Text(
                                      coursesBloc
                                              .selectedPrimaryCourseDetailObject
                                              .value
                                              .institutionName ??
                                          "",
                                      style: AppTextStyle.captionLight(context,
                                          AppColorStyle.textWhite(context))),
                                  const SizedBox(height: 10.0)
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0)
                          ]),
                        ),
                        InkWellWidget(
                          onTap: () async {
                            //to remove course name and show add course widget
                            //show search bar UI in design and replace first data if selected
                            //Primary data
                            //stream var for showing bottom data or search data
                            //coursesBloc.viewSelectedForSearch.sink.add(true); //commented for search screen open in page
                            selectedCourseForApiCall = 1;
                            var params = {"isFromCompare": true};
                            var result = await context.push<dynamic>(
                                RouteName.root + RouteName.coursesListScreen,
                                extra: params);
                            if (kDebugMode) {
                              print("Result :-> ${result.runtimeType}");
                            }
                            if (result != null) {
                              await coursesBloc.getCoursesDetailData(
                                result,
                                selectedCourseForApiCall,
                                isFromDetailPage: false,
                              );
                            }
                          },
                          child: SvgPicture.asset(
                            IconsSVG.courseDeleteIcon,
                            width: 25,
                            height: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: AppColorStyle.primarySurface2(context),
                    thickness: 1.0,
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 5.0, left: 5.0),
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: AppColorStyle.primaryVariant1(context),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      coursesBloc
                                              .selectedSecondaryCourseDetailObject
                                              .value
                                              .courseName ??
                                          "",
                                      style: AppTextStyle.detailsSemiBold(
                                          context,
                                          AppColorStyle.textWhite(context))),
                                  const SizedBox(height: 10.0),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: AppColorStyle.primary(context),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 15),
                                        child: Text(
                                            "${StringHelper.cricosText} ${coursesBloc.selectedSecondaryCourseDetailObject.value.courseCode}",
                                            style: AppTextStyle.captionRegular(
                                                context,
                                                AppColorStyle.textWhite(
                                                    context))),
                                      )),
                                  const SizedBox(height: 10.0),
                                  Text(
                                      coursesBloc
                                              .selectedSecondaryCourseDetailObject
                                              .value
                                              .institutionName ??
                                          "",
                                      style: AppTextStyle.captionLight(context,
                                          AppColorStyle.textWhite(context))),
                                  const SizedBox(height: 10.0)
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0)
                          ]),
                        ),
                        InkWellWidget(
                          onTap: () async {
                            //to remove course name and show add course widget
                            //show search bar UI in design and replace first data if selected
                            //Secondary data
                            //stream var for showing bottom data or search data
                            //coursesBloc.viewSelectedForSearch.sink.add(true); //commented for search screen open in page
                            selectedCourseForApiCall = 2;

                            var params = {"isFromCompare": true};
                            var result = await context.push<dynamic>(
                                RouteName.root + RouteName.coursesListScreen,
                                extra: params);
                            if (kDebugMode) {
                              print("Result :-> ${result.runtimeType}");
                            }
                            if (result != null) {
                              await coursesBloc.getCoursesDetailData(
                                result,
                                selectedCourseForApiCall,
                                isFromDetailPage: false,
                              );
                            }
                          },
                          child: SvgPicture.asset(
                            IconsSVG.courseDeleteIcon,
                            width: 25,
                            height: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

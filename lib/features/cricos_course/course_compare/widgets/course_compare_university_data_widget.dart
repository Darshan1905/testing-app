import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_compare/widgets/row_title_name_with_backgrounds.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';

class CourseCompareUniversityDataWidget extends StatelessWidget {
  const CourseCompareUniversityDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RowTitleNameWithBlueBG(title: StringHelper.offeringInstitution),
        IntrinsicHeight(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: (coursesBloc
                                      .selectedPrimaryCourseDetailObject
                                      .value
                                      .institutionLogo !=
                                  null &&
                              coursesBloc.selectedPrimaryCourseDetailObject
                                  .value.institutionLogo!.isNotEmpty),
                          child: CachedNetworkImage(
                              height: 50,
                              width: 100,
                              imageUrl: coursesBloc
                                  .selectedPrimaryCourseDetailObject
                                  .value
                                  .institutionLogo!,
                              fit: BoxFit.fill,
                              placeholder: (context, error) =>
                                  SvgPicture.asset(IconsSVG.placeholder),
                              errorWidget: (context, url, error) => Icon(
                                    Icons.photo,
                                    color: AppColorStyle.backgroundVariant(
                                        context),
                                  )),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                            coursesBloc.selectedPrimaryCourseDetailObject.value
                                    .institutionName ??
                                "",
                            style: AppTextStyle.detailsSemiBold(
                                context, AppColorStyle.text(context))),
                        const SizedBox(height: 5.0),
                        Text(
                            "${coursesBloc.selectedPrimaryCourseDetailObject.value.instituteCity}",
                            style: AppTextStyle.captionRegular(
                                context, AppColorStyle.textDetail(context))),
                        Text(
                            "${Utility.getFullNameOfAUState("${coursesBloc.selectedPrimaryCourseDetailObject.value.instituteState}")} ${coursesBloc.selectedPrimaryCourseDetailObject.value.institutePostcode}",
                            style: AppTextStyle.captionRegular(
                                context, AppColorStyle.textDetail(context))),
                        const SizedBox(height: 20.0),
                        coursesBloc.selectedPrimaryCourseDetailObject.valueOrNull != null &&
                                coursesBloc.selectedPrimaryCourseDetailObject
                                        .valueOrNull!.instituteWebsite !=
                                    null &&
                                coursesBloc.selectedPrimaryCourseDetailObject
                                        .value.instituteWebsite !=
                                    "" &&
                                coursesBloc.selectedPrimaryCourseDetailObject
                                    .value.instituteWebsite!.isNotEmpty &&
                                (coursesBloc.selectedPrimaryCourseDetailObject
                                        .value.instituteWebsite!
                                        .startsWith("https", 0) ||
                                    coursesBloc
                                        .selectedPrimaryCourseDetailObject
                                        .value
                                        .instituteWebsite!
                                        .startsWith("http", 0) ||
                                    coursesBloc
                                        .selectedPrimaryCourseDetailObject
                                        .value
                                        .instituteWebsite!
                                        .startsWith("www", 0))
                            ? InkWellWidget(
                                onTap: () {
                                  if (coursesBloc
                                      .selectedPrimaryCourseDetailObject
                                      .valueOrNull!
                                      .instituteWebsite!
                                      .contains(",")) {
                                    String instituteWebsiteURL = coursesBloc
                                        .selectedPrimaryCourseDetailObject
                                        .valueOrNull!
                                        .instituteWebsite!
                                        .substring(
                                            coursesBloc
                                                    .selectedPrimaryCourseDetailObject
                                                    .value
                                                    .instituteWebsite!
                                                    .indexOf(",") +
                                                1,
                                            coursesBloc
                                                .selectedPrimaryCourseDetailObject
                                                .value
                                                .instituteWebsite!
                                                .length);
                                    Utility.launchURL(
                                        instituteWebsiteURL.trim());
                                  } else {
                                    Utility.launchURL(coursesBloc
                                        .selectedPrimaryCourseDetailObject
                                        .valueOrNull!
                                        .instituteWebsite!
                                        .trim());
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              AppColorStyle.primary(context)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0))),
                                  child: Text(StringHelper.explore,
                                      style: AppTextStyle.detailsSemiBold(
                                          context,
                                          AppColorStyle.primary(context))),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: VerticalDivider(
                    color: AppColorStyle.primarySurface2(context),
                    thickness: 1.0,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: (coursesBloc
                                      .selectedSecondaryCourseDetailObject
                                      .value
                                      .institutionLogo !=
                                  null &&
                              coursesBloc.selectedSecondaryCourseDetailObject
                                  .value.institutionLogo!.isNotEmpty),
                          child: Container(
                              color: AppColorStyle.disableVariant(context),
                              height: 50,
                              width: 100,
                              child: CachedNetworkImage(
                                  imageUrl: coursesBloc
                                      .selectedSecondaryCourseDetailObject
                                      .value
                                      .institutionLogo!,
                                  fit: BoxFit.fill,
                                  placeholder: (context, error) =>
                                      SvgPicture.asset(IconsSVG.placeholder),
                                  errorWidget: (context, url, error) => Icon(
                                        Icons.photo,
                                        color: AppColorStyle.backgroundVariant(
                                            context),
                                      ))),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                            coursesBloc.selectedSecondaryCourseDetailObject
                                    .value.institutionName ??
                                "",
                            style: AppTextStyle.detailsSemiBold(
                                context, AppColorStyle.text(context))),
                        const SizedBox(height: 5.0),
                        Text(
                            "${coursesBloc.selectedSecondaryCourseDetailObject.value.instituteCity}",
                            style: AppTextStyle.captionRegular(
                                context, AppColorStyle.textDetail(context))),
                        Text(
                            "${Utility.getFullNameOfAUState("${coursesBloc.selectedSecondaryCourseDetailObject.value.instituteState}")} ${coursesBloc.selectedSecondaryCourseDetailObject.value.institutePostcode}",
                            style: AppTextStyle.captionRegular(
                                context, AppColorStyle.textDetail(context))),
                        const SizedBox(height: 15.0),
                        coursesBloc.selectedSecondaryCourseDetailObject.valueOrNull != null &&
                                coursesBloc.selectedSecondaryCourseDetailObject.valueOrNull!
                                        .instituteWebsite !=
                                    null &&
                                coursesBloc.selectedSecondaryCourseDetailObject
                                        .value.instituteWebsite !=
                                    "" &&
                                coursesBloc.selectedSecondaryCourseDetailObject
                                    .value.instituteWebsite!.isNotEmpty &&
                                (coursesBloc.selectedSecondaryCourseDetailObject
                                        .value.instituteWebsite!
                                        .startsWith("https", 0) ||
                                    coursesBloc
                                        .selectedSecondaryCourseDetailObject
                                        .value
                                        .instituteWebsite!
                                        .startsWith("http", 0) ||
                                    coursesBloc
                                        .selectedSecondaryCourseDetailObject
                                        .value
                                        .instituteWebsite!
                                        .startsWith("www", 0))
                            ? InkWellWidget(
                                onTap: () {
                                  if (coursesBloc
                                      .selectedSecondaryCourseDetailObject
                                      .valueOrNull!
                                      .instituteWebsite!
                                      .contains(",")) {
                                    String instituteWebsiteURL = coursesBloc
                                        .selectedSecondaryCourseDetailObject
                                        .valueOrNull!
                                        .instituteWebsite!
                                        .substring(
                                            coursesBloc
                                                    .selectedSecondaryCourseDetailObject
                                                    .value
                                                    .instituteWebsite!
                                                    .indexOf(",") +
                                                1,
                                            coursesBloc
                                                .selectedSecondaryCourseDetailObject
                                                .value
                                                .instituteWebsite!
                                                .length);
                                    Utility.launchURL(
                                        instituteWebsiteURL.trim());
                                  } else {
                                    Utility.launchURL(coursesBloc
                                        .selectedSecondaryCourseDetailObject
                                        .valueOrNull!
                                        .instituteWebsite!
                                        .trim());
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              AppColorStyle.primary(context)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0))),
                                  child: Text(StringHelper.explore,
                                      style: AppTextStyle.detailsSemiBold(
                                          context,
                                          AppColorStyle.primary(context))),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ViewCourseDetailsWidget extends StatelessWidget {
  const ViewCourseDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.commonPadding),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: InkWellWidget(
                onTap: () {
                  //todo: pending as anand said it was done after discussion and will create CR for that
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(StringHelper.viewCourseDetails,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.captionBold(
                                context, AppColorStyle.primary(context))),
                        const SizedBox(width: 5.0),
                        SvgPicture.asset(
                          IconsSVG.arrowRight,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.primary(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            VerticalDivider(
              color: AppColorStyle.primarySurface2(context),
              thickness: 1.0,
            ),
            Expanded(
              child: InkWellWidget(
                onTap: () {
                  //redirectToCourseDetailPage Pending as per Anand/ will create new CR for this
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: [
                        Text(StringHelper.viewCourseDetails,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.captionBold(
                                context, AppColorStyle.primary(context))),
                        const SizedBox(width: 5.0),
                        SvgPicture.asset(
                          IconsSVG.arrowRight,
                          colorFilter: ColorFilter.mode(
                            AppColorStyle.primary(context),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

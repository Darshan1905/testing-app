import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';

class CourseUniversityDataWidget extends StatelessWidget {
  const CourseUniversityDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: Constants.commonPadding,
              right: Constants.commonPadding,
              top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //University Data
              Text(StringHelper.offeredBy,
                  style: AppTextStyle.titleSemiBold(
                      context, AppColorStyle.text(context))),
              const SizedBox(height: 20.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: coursesBloc.courseDetailsDataObject.value
                        .institutionLogo!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: CachedNetworkImage(
                            height: 100,
                            width: 150,
                            imageUrl: coursesBloc
                                .courseDetailsDataObject.value.institutionLogo!,
                            fit: BoxFit.fill,
                            placeholder: (context, error) =>
                                SvgPicture.asset(IconsSVG.placeholder),
                            errorWidget: (context, url, error) => Icon(
                                  Icons.photo,
                                  color:
                                      AppColorStyle.backgroundVariant(context),
                                )),
                      )
                    : Container(),
              ),
              Text(
                  coursesBloc.courseDetailsDataObject.value.institutionName ??
                      "",
                  style: AppTextStyle.detailsSemiBold(
                      context, AppColorStyle.text(context))),
              const SizedBox(height: 5.0),
              Text(getAddress(coursesBloc: coursesBloc),
                  style: AppTextStyle.captionRegular(
                      context, AppColorStyle.textDetail(context))),
              Text("${coursesBloc.courseDetailsDataObject.value.instituteCity}",
                  style: AppTextStyle.captionRegular(
                      context, AppColorStyle.textDetail(context))),
              Text(
                  "${Utility.getFullNameOfAUState("${coursesBloc.courseDetailsDataObject.value.instituteState}")} ${coursesBloc.courseDetailsDataObject.value.institutePostcode}",
                  style: AppTextStyle.captionRegular(
                      context, AppColorStyle.textDetail(context))),
              const SizedBox(height: 20.0),
              coursesBloc.courseDetailsDataObject.valueOrNull != null &&
                      coursesBloc
                              .courseDetailsDataObject.value.instituteWebsite !=
                          null &&
                      coursesBloc
                              .courseDetailsDataObject.value.instituteWebsite !=
                          "" &&
                      coursesBloc.courseDetailsDataObject.value
                          .instituteWebsite!.isNotEmpty &&
                      (coursesBloc
                              .courseDetailsDataObject.value.instituteWebsite!
                              .startsWith("https", 0) ||
                          coursesBloc
                              .courseDetailsDataObject.value.instituteWebsite!
                              .startsWith("http", 0) ||
                          coursesBloc
                              .courseDetailsDataObject.value.instituteWebsite!
                              .startsWith("www", 0))
                  ? InkWellWidget(
                      onTap: () {
                        if (coursesBloc.courseDetailsDataObject.valueOrNull!
                            .instituteWebsite!
                            .contains(",")) {
                          String instituteWebsiteURL = coursesBloc
                              .courseDetailsDataObject
                              .valueOrNull!
                              .instituteWebsite!
                              .substring(
                                  coursesBloc.courseDetailsDataObject.value
                                          .instituteWebsite!
                                          .indexOf(",") +
                                      1,
                                  coursesBloc.courseDetailsDataObject.value
                                      .instituteWebsite!.length);
                          Utility.launchURL(instituteWebsiteURL.trim());
                        } else {
                          Utility.launchURL(coursesBloc.courseDetailsDataObject
                              .valueOrNull!.instituteWebsite!
                              .trim());
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: AppColorStyle.primary(context)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
                        child: Text(StringHelper.explore,
                            style: AppTextStyle.detailsSemiBold(
                                context, AppColorStyle.primary(context))),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
        Container(height: 5.0, color: AppColorStyle.backgroundVariant(context)),
        //Course Location Widget
        const CourseLocationWidget(),
        const SizedBox(height: 85.0),
      ],
    );
  }

  String getAddress({required CoursesBloc coursesBloc}) {
    String fullAddress = "";
    if (coursesBloc
        .courseDetailsDataObject.value.institutionAddress1!.isNotEmpty) {
      fullAddress =
          "$fullAddress${coursesBloc.courseDetailsDataObject.value.institutionAddress1}";
    }
    if (coursesBloc
        .courseDetailsDataObject.value.institutionAddress2!.isNotEmpty) {
      fullAddress =
          "$fullAddress\n${coursesBloc.courseDetailsDataObject.value.institutionAddress2}";
    }
    if (coursesBloc
        .courseDetailsDataObject.value.institutionAddress3!.isNotEmpty) {
      fullAddress =
          "$fullAddress\n${coursesBloc.courseDetailsDataObject.value.institutionAddress3}";
    }
    if (coursesBloc
        .courseDetailsDataObject.value.institutionAddress4!.isNotEmpty) {
      fullAddress =
          "$fullAddress\n${coursesBloc.courseDetailsDataObject.value.institutionAddress4}";
    }
    return fullAddress;
  }
}

class CourseLocationWidget extends StatelessWidget {
  const CourseLocationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);
    return (coursesBloc.courseDetailsDataObject.value.campusLocation != null &&
            coursesBloc
                .courseDetailsDataObject.value.campusLocation!.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: Constants.commonPadding,
                    right: Constants.commonPadding,
                    top: 20.0,
                    bottom: 10),
                child: Row(
                  children: [
                    Text(StringHelper.courseLocation,
                        style: AppTextStyle.detailsSemiBold(
                            context, AppColorStyle.textDetail(context))),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                          color: AppColorStyle.primarySurface1(context),
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Text(
                          coursesBloc.courseDetailsDataObject.value
                                      .campusLocation!.length >
                                  10
                              ? coursesBloc.courseDetailsDataObject.value
                                  .campusLocation!.length
                                  .toString()
                              : '0${coursesBloc.courseDetailsDataObject.value.campusLocation!.length.toString()}',
                          style: AppTextStyle.captionMedium(
                              context, AppColorStyle.primary(context))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: coursesBloc
                        .courseDetailsDataObject.value.campusLocation!.length,
                    itemBuilder: (context, index) {
                      final courseLocationList = coursesBloc
                          .courseDetailsDataObject.value.campusLocation![index];
                      return Container(
                        width: MediaQuery.of(context).size.width -
                            (Constants.commonPadding * 6),
                        padding: const EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(
                            left: index == 0 ? 20.0 : 0.0,
                            right: (((coursesBloc.courseDetailsDataObject.value
                                            .campusLocation!.length) -
                                        1) !=
                                    index)
                                ? 15.0
                                : 20.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColorStyle.surfaceVariant(context)),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(IconsSVG.mapPinIcon),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    Utility.getFullNameOfAUState(
                                        courseLocationList.state ?? ''),
                                    style: AppTextStyle.detailsSemiBold(
                                        context, AppColorStyle.text(context)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${courseLocationList.name} - ${courseLocationList.city}",
                                    style: AppTextStyle.captionRegular(context,
                                        AppColorStyle.textDetail(context)),
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          )
        : const SizedBox();
  }
}

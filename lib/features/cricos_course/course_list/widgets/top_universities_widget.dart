import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/app_style/text_style/app_text_style.dart';
import 'package:occusearch/app_style/theme/app_color_style.dart';
import 'package:occusearch/common_widgets/ink_well_widget.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';
import 'package:occusearch/features/cricos_course/course_list/model/top_universities_model.dart';
import 'package:occusearch/resources/string_helper.dart';
import 'package:occusearch/utility/utils.dart';
import 'package:shimmer/shimmer.dart';

class TopUniversitiesWidget extends StatelessWidget {
  const TopUniversitiesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesBloc = RxBlocProvider.of<CoursesBloc>(context);

    return StreamBuilder<bool>(
        stream: coursesBloc.topUniversitiesLoader.stream,
        builder: (context, snapshotLoading) {
          return (snapshotLoading.hasData &&
                  snapshotLoading.data != null &&
                  snapshotLoading.data == false)
              ? StreamBuilder(
                  stream: coursesBloc.getTopUniversitiesListStream,
                  builder: (context, snapshot) {
                    return (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.isNotEmpty)
                        ? Container(
                            color: AppColorStyle.backgroundVariant(context),
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: StringHelper.topUniversities,
                                          style: AppTextStyle.titleSemiBold(
                                            context,
                                            AppColorStyle.text(context),
                                          ),
                                        ),
                                        TextSpan(
                                          text: " ${StringHelper.australia}",
                                          style: AppTextStyle.titleSemiBold(
                                            context,
                                            AppColorStyle.primary(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  height: 290,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final TopInstitute universityList =
                                            coursesBloc
                                                .topUniversitiesListStream
                                                .value![index];
                                        return InkWellWidget(
                                          onTap: () {
                                            if (universityList
                                                        .instituteWebsite !=
                                                    null &&
                                                universityList.instituteWebsite!
                                                    .isNotEmpty) {
                                              Utility.launchURL(universityList
                                                      .instituteWebsite ??
                                                  "");
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.0,
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                bottom: 25.0),
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right:
                                                    ((snapshot.data!.length) -
                                                                1) ==
                                                            index
                                                        ? 20
                                                        : 0),
                                            decoration: BoxDecoration(
                                              // color: Colors.red,
                                              color: AppColorStyle.background(
                                                  context),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (universityList.rank !=
                                                        null &&
                                                    universityList
                                                        .rank!.isNotEmpty)
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25,
                                                        vertical: 8.0),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColorStyle.primary(
                                                              context),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(25),
                                                        bottomRight:
                                                            Radius.circular(25),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "${universityList.rank ?? ''} Rank",
                                                      style: AppTextStyle
                                                          .captionSemiBold(
                                                              context,
                                                              AppColorStyle
                                                                  .textWhite(
                                                                      context)),
                                                    ),
                                                  ),
                                                const SizedBox(height: 30),
                                                if (universityList
                                                            .institutionLogo !=
                                                        null &&
                                                    universityList
                                                        .institutionLogo!
                                                        .isNotEmpty)
                                                  Image.network(
                                                    universityList
                                                            .institutionLogo ??
                                                        '',
                                                    height: 100,
                                                    /*width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5) -
                                                100,*/
                                                  ),
                                                if (universityList
                                                            .institutionName !=
                                                        null &&
                                                    universityList
                                                        .institutionName!
                                                        .isNotEmpty)
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20.0),
                                                      child: Text(
                                                        universityList
                                                                .institutionName ??
                                                            '',
                                                        maxLines: 3,
                                                        style: AppTextStyle
                                                            .detailsSemiBold(
                                                                context,
                                                                AppColorStyle
                                                                    .text(
                                                                        context)),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                if (universityList
                                                            .instituteCity !=
                                                        null &&
                                                    universityList
                                                        .instituteCity!
                                                        .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30.0),
                                                    child: Text(
                                                      universityList
                                                              .instituteCity ??
                                                          '',
                                                      style: AppTextStyle
                                                          .captionRegular(
                                                              context,
                                                              AppColorStyle
                                                                  .textCaption(
                                                                      context)),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                // const SizedBox(height: 50)
                              ],
                            ),
                          )
                        : const SizedBox();
                  })
              : Column(
                  children: [
                    Container(
                        height: 15.0,
                        color: AppColorStyle.backgroundVariant(context)),
                    Shimmer.fromColors(
                      baseColor: AppColorStyle.shimmerPrimary(context),
                      highlightColor: AppColorStyle.shimmerSecondary(context),
                      period: const Duration(milliseconds: 1500),
                      child: Container(
                        height: 250,
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0, bottom: 25.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: AppColorStyle.background(context),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ));
                            }),
                      ),
                    ),
                  ],
                );
        });
  }
}

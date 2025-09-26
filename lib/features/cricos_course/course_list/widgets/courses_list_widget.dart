import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';
import 'package:occusearch/features/cricos_course/course_list/model/courses_filter_model.dart';

class CoursesListWidget {
  static coursesFilterBottomSheet(
      BuildContext context, CoursesBloc coursesBloc) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        //for refresh inside bottom sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Container(
                  color: AppColorStyle.backgroundVariant(context),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        StringHelper.filter,
                        style: AppTextStyle.titleSemiBold(
                            context, AppColorStyle.text(context)),
                      ),
                      InkWellWidget(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          IconsSVG.cross,
                          height: 18,
                          width: 18,
                        ),
                      )
                    ],
                  ),
                ),
                // FILTER
                Expanded(
                  child: StreamBuilder<List<FilterModelData>?>(
                    stream: coursesBloc.getCourseFilterStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final List<FilterModelData> filterMaster =
                            snapshot.data ?? [];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // [FILTER BY STATE, COURSE LEVEL BOARD ETC.,]
                            Container(
                              height: MediaQuery.of(context).size.height,
                              color: (coursesBloc
                                              .selectedIndexValue.valueOrNull !=
                                          null &&
                                      coursesBloc.selectedIndexValue.value)
                                  ? AppColorStyle.background(context)
                                  : AppColorStyle.backgroundVariant(context),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(
                                  filterMaster.length,
                                  (index) => InkWellWidget(
                                    onTap: () {
                                      if (filterMaster[index].isDepended &&
                                          filterMaster.length >
                                              filterMaster[index]
                                                  .dependedIndex &&
                                          filterMaster[filterMaster[index]
                                                      .dependedIndex]
                                                  .selectedAnswerStream
                                                  .valueOrNull ==
                                              null) {
                                        return null;
                                      } else {
                                        coursesBloc.selectedIndex.value = index;
                                      }
                                    },
                                    child: StreamBuilder<int>(
                                      stream: coursesBloc.selectedIndex.stream,
                                      builder: (context, snapshot) {
                                        final int? selectedIndex =
                                            snapshot.data;
                                        if (filterMaster[index].isDepended &&
                                            filterMaster.length >
                                                filterMaster[index]
                                                    .dependedIndex &&
                                            filterMaster[filterMaster[index]
                                                        .dependedIndex]
                                                    .selectedAnswerStream
                                                    .valueOrNull !=
                                                null) {
                                          coursesBloc.selectedIndexValue.value =
                                              (selectedIndex == index);
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.0,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 40.0,
                                                horizontal: 25.0),
                                            color: (selectedIndex == index)
                                                ? AppColorStyle.background(
                                                    context)
                                                : AppColorStyle
                                                    .backgroundVariant(context),
                                            child: Text(
                                              filterMaster[index].title ?? '',
                                              style: AppTextStyle.detailsMedium(
                                                context,
                                                AppColorStyle.text(context),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.0,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 40.0,
                                                horizontal: 25.0),
                                            color: (selectedIndex == index)
                                                ? AppColorStyle.background(
                                                    context)
                                                : AppColorStyle
                                                    .backgroundVariant(context),
                                            child: Text(
                                              filterMaster[index].title ?? '',
                                              style: AppTextStyle.detailsMedium(
                                                context,
                                                (filterMaster[index]
                                                            .isDepended &&
                                                        filterMaster.length >
                                                            filterMaster[index]
                                                                .dependedIndex)
                                                    ? AppColorStyle.textHint(
                                                        context)
                                                    : AppColorStyle.text(
                                                        context),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // [FILTER VALUE]
                            Expanded(
                              child: StreamBuilder<int>(
                                stream: coursesBloc.selectedIndex,
                                builder: (context, snapshot) {
                                  final int selectedFilterIndex =
                                      snapshot.data ?? 0;
                                  final List<FilterModel> filterValueList =
                                      filterMaster[selectedFilterIndex]
                                              .filterList ??
                                          [];
                                  return Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: AppColorStyle.background(context),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: filterValueList.length,
                                      itemBuilder: (context, filterValueIndex) {
                                        FilterModel? previousAnswerModel;
                                        if (filterMaster[selectedFilterIndex]
                                                .isDepended &&
                                            filterMaster.length >
                                                filterMaster[
                                                        selectedFilterIndex]
                                                    .dependedIndex) {
                                          previousAnswerModel = filterMaster[
                                                  filterMaster[
                                                          selectedFilterIndex]
                                                      .dependedIndex]
                                              .selectedAnswerStream
                                              .valueOrNull;
                                        }

                                        // Here we only show data where previously selected answer match with current filter data
                                        if (previousAnswerModel != null &&
                                            previousAnswerModel.id != null &&
                                            previousAnswerModel.id != "" &&
                                            !(filterValueList[filterValueIndex]
                                                        .id ??
                                                    '')
                                                .startsWith(
                                                    previousAnswerModel.id ??
                                                        '*')) {
                                          return const SizedBox();
                                        }
                                        return StreamBuilder<FilterModel?>(
                                          stream:
                                              filterMaster[selectedFilterIndex]
                                                  .selectedAnswerStream,
                                          // user selected filter data
                                          builder: (context, snapshot) {
                                            String selectedAns =
                                                ""; // user given answer store in this variable
                                            if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              selectedAns =
                                                  (snapshot.data as FilterModel)
                                                          .name ??
                                                      '';
                                            }

                                            return InkWellWidget(
                                              onTap: () {
                                                //ANSWER SELECT-DESELECT
                                                if (selectedAns ==
                                                    filterValueList[
                                                            filterValueIndex]
                                                        .name) {
                                                  filterMaster[
                                                          selectedFilterIndex]
                                                      .selectedAnswerStream
                                                      .sink
                                                      .add(null);
                                                } else {
                                                  filterMaster[
                                                          selectedFilterIndex]
                                                      .selectedAnswerStream
                                                      .sink
                                                      .add(filterValueList[
                                                          filterValueIndex]);
                                                }

                                                // If any depends on this we here set null to unselect
                                                if (filterMaster.length >
                                                    selectedFilterIndex) {
                                                  for (int i =
                                                          selectedFilterIndex +
                                                              1;
                                                      i < filterMaster.length;
                                                      i++) {
                                                    if (filterMaster[i]
                                                        .isDepended) {
                                                      filterMaster[i]
                                                          .selectedAnswerStream
                                                          .sink
                                                          .add(null);
                                                    }
                                                  }
                                                }
                                                // HERE WE REFRESH FILTER TITLE LIST FOR DEPEND FILTER VALUE LIST
                                                coursesBloc.selectedIndex.sink
                                                    .add(coursesBloc
                                                        .selectedIndex.value);
                                              },
                                              child: filterValueList[
                                                                  filterValueIndex]
                                                              .name !=
                                                          null &&
                                                      filterValueList[
                                                              filterValueIndex]
                                                          .name!
                                                          .isNotEmpty
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          selectedAns.isNotEmpty &&
                                                                  selectedAns ==
                                                                      filterValueList[
                                                                              filterValueIndex]
                                                                          .name
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 2.0),
                                                                  child: Icon(
                                                                    Icons.check,
                                                                    color: AppColorStyle
                                                                        .primary(
                                                                            context),
                                                                    size: 14.0,
                                                                  ),
                                                                )
                                                              : const SizedBox(
                                                                  height: 14,
                                                                  width: 14,
                                                                ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          15.0),
                                                              child: Text(
                                                                filterValueList[
                                                                            filterValueIndex]
                                                                        .name ??
                                                                    '',
                                                                style: selectedAns
                                                                            .isNotEmpty &&
                                                                        selectedAns ==
                                                                            filterValueList[filterValueIndex]
                                                                                .name
                                                                    ? AppTextStyle.detailsRegular(
                                                                        context,
                                                                        AppColorStyle.text(
                                                                            context))
                                                                    : AppTextStyle.detailsRegular(
                                                                        context,
                                                                        AppColorStyle.textCaption(
                                                                            context)),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                // FOOTER [CLEAR + RESULT] BUTTON
                StreamBuilder<List<FilterModelData>?>(
                    stream: coursesBloc.getCourseFilterStream,
                    builder: (context, snapshot) {
                      final List<FilterModelData> filterMaster =
                          snapshot.data ?? [];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWellWidget(
                            onTap: () {
                              if (filterMaster.isNotEmpty) {
                                for (int i = 0; i < filterMaster.length; i++) {
                                  filterMaster[i].selectedAnswerStream.value =
                                      null;
                                }
                              }
                              // Here we refresh filter title list for depended filter value list
                              coursesBloc.selectedIndex.sink.add(0);
                              coursesBloc.setIsCourseAppliedFilter = false;
                            },
                            child: Container(
                              height: 60.0,
                              width: MediaQuery.of(context).size.width / 3.0,
                              color: AppColorStyle.background(context),
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, left: 20.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  StringHelper.clearFilter,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyle.detailsRegular(
                                      context, AppColorStyle.red(context)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWellWidget(
                              onTap: () {
                                String requestParam = "";
                                if (filterMaster.isNotEmpty) {
                                  for (int i = 0;
                                      i < filterMaster.length;
                                      i++) {
                                    if (filterMaster[i]
                                            .selectedAnswerStream
                                            .valueOrNull ==
                                        null) {
                                      requestParam +=
                                          "${filterMaster[i].apiKey}=&";
                                    } else {
                                      if (filterMaster[i]
                                              .title
                                              .toString()
                                              .contains("State") ||
                                          filterMaster[i]
                                              .apiKey
                                              .toString()
                                              .contains("state")) {
                                        //FOR ONLY STATE FILTER WE NEED TO PASS ID [SHORT NAME]
                                        if (filterMaster[i]
                                                .selectedAnswerStream
                                                .value
                                                ?.id
                                                ?.isNotEmpty ==
                                            true) {
                                          requestParam +=
                                              "${filterMaster[i].apiKey}=${filterMaster[i].selectedAnswerStream.value!.id}&";
                                          coursesBloc.setIsCourseAppliedFilter =
                                              true;
                                        } else {
                                          coursesBloc.setIsCourseAppliedFilter =
                                              false;
                                        }
                                      } else {
                                        if (filterMaster[i]
                                                .selectedAnswerStream
                                                .value
                                                ?.name
                                                ?.isNotEmpty ==
                                            true) {
                                          coursesBloc.setIsCourseAppliedFilter =
                                              true;
                                          requestParam +=
                                              "${filterMaster[i].apiKey}=${filterMaster[i].selectedAnswerStream.value!.name}&";
                                        } else {
                                          coursesBloc.setIsCourseAppliedFilter =
                                              false;
                                        }
                                      }
                                    }
                                  }
                                  printLog(
                                      "Course API filter URL :: $requestParam");
                                  printLog(
                                      "Is Course Filter Applied or not :: ${coursesBloc.isCourseFilterAppliedSubject.value}");
                                }
                                if (requestParam.isNotEmpty) {
                                  coursesBloc.getCoursesList(
                                      reqParam: requestParam);
                                }
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 60.0,
                                color: AppColorStyle.primary(context),
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0, right: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      StringHelper.viewResults,
                                      maxLines: 3,
                                      style: AppTextStyle.subTitleMedium(
                                          context,
                                          AppColorStyle.textWhite(context)),
                                    ),
                                    const SizedBox(width: 20.0),
                                    SvgPicture.asset(IconsSVG.arrowRight)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            );
          },
        );
      },
    );
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/no_internet_screen.dart';
import 'package:occusearch/common_widgets/search_field_widget.dart';
import 'package:occusearch/common_widgets/stream_widget.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_list/widgets/course_list_shimmer.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';
import 'package:occusearch/features/cricos_course/course_list/widgets/courses_list_widget.dart';
import 'package:rxdart/rxdart.dart';

class CoursesListScreen extends BaseApp {
  const CoursesListScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends BaseState {
  final CoursesBloc coursesBloc = CoursesBloc();
  GlobalBloc? _globalBloc;
  late ScrollController _controller;
  bool isFromCompare = false; //for showing search screen after compare course.

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  @override
  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_globalBloc != null &&
          _globalBloc!.cache10CourseListRecords.valueOrNull != null &&
          (_globalBloc!.cache10CourseListRecords.valueOrNull ?? [])
              .isNotEmpty) {
        coursesBloc.setAddedFlagToAllCourseList(
            _globalBloc!.cache10CourseListRecords.value);
        coursesBloc.isLoadingCourse.sink.add(false);
      } else {
        coursesBloc.isFirstTime.sink.add(false);
      }
    });

    if (widget.arguments != null) {
      var args = widget.arguments;
      /*params = {
        "isFromCompare": true
      };*/
      if (args != null) {
        isFromCompare = args["isFromCompare"];
      }
      coursesBloc.getCourseFilterData();
    }
  }

  @override
  onResume() async {
    Future.delayed(Duration.zero, () async {
      coursesBloc.pageNo.value = 1;
      coursesBloc.isSearchFocus.value = "";

      // SEARCH FIELD
      coursesBloc.searchStream
          .debounce((_) => TimerStream(true, const Duration(milliseconds: 500)))
          .switchMap((filter) async* {
        if (!coursesBloc.isFirstTime.value) {
          yield await coursesBloc.getCoursesListBySearch(
              searchData: filter, globalBloc: _globalBloc);
        } else {
          coursesBloc.isFirstTime.sink.add(false);
        }
      }).listen((courseData) {
        printLog(courseData);
        printLog(courseData.isEmpty);
        coursesBloc.setAddedFlagToAllCourseList(courseData);
        coursesBloc.isLoadingCourse.sink.add(false);
      });
    });
  }

  final TextEditingController searchTextController = TextEditingController();

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    _controller = ScrollController()..addListener(_loadMore);
    return RxBlocProvider(
      create: (_) => coursesBloc,
      child: Container(
        color: AppColorStyle.background(context),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                visible: isFromCompare == true ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: Constants.commonPadding,
                      right: Constants.commonPadding,
                      top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text("Add course to compare",
                                style: AppTextStyle.titleSemiBold(
                                    context, AppColorStyle.text(context))),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          InkWellWidget(
                              onTap: () {
                                context.pop();
                              },
                              child: SvgPicture.asset(
                                IconsSVG.closeIcon,
                                height: 15.0,
                                width: 15.0,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          "Search and select a course and it’ll be added to\ncomparison",
                          style: AppTextStyle.detailsRegular(
                              context, AppColorStyle.textHint(context))),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: Constants.commonPadding,
                    right: Constants.commonPadding,
                    top: 20.0),
                child: StreamBuilder<String>(
                    stream: coursesBloc.isSearchFocus.stream,
                    builder: (context, snapshotSearchFocus) {
                      return StreamBuilder(
                          stream: CombineLatestStream.list([
                            coursesBloc.courseFilterStream.stream,
                            coursesBloc.isCourseFilterAppliedSubject.stream
                          ]),
                          builder: (context, snapshotFilter) {
                            return SearchTextField(
                                controller: coursesBloc.searchTextController,
                                searchHintText: StringHelper.searchHere,
                                prefixIcon: IconsSVG.arrowBack,
                                isBackIcon: true,
                                isBackIconVisible:
                                    isFromCompare == true ? false : true,
                                isFilterIcon: isFromCompare == true
                                    ? false
                                    : (snapshotSearchFocus.data != null &&
                                            snapshotSearchFocus.data != "")
                                        ? false
                                        : true,
                                // show true only if for course list screen not for compare search screen
                                onTextChanged: (typingText) async {
                                  coursesBloc.searchStream.sink.add(typingText);

                                  coursesBloc.onSearch(typingText);
                                  //While removing data from search API calling was not calling
                                  //when search becomes blank we set all data as initial data
                                  if (typingText.isEmpty) {
                                    coursesBloc.isSearchFocus.value = "";
                                    coursesBloc.pageNo.value = 1;
                                    coursesBloc.searchCoursesListStream.value =
                                        [];
                                    await coursesBloc.getCoursesList();
                                  } else {
                                    coursesBloc.isSearchFocus.value =
                                        typingText;
                                  }
                                },
                                onClear: () async {
                                  coursesBloc.clearSearch();
                                  // API call with search text clear data
                                  await coursesBloc.getCoursesList();
                                },
                                onFilterTap: () {
                                  if (coursesBloc
                                              .courseFilterStream.valueOrNull !=
                                          null &&
                                      coursesBloc.courseFilterStream
                                          .valueOrNull!.isNotEmpty) {
                                    CoursesListWidget.coursesFilterBottomSheet(
                                        context, coursesBloc);
                                  }
                                },
                                isFilterAppliedOrNot: coursesBloc
                                    .isCourseFilterAppliedSubject.value);
                          });
                    }),
              ),
              const SizedBox(
                height: 10.0,
              ),
              StreamWidget(
                stream: coursesBloc.searchCoursesListStream.stream,
                onBuild: (context, snapData) {
                  final List<CourseList> coursesList =
                      (snapData != null && snapData != []) ? snapData : [];
                  return coursesList.isNotEmpty
                      ? Expanded(
                          child: AnimationLimiter(
                            child: ListView.builder(
                              controller: _controller,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 50),
                              itemCount: coursesList.length,
                              itemBuilder: (context, index) {
                                final coursesData = coursesList[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: coursesRowView(
                                          coursesData, coursesList, index),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : coursesBloc.isLoadingCourse.value
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Constants.commonPadding),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 50),
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    return const CourserListShimmer();
                                  },
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: NetworkController.isInternetConnected
                                    ? NoDataFoundScreen(
                                        noDataTitle: StringHelper.noDataFound,
                                        noDataSubTitle: StringHelper
                                            .tryAgainWithDiffCriteria,
                                      )
                                    : NoInternetScreen(
                                        onRetry: () {
                                          onResume();
                                        },
                                      ),
                              ),
                            );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget coursesRowView(
      CourseList courseData, List<CourseList> coursesList, int index) {
    return InkWellWidget(
      onTap: () async {
        if (isFromCompare) {
          //navigate back result in course Compare
          context.pop(courseData);
        } else {
          FirebaseAnalyticLog.shared.eventTracking(
              screenName: RouteName.coursesListScreen,
              actionEvent: "",
              sectionName: FBSectionEvent.fbSectionSearchCourse);
          GoRoutesPage.go(
              mode: NavigatorMode.push,
              moveTo: RouteName.coursesDetailScreen,
              param: courseData //FOR RECENT SEARCH COURSE
              );
          coursesBloc.clearSearch();
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.commonPadding, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseData.courseName ?? "",
                  style: AppTextStyle.detailsMedium(
                    context,
                    AppColorStyle.text(context),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  courseData.institutionName ?? "",
                  style: AppTextStyle.detailsRegular(
                    context,
                    AppColorStyle.textDetail(context),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "${StringHelper.cricosText}-${courseData.courseCode!}",
                      style: AppTextStyle.captionSemiBold(
                        context,
                        AppColorStyle.primary(context),
                      ),
                    ),
                    Visibility(
                      visible: courseData.isAdded ?? false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColorStyle.teal(context),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: Text(
                              StringHelper.added.toUpperCase(),
                              style: AppTextStyle.captionSemiBold(
                                context,
                                AppColorStyle.textWhite(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    //REMOVED because there is no intake so, no data after added.
                    /*Text(
                      "●",
                      style: AppTextStyle.captionMedium(
                        context,
                        AppColorStyle.text(context),
                      ),
                    ),
                    const SizedBox(width: 10),*/
                  ],
                ),
              ],
            ),
          ),
          ((coursesList.length) - 1) != index
              ? Padding(
                  padding: const EdgeInsets.only(left: Constants.commonPadding),
                  child: Divider(
                      color: AppColorStyle.borderColors(context),
                      thickness: 0.5),
                )
              : const SizedBox(),
          (index == (coursesList.length - 1) &&
                  coursesBloc.isLastPage.value == false)
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.commonPadding),
                  child: SizedBox(
                    height: index == (coursesList.length - 1) ? 120 : 0,
                    child: const CourserListShimmer(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void _loadMore() async {
    try {
      if (NetworkController.isInternetConnected) {
        if (_isLoadMoreRunning == false &&
            _controller.position.maxScrollExtent == _controller.offset) {
          setState(() {
            _isLoadMoreRunning =
                true; // Display a progress indicator at the bottom
          });
          _controller.position.animateTo(_controller.offset + 120,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut);
          coursesBloc.pageNo.value += 1; // Increase _page by 1
          try {
            if (coursesBloc.isLastPage.value == false) {
              await coursesBloc.getCoursesList();
            }
          } catch (err) {
            debugPrint('Something went wrong!');
          }
          setState(() {
            _isLoadMoreRunning = false;
          });
        }
      } else {
        Toast.show(context,
            message: StringHelper.internetConnection, type: Toast.toastError);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

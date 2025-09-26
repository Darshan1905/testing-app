import 'dart:async';

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';
import 'package:occusearch/features/cricos_course/course_list/widgets/top_universities_widget.dart';
import 'package:occusearch/features/dashboard/widget/course_recent_search_widget.dart';
import 'package:occusearch/features/dashboard/widget/most_visited_occupation_widget.dart';
import 'package:occusearch/features/dashboard/widget/occupation_recent_search_widget.dart';
import 'package:occusearch/features/discover_dream/discover_dream_bloc.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_bloc.dart';
import 'package:occusearch/features/discover_dream/widget/market_place_overview_widget.dart';
import 'package:occusearch/features/discover_dream/widget/search_header_widget.dart';
import 'package:occusearch/features/discover_dream/widget/unit_group_widget.dart';
import 'package:occusearch/features/my_bookmark/my_bookmark_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_bloc.dart';

class DiscoverDreamScreen extends BaseApp {
  const DiscoverDreamScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _DiscoverDreamScreenScreenState();
}

class _DiscoverDreamScreenScreenState extends BaseState {
  OccupationListBloc occupationBloc = OccupationListBloc();
  OccupationDetailBloc searchOccuBloc = OccupationDetailBloc();
  CoursesBloc coursesBloc = CoursesBloc();
  DiscoverDreamBloc discoverDreamBloc = DiscoverDreamBloc();
  MyBookmarkBloc myBookmarkBloc = MyBookmarkBloc();
  UnitGroupBloc occupationUnitGroupBloc = UnitGroupBloc();

  final occupationSearchController = TextEditingController();

  //For search hint animation
  PageController _pageControllerOccupationContribute =
      PageController(initialPage: 0);
  PageController _pageControllerCourseContribute =
      PageController(initialPage: 0);
  int _currentOccupationContributePage = 0;
  int _currentCourseContributePage = 0;

  GlobalBloc? _globalBloc;
  UserInfoData? info;
  int occupationListCount = 0;
  int courseListCount = 0;
  Timer? occupationTimer, courseTimer;

  @override
  init() async {
    info = await _globalBloc?.getUserInfo(context);
    coursesBloc.getTopUniversitiesInAustraliaList();
    //unit_group group occupation
    await occupationUnitGroupBloc.getOccupationUnitGroupList();
    //market place data from staging api
    discoverDreamBloc.getMarketPlaceAustraliaData();
    occupationListCount = await occupationBloc.getOccupationsList();
    // Animation start for search widget
    if (occupationBloc.categoryTypeStream.value ==
        SearchCategoryType.OCCUPATION) {
      setContributeOccupationAnimation();
    }
  }

  @override
  onResume() async {
    //get most visited occupation list
    _globalBloc!.getOccupationVisitedCountData();

    await occupationBloc.getOccupationsRecentList();
    await coursesBloc.getCourseRecentList();
    myBookmarkBloc.getAllBookmarkList(type: "");

    if (_globalBloc!.cache10CourseListRecords.valueOrNull == null &&
        (_globalBloc!.cache10CourseListRecords.valueOrNull ?? []).isEmpty) {
      await coursesBloc.getCoursesListBySearch(
          searchData: "", globalBloc: _globalBloc);
      courseListCount =
          _globalBloc!.cache10CourseListRecords.valueOrNull!.length;
    }
  }

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    return Container(
      height: double.infinity,
      color: AppColorStyle.background(context),
      child: RxMultiBlocProvider(
        providers: [
          RxBlocProvider<OccupationListBloc>(
              create: (context) => occupationBloc),
          RxBlocProvider<CoursesBloc>(create: (context) => coursesBloc),
          RxBlocProvider<DiscoverDreamBloc>(
              create: (context) => discoverDreamBloc),
          RxBlocProvider<UnitGroupBloc>(
              create: (context) => occupationUnitGroupBloc),
        ],
        child: Container(
          height: double.infinity,
          color: AppColorStyle.background(context),
          child: SafeArea(
            child: SingleChildScrollView(
              child: StreamBuilder<SearchCategoryType>(
                stream: occupationBloc.getCategoryTypeStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    SearchCategoryType type = snapshot.data!;
                    return Column(
                      children: [
                        SearchHeaderWidget(globalBloc: _globalBloc),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Constants.commonPadding,
                              vertical: 20.0),
                          child: Row(
                            children: [
                              InkWellWidget(
                                  onTap: () {
                                    occupationBloc.setCategoryType =
                                        SearchCategoryType.OCCUPATION;

                                    courseTimer?.cancel();
                                    setContributeOccupationAnimation();
                                  },
                                  child: Text(
                                    "Occupation",
                                    style: type == SearchCategoryType.OCCUPATION
                                        ? AppTextStyle.subHeadlineSemiBold(
                                            context,
                                            AppColorStyle.primary(context))
                                        : AppTextStyle.detailsRegular(context,
                                            AppColorStyle.textHint(context)),
                                  )),
                              const SizedBox(width: 40),
                              InkWellWidget(
                                      onTap: () async {
                                        if(globalBloc?.subscriptionType == AppType.PAID) {
                                          occupationBloc.setCategoryType =
                                              SearchCategoryType.COURSE;

                                          occupationTimer?.cancel();
                                          setContributeCourseAnimation();
                                        } else {
                                          GoRoutesPage.go(
                                              mode: NavigatorMode.push,
                                              moveTo: RouteName.subscription);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Course",
                                            style: type == SearchCategoryType.COURSE
                                                ? AppTextStyle.subHeadlineSemiBold(
                                                    context,
                                                    AppColorStyle.primary(context))
                                                : AppTextStyle.detailsRegular(
                                                    context,
                                                    AppColorStyle.textHint(
                                                        context)),
                                          ),
                                          const SizedBox(width: 10),
                                          globalBloc?.subscriptionType == AppType.PAID ? Container() : SvgPicture.asset(
                                            IconsSVG.icPremiumFeature,
                                            width: 20,
                                            height: 20,
                                          )
                                        ],
                                      ))
                            ],
                          ),
                        ),
                        InkWellWidget(
                          onTap: () {
                            if (type == SearchCategoryType.OCCUPATION) {
                              GoRoutesPage.go(
                                  mode: NavigatorMode.push,
                                  moveTo: RouteName.occupationListScreen);
                            } else if (type == SearchCategoryType.COURSE) {
                              var params = {"isFromCompare": false};
                              GoRoutesPage.go(
                                  mode: NavigatorMode.push,
                                  moveTo: RouteName.coursesListScreen,
                                  param: params);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.commonPadding),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      AppColorStyle.backgroundVariant(context)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: SvgPicture.asset(IconsSVG.searchIcon,
                                        width: 20, height: 20),
                                  ),
                                  const SizedBox(width: 15.0),
                                  Text(
                                    "Search ",
                                    style: AppTextStyle.subTitleRegular(context,
                                        AppColorStyle.textHint(context)),
                                  ),
                                  // Occupation tab
                                  if (type == SearchCategoryType.OCCUPATION)
                                    StreamBuilder<List<String>?>(
                                      stream: occupationBloc
                                          .occupationHintSearchList.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null) {
                                          List<String> occupationHintTextList =
                                              snapshot.data ?? [];
                                          occupationHintTextList.shuffle();
                                          return SizedBox(
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.8),
                                            child: _animatedSearchWidget(
                                                occupationHintTextList),
                                          );
                                        } else {
                                          return const SizedBox(
                                            height: 50.0,
                                          );
                                        }
                                      },
                                    ),
                                  if (type == SearchCategoryType.COURSE)
                                    StreamBuilder<List<CourseList>>(
                                      stream: globalBloc
                                          ?.cache10CourseListRecords.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null) {
                                          List<String> courseHintList = snapshot
                                              .data!
                                              .map((e) => e.courseName ?? '')
                                              .cast<String>()
                                              .toList();
                                          courseHintList.shuffle();
                                          return SizedBox(
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.8),
                                            child: _animatedSearchWidget(
                                                courseHintList),
                                          );
                                        } else {
                                          return const SizedBox(
                                            height: 50.0,
                                          );
                                        }
                                      },
                                    ),
                                  /*const SizedBox(
                                      height: 50.0,
                                    ),*/
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        AnimationLimiter(
                          child: Column(
                              children: AnimationConfiguration.toStaggeredList(
                                  duration: const Duration(milliseconds: 500),
                                  childAnimationBuilder: (widget) =>
                                      SlideAnimation(
                                        horizontalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: widget,
                                        ),
                                      ),
                                  children: [
                                //RECENT OCCUPATION
                                if (snapshot.data ==
                                    SearchCategoryType.OCCUPATION)
                                  StreamBuilder(
                                    stream: occupationBloc
                                        .mostVisitedOccupationListStream.stream,
                                    builder: (context, mostVisitedSnapshot) {
                                      return (mostVisitedSnapshot.hasData &&
                                              mostVisitedSnapshot.data != null)
                                          ? Visibility(
                                              visible: mostVisitedSnapshot
                                                  .data!.isNotEmpty,
                                              child:
                                                  OccupationRecentSearchWidget(
                                                      occupationBloc:
                                                          occupationBloc,
                                                      globalBloc: _globalBloc),
                                            )
                                          : const SizedBox();
                                    },
                                  ),

                                //MOST VISITED OCCUPATION
                                if (snapshot.data ==
                                    SearchCategoryType.OCCUPATION)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: MostVisitedOccupationWidget(
                                        isFromOccupationTab: true),
                                  ),

                                //UNIT GROUP
                                UnitGroupWidget(
                                    unitGroupBloc: occupationUnitGroupBloc,globalBloc: _globalBloc),

                                //market place widget
                                if (snapshot.data ==
                                    SearchCategoryType.OCCUPATION)
                                  MarketPlaceOverviewWidget(
                                      themeBloc?.currentTheme ?? false),

                                //RECENT SEARCH COURSE SECTION
                                if (snapshot.data == SearchCategoryType.COURSE)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CourseRecentSearchWidget(
                                          coursesBloc: coursesBloc),
                                      Container(
                                        color:
                                            AppColorStyle.background(context),
                                        child: const TopUniversitiesWidget(),
                                      ),
                                    ],
                                  ),
                              ])),
                        ),
                      ],
                    );
                  } else {
                    return Container(color: AppColorStyle.background(context));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  setContributeOccupationAnimation() {
    occupationTimer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) {
        if (occupationListCount > _currentOccupationContributePage) {
          _currentOccupationContributePage++;
        } else {
          _currentOccupationContributePage = 0;
        }
        if (_pageControllerOccupationContribute.hasClients) {
          _pageControllerOccupationContribute.animateToPage(
            _currentOccupationContributePage,
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
          );
        }
      },
    );
  }

  setContributeCourseAnimation() {
    courseTimer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) {
        if (courseListCount > _currentCourseContributePage) {
          _currentCourseContributePage++;
        } else {
          _currentCourseContributePage = 0;
        }
        if (_pageControllerCourseContribute.hasClients) {
          _pageControllerCourseContribute.animateToPage(
            _currentCourseContributePage,
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
          );
        }
      },
    );
  }

  Widget _animatedSearchWidget(List<String> hintSearchList) {
    _currentOccupationContributePage = 0;
    _currentCourseContributePage = 0;
    _pageControllerOccupationContribute = PageController(initialPage: 0);
    _pageControllerCourseContribute = PageController(initialPage: 0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          width: (MediaQuery.of(context).size.width / 1.8),
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              if (occupationBloc.categoryTypeStream.value ==
                  SearchCategoryType.OCCUPATION) {
                _currentOccupationContributePage = index;
              }
              if (occupationBloc.categoryTypeStream.value ==
                  SearchCategoryType.COURSE) {
                _currentCourseContributePage = index;
              }
            },
            scrollDirection: Axis.vertical,
            controller: (occupationBloc.categoryTypeStream.value ==
                    SearchCategoryType.OCCUPATION)
                ? _pageControllerOccupationContribute
                : _pageControllerCourseContribute,
            itemCount: hintSearchList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hintSearchList[index],
                    style: AppTextStyle.subTitleRegular(
                        context, AppColorStyle.textHint(context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageControllerOccupationContribute.dispose();
    _pageControllerCourseContribute.dispose();
  }
}

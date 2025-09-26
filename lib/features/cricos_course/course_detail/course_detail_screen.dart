import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/no_internet_screen.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/cricos_course/course_compare/course_compare_bottom_sheet.dart';
import 'package:occusearch/features/cricos_course/course_detail/model/add_course_data_model.dart';
import 'package:occusearch/features/cricos_course/course_detail/widget/course_detail_data_widget.dart';
import 'package:occusearch/features/cricos_course/course_detail/widget/course_detail_shimmer.dart';
import 'package:occusearch/features/cricos_course/course_detail/widget/course_discipline_widget.dart';
import 'package:occusearch/features/cricos_course/course_detail/widget/course_overview_widget.dart';
import 'package:occusearch/features/cricos_course/course_detail/widget/course_related_occupation_widget.dart';
import 'package:occusearch/features/cricos_course/course_detail/widget/course_university_data_widget.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_shimmer.dart';

class CoursesDetailScreen extends BaseApp {
  const CoursesDetailScreen({super.key, super.arguments}) : super.builder();

  @override
  BaseState createState() => _CoursesDetailScreenState();
}

class _CoursesDetailScreenState extends BaseState {
  CoursesBloc coursesBloc = CoursesBloc();
  GlobalBloc? _globalBloc;
  UserInfoData? info;

  bool _showBackToTopButton = false;

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  init() async {
    initData();
  }

  void initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dynamic args = widget.arguments;

      info = await _globalBloc?.getUserInfo(context);

      if (args != null && args != "") {
        //get course detail data
        await coursesBloc.getCoursesDetailData(args, 2,
            isFromDetailPage:
                true); //2:for set data in secondary but if bool is false
      }

      _scrollController.addListener(() {
        setState(() {
          if (_scrollController.offset >= 50) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });
    });
  }

  @override
  Widget body(BuildContext context) {
    _globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);

    return RxMultiBlocProvider(
      providers: [
        RxBlocProvider<CoursesBloc>(create: (context) => coursesBloc),
      ],
      child: Container(
        color: AppColorStyle.primary(context),
        child: StreamBuilder(
            stream: coursesBloc.courseDetailsDataObject.stream,
            builder: (_, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                // int? relatedOccupationLength = snapshot.data?.ugCode!.length;
                return SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                                expandedHeight: 200,
                                backgroundColor: AppColorStyle.primary(context),
                                floating: true,
                                elevation: 0,
                                toolbarHeight: 50,
                                pinned: true,
                                automaticallyImplyLeading: false,
                                leadingWidth: 50,
                                leading: InkWellWidget(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: Constants.commonPadding),
                                    child: SvgPicture.asset(
                                      IconsSVG.arrowBack,
                                      colorFilter: ColorFilter.mode(
                                        AppColorStyle.textWhite(context),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  !innerBoxIsScrolled
                                      ? StreamBuilder<bool>(
                                          stream: coursesBloc
                                              .courseAddRemoveLoaderStream,
                                          builder: (context, loaderSnapshot) {
                                            bool loading =
                                                loaderSnapshot.data ?? false;

                                            return Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              width: 30,
                                              margin: const EdgeInsets.only(
                                                  right:
                                                      Constants.commonPadding,
                                                  top: 10,
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppColorStyle.textWhite(
                                                          context),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              40.0))),
                                              child: InkWellWidget(
                                                  onTap: () {
                                                    if (coursesBloc
                                                        .selectedCourseIsAdded) {
                                                      // Calling API to add new course
                                                      AddCourseData data =
                                                          AddCourseData();
                                                      data.ascedCode = coursesBloc
                                                          .courseDetailsDataObject
                                                          .value
                                                          .ascedCode;
                                                      data.cricos = coursesBloc
                                                          .courseDetailsDataObject
                                                          .value
                                                          .courseCode;
                                                      data.courseName = coursesBloc
                                                          .courseDetailsDataObject
                                                          .value
                                                          .courseName;

                                                      // Calling API to remove added course
                                                      coursesBloc.deleteCourse(
                                                          context: context,
                                                          coursesObject: data,
                                                          userInfoData: info!);
                                                    } else {
                                                      if (coursesBloc
                                                              .selectedCourseName
                                                              ?.isNotEmpty ??
                                                          false) {
                                                        // Calling API to add new course
                                                        AddCourseData data =
                                                            AddCourseData();
                                                        data.ascedCode = coursesBloc
                                                            .courseDetailsDataObject
                                                            .value
                                                            .ascedCode;
                                                        data.cricos = coursesBloc
                                                            .courseDetailsDataObject
                                                            .value
                                                            .courseCode;
                                                        data.courseName =
                                                            coursesBloc
                                                                .courseDetailsDataObject
                                                                .value
                                                                .courseName;
                                                        coursesBloc.addCourse(
                                                            context,
                                                            data,
                                                            info!);
                                                      }
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 3.5,
                                                        horizontal: 5),
                                                    child: loading
                                                        ? SizedBox(
                                                            height: 15,
                                                            width: 15,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 1.5,
                                                              color: AppColorStyle
                                                                  .primary(
                                                                      context),
                                                            ),
                                                          )
                                                        : SvgPicture.asset(
                                                            coursesBloc
                                                                    .selectedCourseIsAdded
                                                                ? IconsSVG
                                                                    .bookmarkSelected
                                                                : IconsSVG
                                                                    .bookmarkUnselected,
                                                          ),
                                                  )),
                                            );
                                          })
                                      : InkWellWidget(
                                          onTap: () {
                                            //to clear data when click on any compare button from bottom sheet if selected.
                                            coursesBloc
                                                .viewSelectedCourseToCompare
                                                .sink
                                                .add(false);
                                            CourseCompareBottomSheet
                                                .showCourseCompareBottomSheet(
                                                    context,
                                                    coursesBloc
                                                        .courseDetailsDataObject
                                                        .value,
                                                    coursesBloc);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                right: Constants.commonPadding,
                                                top: 10,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      AppColorStyle.textWhite(
                                                          context)),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3.0,
                                                      horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Text("+ ",
                                                      style: AppTextStyle
                                                          .subTitleSemiBold(
                                                              context,
                                                              AppColorStyle
                                                                  .textWhite(
                                                                      context))),
                                                  Text(StringHelper.compare,
                                                      style: AppTextStyle
                                                          .detailsMedium(
                                                              context,
                                                              AppColorStyle
                                                                  .textWhite(
                                                                      context))),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                                title: innerBoxIsScrolled
                                    ? Text(
                                        "${StringHelper.cricosText} ${snapshot.data?.courseCode ?? ""}",
                                        style: AppTextStyle.titleSemiBold(
                                            context,
                                            AppColorStyle.textWhite(context)))
                                    : const SizedBox(),
                                centerTitle: false,
                                flexibleSpace: flexibleTitleBar(
                                  context,
                                  title: snapshot.data?.courseName ?? "",
                                  isShowAlternateTitle: false,
                                  innerBoxIsScrolled: innerBoxIsScrolled,
                                )),
                          ];
                        },
                        body: Container(
                          color: AppColorStyle.background(context),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                //CourseDetails
                                const CourseDetailDataWidget(),
                                //Overview Data
                                const CourseOverviewWidget(),
                                Container(
                                    height: 10.0,
                                    color: AppColorStyle.backgroundVariant(
                                        context)),
                                //Course Discipline
                                const CourseDisciplineWidget(),
                                //Related Occupations
                                if (snapshot.data?.ugCode?.isNotEmpty ?? false)
                                  Container(
                                      height: 10.0,
                                      color: AppColorStyle.backgroundVariant(
                                          context)),
                                if (snapshot.data?.ugCode?.isNotEmpty ?? false)
                                  //Related Occupation Data
                                  CourseRelatedOccupationWidget(
                                    relatedOccupationsList:
                                        snapshot.data?.ugCode,
                                    selectedIndex: 0,
                                  ),
                                Container(
                                    height: 10.0,
                                    color: AppColorStyle.backgroundVariant(
                                        context)),
                                const SizedBox(height: 15.0),
                                //University Data
                                const CourseUniversityDataWidget(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 30, right: 20),
                              child: _showBackToTopButton
                                  ? InkWellWidget(
                                      onTap: () => {
                                        _scrollController.animateTo(0.0,
                                            curve: Curves.ease,
                                            duration: const Duration(
                                                milliseconds: 1200))
                                      },
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            top: 5,
                                            bottom: 5,
                                            right: 15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            color: AppColorStyle.text(context)
                                                .withOpacity(0.3),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    AppColorStyle.text(context)
                                                        .withOpacity(0.3),
                                              ),
                                            ]),
                                        child: Icon(
                                          Icons.arrow_upward,
                                          color:
                                              AppColorStyle.textWhite(context),
                                        ),
                                      ),
                                    )
                                  : null))
                    ],
                  ),
                );
              } else {
                return NetworkController.isInternetConnected
                    ? coursesBloc.courseDetailLoading == false
                        ? Container(
                            color: AppColorStyle.backgroundVariant(context),
                            child: const CourseDetailShimmer())
                        : Container(
                            height: double.infinity,
                            color: AppColorStyle.backgroundVariant(context),
                            child: Center(
                              child: NoDataFoundScreen(
                                noDataTitle: StringHelper.noDataFound,
                                noDataSubTitle:
                                    StringHelper.tryAgainWithDiffCriteria,
                              ),
                            ),
                          )
                    : Container(
                        color: AppColorStyle.backgroundVariant(context),
                        child: NoInternetScreen(
                          onRetry: () {
                            initData();
                          },
                        ),
                      );
              }
            }),
      ),
    );
  }

  double get maxHeight => 80 + MediaQuery.of(context).padding.top;

  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  Widget flexibleTitleBar(BuildContext context,
      {String? title, bool? isShowAlternateTitle, bool? innerBoxIsScrolled}) {
    double calculateExpandRatio(BoxConstraints constraints) {
      var expandRatio =
          (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
      if (expandRatio > 1.0) expandRatio = 1.0;
      if (expandRatio < 0.0) expandRatio = 0.0;
      return expandRatio;
    }

    String? alternateTitle, courseTitle;
    if (title!.isNotEmpty && title.contains("(")) {
      courseTitle = title.substring(0, title.indexOf("("));
      alternateTitle = title.substring(title.indexOf("("), title.length);
    } else {
      courseTitle = title;
      alternateTitle = "";
    }

    Widget buildTitle(Animation<double> animation) {
      return Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          innerBoxIsScrolled == true
              ? const SizedBox()
              : Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: SvgPicture.asset(
                    IconsSVG.headerBg,
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(
                left: Constants.commonPadding,
                right: Constants.commonPadding,
                top: 50),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  innerBoxIsScrolled == false
                      ? title.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  courseTitle != null && courseTitle.isNotEmpty
                                      ? courseTitle.toString()
                                      : title,
                                  style: AppTextStyle.subHeadlineSemiBold(
                                      context,
                                      AppColorStyle.textWhite(context)),
                                ),
                                alternateTitle != null &&
                                        alternateTitle.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: RichText(
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                            text: StringHelper.viewDetails,
                                            style: AppTextStyle.detailsRegular(
                                                context,
                                                AppColorStyle.primaryText(
                                                    context)),
                                            children: [
                                              WidgetSpan(
                                                child: SizedBox(
                                                  height: 20.0,
                                                  width: 25.0,
                                                  child: PopupMenuButton(
                                                      offset:
                                                          const Offset(-5, 35),
                                                      // shape:
                                                      //     const TooltipShape(),
                                                      icon: SvgPicture.asset(
                                                        IconsSVG.icInfo,
                                                        height: 16.0,
                                                        width: 16.0,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          AppColorStyle
                                                              .textWhite(
                                                                  context),
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      color: AppColorStyle
                                                          .background(context),
                                                      itemBuilder:
                                                          (BuildContext
                                                                  context) =>
                                                              [
                                                                PopupMenuItem(
                                                                    child: Text(
                                                                  alternateTitle
                                                                      .toString(),
                                                                  style: AppTextStyle.captionRegular(
                                                                      context,
                                                                      AppColorStyle
                                                                          .textDetail(
                                                                              context)),
                                                                )),
                                                              ]),
                                                ),
                                                alignment:
                                                    PlaceholderAlignment.top,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            )
                          : const OccupationDetailShimmer()
                      : const SizedBox(),
                  SizedBox(
                    height: alternateTitle != null && alternateTitle.isNotEmpty
                        ? 5
                        : 10,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            color: AppColorStyle.primaryVariant1(context),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0))),
                        child: Text(
                          "${StringHelper.cricosText} ${coursesBloc.courseDetailsDataObject.value.courseCode ?? ""}",
                          style: AppTextStyle.detailsMedium(
                              context, AppColorStyle.textWhite(context)),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      InkWellWidget(
                        onTap: () async {
                          //to clear data when click on any compare button from bottom sheet if selected.
                          coursesBloc.viewSelectedCourseToCompare.sink
                              .add(false);
                          CourseCompareBottomSheet.showCourseCompareBottomSheet(
                              context,
                              coursesBloc.courseDetailsDataObject.value,
                              coursesBloc);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              right: Constants.commonPadding,
                              top: 10,
                              bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColorStyle.textWhite(context)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            children: [
                              Text("+ ",
                                  style: AppTextStyle.subTitleSemiBold(context,
                                      AppColorStyle.textWhite(context))),
                              Text(StringHelper.compare,
                                  style: AppTextStyle.detailsMedium(context,
                                      AppColorStyle.textWhite(context))),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final expandRatio = calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);
        return buildTitle(animation);
      },
    );
  }

  @override
  onResume() {}

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }
}

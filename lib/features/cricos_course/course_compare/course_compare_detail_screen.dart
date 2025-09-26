import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/no_data_found_screen.dart';
import 'package:occusearch/common_widgets/no_internet_screen.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/cricos_course/course_compare/comapre_course_detail_shimmer.dart';
import 'package:occusearch/features/cricos_course/course_compare/widgets/course_compare_header_section_widget.dart';
import 'package:occusearch/features/cricos_course/course_compare/widgets/course_discipline_data_widget.dart';
import 'package:occusearch/features/cricos_course/course_compare/widgets/course_overview_data_widget.dart';
import 'package:occusearch/features/cricos_course/course_compare/widgets/course_compare_university_data_widget.dart';
import 'package:occusearch/features/cricos_course/course_detail/model/course_detail_model.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_bloc.dart';

class CourseCompareDetailScreen extends BaseApp {
  const CourseCompareDetailScreen({super.key, super.arguments})
      : super.builder();

  @override
  BaseState createState() => _CourseCompareDetailScreenState();
}

class _CourseCompareDetailScreenState extends BaseState {
  CoursesBloc coursesBloc = CoursesBloc();
  GlobalBloc? _globalBloc;
  int selectedCourseForApiCall =
      2; //1: primary data of compare, 2: second data of compare, primary it will set to 2 so it call of secondary data,

  late CourseDetailData firstCourseData;

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  init() async {
    initData();
  }

  Future<void> initData() async {
    dynamic args = widget.arguments;
    if (args["firstCourseData"] != null) {
      //previously defined Data
      firstCourseData = args["firstCourseData"];
      coursesBloc.selectedPrimaryCourseDetailObject.add(
          firstCourseData); //set data in this var so when it changes it reflects in whole page
    }

    //Call api for compare data
    if (args["compareCourseData"] != null) {
      await coursesBloc.getCoursesDetailData(
        args["compareCourseData"],
        selectedCourseForApiCall,
        isFromDetailPage: false,
      );
    }
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
        padding: const EdgeInsets.only(top: 40.0),
        child: StreamBuilder(
          stream: coursesBloc.selectedPrimaryCourseDetailObject.stream,
          builder: (_, primaryData) {
            return (primaryData.data != null && primaryData.hasData)
                ? StreamBuilder(
                    stream:
                        coursesBloc.selectedSecondaryCourseDetailObject.stream,
                    builder: (_, secondaryData) {
                      return (secondaryData.data != null &&
                              secondaryData.hasData &&
                              coursesBloc.courseDetailLoading == false)
                          ? SingleChildScrollView(
                              child: Container(
                                color: AppColorStyle.background(context),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      //header
                                      CourseCompareHeaderSectionWidget(
                                          selectedCourseForApiCall:
                                              selectedCourseForApiCall),

                                      //Overview Data
                                      const CourseOverviewDataWidget(),

                                      //Course Discipline
                                      const CourseDisciplineDataWidget(),

                                      //University data
                                      const CourseCompareUniversityDataWidget(),

                                      Container(
                                        height: 5.0,
                                        color: AppColorStyle.backgroundVariant(
                                            context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : NetworkController.isInternetConnected
                              ? coursesBloc.courseDetailLoading == true
                                  ? Container(
                                      color: AppColorStyle.backgroundVariant(
                                          context),
                                      child: const CompareCourseDetailShimmer())
                                  : Container(
                                      color: AppColorStyle.backgroundVariant(
                                          context),
                                      child: NoDataFoundScreen(
                                        noDataTitle: StringHelper.noDataFound,
                                        noDataSubTitle: StringHelper
                                            .tryAgainWithDiffCriteria,
                                      ),
                                    )
                              : Container(
                                  color:
                                      AppColorStyle.backgroundVariant(context),
                                  child: NoInternetScreen(
                                    onRetry: () {
                                      initData();
                                    },
                                  ),
                                );
                    },
                  )
                : Container();
          },
        ),
      ),
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

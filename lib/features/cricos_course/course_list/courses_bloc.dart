// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/api_service/CommonResponseModel.dart';
import 'package:occusearch/data_provider/api_service/api_constant.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_course_table.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/cricos_course/course_detail/model/add_course_data_model.dart';
import 'package:occusearch/features/cricos_course/course_detail/model/add_course_model.dart';
import 'package:occusearch/features/cricos_course/course_detail/model/course_detail_model.dart';
import 'package:occusearch/features/cricos_course/course_list/courses_repository.dart';
import 'package:occusearch/features/cricos_course/course_list/model/course_list_model.dart';
import 'package:occusearch/features/cricos_course/course_list/model/courses_filter_model.dart';
import 'package:occusearch/features/cricos_course/course_list/model/top_universities_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CoursesBloc extends RxBlocTypeBase {
  bool courseDetailLoader = false;

  // Loading status getter, setter
  final isLoadingCourse = BehaviorSubject<bool>.seeded(false);

  // To check user came first time to the screen or not
  final isFirstTime = BehaviorSubject<bool>.seeded(true);

  //to show/hide filter icon when type any text in search bar
  final isSearchFocus = BehaviorSubject<String>.seeded(
      ""); // false= filter icon, true = clear icon

  bool get courseDetailLoading => courseDetailLoader;

  set courseDetailLoading(bool courseDetailLoading) {
    courseDetailLoader = courseDetailLoading;
  }

  // view more description in course details
  final isViewMoreSubject = BehaviorSubject<bool>.seeded(false);

  //OCCUPATION ADD-REMOVE STREAM
  final courseAddRemoveLoaderStream = BehaviorSubject<bool>.seeded(false);

  //course add and remove loader
  set setCourseAddRemoveLoader(bool value) {
    courseAddRemoveLoaderStream.sink.add(value);
  }

  //Unit Group and General Detail API variable List for main course detail screen
  final courseDetailsDataObject = BehaviorSubject<CourseDetailData>();

  CourseDetailData get getCourseDetailsData =>
      courseDetailsDataObject.stream.value;

  set setCourseDetailsData(CourseDetailData courseDetailData) {
    courseDetailsDataObject.sink.add(courseDetailData);
  }

  //selected course for compare functionality(secondary)
  final selectedCourseObject = BehaviorSubject<CourseList>();

  CourseList get getSelectedCourseData => selectedCourseObject.stream.value;

  set setSelectedCourseObject(CourseList courseData) {
    viewSelectedCourseToCompare.sink.add(true);
    selectedCourseObject.sink.add(courseData);
  }

  //To stream data if primary course changed.
  final selectedPrimaryCourseDetailObject = BehaviorSubject<CourseDetailData>();

  //To stream data if secondary course changed.
  final selectedSecondaryCourseDetailObject =
      BehaviorSubject<CourseDetailData>();

  //For compare bottomsSheet visible selected course bloc, if false: search section will show, true :Selected course details will show in bottom sheet
  final viewSelectedCourseToCompare = BehaviorSubject<bool>.seeded(false);

  //SEARCH TEXT
  final TextEditingController searchTextController = TextEditingController();

  //for Compare delete functionality
  final viewSelectedForSearch = BehaviorSubject<bool>.seeded(false);

  //MY Course SEARCH STREAM
  final myCourseListFromSearchStream = BehaviorSubject<List<CourseList>>();

  //COURSE LIST
  final searchCoursesListStream = BehaviorSubject<List<CourseList>>();

  List<CourseList> get getSearchCoursesList =>
      searchCoursesListStream.stream.value;

  set setCoursesList(List<CourseList> list) {
    if (pageNo.value != 1) {
      searchCoursesListStream.value.addAll(list);
    } else {
      searchCoursesListStream.sink.add(list);
    }
  }

  //COURSE DASHBOARD RECENT SEARCH
  final courseRecentUpdateStream = BehaviorSubject<List<RecentCourseTable>>();

  set setCourseRecentList(List<RecentCourseTable> list) {
    courseRecentUpdateStream.sink.add(list);
  }

  //COURSE FILTER APPLIED OR NOT
  final isCourseFilterAppliedSubject = BehaviorSubject<bool>.seeded(false);

  bool get getIsCourseFilterApplied =>
      isCourseFilterAppliedSubject.stream.value;

  set setIsCourseAppliedFilter(bool value) {
    isCourseFilterAppliedSubject.sink.add(value);
  }

  Future<List<RecentCourseTable>> getCourseRecentList() async {
    List<RecentCourseTable> courseList = [];
    courseList = await RecentCourseTable.getAllList();
    courseList.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    setCourseRecentList = courseList;
    return courseList;
  }

  //[COURSE MODULE] WHEN WE REDIRECT TO PARTICULAR COURSE DETAIL PAGE STORE IN RECENT
  //STORE DATA IN RECENT-COURSE-TABLE//
  storeRecentCourseDetails(CourseDetailData courseData) async {
    //IF ID EXIST IN TABLE
    bool? isExist = await RecentCourseTable.checkOccupationExists(
        strCricos: courseData.courseCode.toString());
    var timestampValue = DateTime.now().millisecondsSinceEpoch;
    if (isExist == true) {
      //IF ID EXIST THEN UPDATE TIME STAMP
      await RecentCourseTable.updateRecentCourseTimeStamp(
          timestamp: timestampValue,
          strCricos: courseData.courseCode.toString());
    } else {
      //INSERT COURSE SELECTED DATA IN TABLE
      var recentCourseTable = RecentCourseTable(
          cricos: courseData.courseCode,
          ascedCode: courseData.ascedCode,
          courseName: courseData.courseName,
          courseDurationWeeks: courseData.durationWeeks,
          fullTimeFee: courseData.durationFullTimeFee.toString(),
          partTimeFee: courseData.durationPartTimeFee.toString(),
          courseLevel: courseData.courseLevel,
          skillLevel: int.parse(courseData.skillLevel!),
          timestamp: timestampValue);
      await RecentCourseTable.insert(recentCourseTable: recentCourseTable);
    }
  }

  /*
  *   // [GET] All Courses List
  *   Http API calling to get Courses list...
  * */

  //Page number for pagination
  final pageNo = BehaviorSubject<int>.seeded(1);

  var params =
      "broad_field=&narrow_field=&detailed_field=&state=&course_level=&";

  Future<List<CourseList>> getCoursesListBySearch(
      {String? reqParam,
      required String searchData,
      GlobalBloc? globalBloc}) async {
    try {
      isLoadingCourse.sink.add(true);
      setCoursesList = [];
      if (reqParam != null && reqParam.isNotEmpty) {
        //when come from filter add params from filter data
        pageNo.value = 1;
        searchCoursesListStream.value = [];
        params = reqParam;
      }

      String param = "${params}search=$searchData&pageno=${pageNo.value}";
      BaseResponseModel result = await CoursesRepository.getCoursesList(param);
      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        CourseListModel model = CourseListModel.fromJson(result.data);

        if (model.data != null && model.data!.courseList!.isNotEmpty) {
          //set last page to close shimmer and ro stop last api call!
          setLastPage(model.data!.pageDetail == null
              ? null
              : model.data!.pageDetail![0]);

          if (isFirstTime.value) {
            if (globalBloc != null && model.data!.pageDetail![0].pageNo == 1) {
              globalBloc.cache10CourseListRecords.sink
                  .add(model.data!.courseList!);
              pageNo.value = 2;
              return globalBloc.cache10CourseListRecords.value;
            } else {
              return model.data!.courseList ?? [];
            }
          } else {
            isFirstTime.sink.add(false);
            return model.data!.courseList ?? [];
          }
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  final searchStream = BehaviorSubject<String>.seeded("");

  Future<void> getCoursesList({String? reqParam}) async {
    try {
      setCoursesList = [];
      isLoadingCourse.sink.add(true);
      String searchData =
          searchStream.hasValue ? searchStream.valueOrNull ?? '' : "";

      if (reqParam != null && reqParam.isNotEmpty) {
        //when come from filter add params from filter data
        pageNo.value = 1;
        searchCoursesListStream.value = [];
        params = reqParam;
      }

      String param = "${params}search=$searchData&pageno=${pageNo.value}";
      BaseResponseModel result = await CoursesRepository.getCoursesList(param);
      if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          result.flag == true) {
        CourseListModel model = CourseListModel.fromJson(result.data);

        if (model.data != null && model.data!.courseList!.isNotEmpty) {
          setLastPage(model.data!.pageDetail![
              0]); //set last page to close shimmer and ro stop last api call!
          await setAddedFlagToAllCourseList(model.data!.courseList!);
        } else {
          setCoursesList = [];
        }
        isLoadingCourse.sink.add(false);
      } else {
        isLoadingCourse.sink.add(false);
        setCoursesList = [];
      }
    } catch (e) {
      isLoadingCourse.sink.add(false);
      setCoursesList = [];
      debugPrint(e.toString());
    }
  }

  final isLastPage = BehaviorSubject<bool>.seeded(false);

  setLastPage(PageDetail? pageDetail) {
    if (pageDetail != null && pageDetail.totalPage == pageDetail.pageNo) {
      isLastPage.add(true);
    } else {
      isLastPage.add(false);
    }
  }

  // Search
  onSearch(String query) {
    searchStream.add(query.trim());
  }

  clearSearch() {
    searchStream.value = "";
    searchTextController.text = "";
    isSearchFocus.value = "";
    onSearch("");
  }

  Future<void> setAddedFlagToAllCourseList(List<CourseList> courseList) async {
    List<MyBookmarkTable>? courseBookmarkList =
        await MyBookmarkTable.getBookmarkDataByType(
            bookmarkType: BookmarkType.COURSE.name);
    if (courseBookmarkList != null && courseBookmarkList.isNotEmpty) {
      for (CourseList courseRowData in courseList) {
        for (MyBookmarkTable myCourseData in courseBookmarkList) {
          if (myCourseData.code == courseRowData.courseCode) {
            courseRowData.isAdded = true;
          }
        }
      }
      setCoursesList = courseList;
    } else {
      setCoursesList = courseList;
    }
  }

  /*
  * [START]  We use below 3 variable to hold the course
  * detail in entire Course search module
  * */
  String? selectedCricosCode = "";
  String? selectedAscedCode = "";
  String? selectedCourseName = "";
  bool selectedCourseIsAdded = false;

  // [COURSE MODULE] We store Course Id & Name
  Future<void> setCourseSelection(
      {required String? cricosCode,
      required String? ascedCode,
      required String? courseName,
      required bool? isAdded}) async {
    selectedCricosCode = cricosCode;
    selectedAscedCode = ascedCode;
    selectedCourseName = courseName;
    selectedCourseIsAdded =
        await MyBookmarkTable.checkBookmarkExists(bookmarkID: cricosCode!) != 0;
  }

  //Course Detail API
  getCoursesDetailData(CourseList courseListData, int selectedCourseForApiCall,
      {required bool isFromDetailPage}) async {
    courseDetailLoading = true;
    BaseResponseModel result;
    result = await CoursesRepository.getCoursesDetailData(
        courseListData.courseCode!);

    if (result.statusCode == NetworkAPIConstant.statusCodeSuccess &&
        result.flag == true) {
      printLog(result.data);
      CourseDetailModel model = CourseDetailModel.fromJson(result.data);

      if (model.data != null) {
        if (isFromDetailPage) {
          courseDetailsDataObject.value = model.data!;
        } else {
          //for course compare primary and secondary data
          if (selectedCourseForApiCall == 1) {
            selectedPrimaryCourseDetailObject.add(model.data!);
          } else {
            selectedSecondaryCourseDetailObject.add(model.data!);
          }
        }

        courseDetailLoading = false;

        // set selected course detail
        await setCourseSelection(
            cricosCode: model.data!.courseCode,
            ascedCode: model.data!.ascedCode,
            isAdded: true,
            courseName: model.data!.courseName);

        //store recentCourseSearch details
        storeRecentCourseDetails(model.data!);
      } else {
        courseDetailLoading = false;
      }
      courseDetailLoading = false;
    }
  }

  //[FILTER API]
  final courseFilterStream = BehaviorSubject<List<FilterModelData>?>();

  //GET
  Stream<List<FilterModelData>?> get getCourseFilterStream =>
      courseFilterStream.stream;

  final selectedIndex = BehaviorSubject<int>.seeded(0);
  final selectedIndexValue = BehaviorSubject<bool>.seeded(false);

  // [GET] All Courses List By Filter
  Future<void> getCourseFilterData() async {
    try {
      BaseResponseModel response =
          await CoursesRepository.getCoursesListByFilter();

      if ((response.statusCode == NetworkAPIConstant.statusCodeSuccess ||
              response.statusCode == NetworkAPIConstant.statusCodeCaching) &&
          response.flag == true) {
        printLog("Course filter data: ${response.data.runtimeType}");
        CoursesFilterModel coursesFilterModel =
            CoursesFilterModel.fromJson(response.data);
        if (coursesFilterModel.data != null) {
          List<FilterModelData> filterList = [];

          if (coursesFilterModel.data?.state != null) {
            filterList.add(
              FilterModelData(
                  "State", "state", coursesFilterModel.data?.state, false, 0),
            );
          }
          if (coursesFilterModel.data?.state != null) {
            filterList.add(
              FilterModelData("Course Level", "course_level",
                  coursesFilterModel.data?.courseLevel, false, 0),
            );
          }
          if (coursesFilterModel.data?.broad != null) {
            filterList.add(
              FilterModelData("Broad", "broad_field",
                  coursesFilterModel.data?.broad, false, 0),
            );
          }
          if (coursesFilterModel.data?.narrow != null) {
            filterList.add(
              FilterModelData("Narrow", "narrow_field",
                  coursesFilterModel.data?.narrow, true, 2),
            );
          }
          if (coursesFilterModel.data?.detailed != null) {
            filterList.add(
              FilterModelData("Detailed", "detailed_field",
                  coursesFilterModel.data?.detailed, true, 3),
            );
          }

          courseFilterStream.sink.add(filterList);
        } else {
          courseFilterStream.sink.add([]);
        }
      } else {
        courseFilterStream.sink.add([]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // [ADD] Course API
  addCourse(BuildContext context, AddCourseData coursesObject,
      UserInfoData userInfo) async {
    try {
      setCourseAddRemoveLoader = true;
      List<AddCourseData> data = [];
      AddCourseJsonRequestModel requestJSON = AddCourseJsonRequestModel();
      requestJSON.leadid = userInfo.userId;
      requestJSON.companyid = userInfo.companyId;
      requestJSON.branchid = userInfo.branchId;
      data.add(coursesObject);
      requestJSON.courses = data;

      BaseResponseModel response =
          await CoursesRepository.addCourseData(jsonEncode(requestJSON));

      if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          response.flag == true) {
        CommonResponseModel model = CommonResponseModel.fromJson(response.data);
        if (model.flag == true) {
          Toast.show(
              message: StringHelper.coursesAddedMsg,
              context,
              type: Toast.toastSuccess,
              gravity: Toast.toastTop);

          //Insert newly added occupations to My Bookmark Table
          var courseListTable = MyBookmarkTable(
              name: coursesObject.courseName,
              code: coursesObject.cricos,
              subCode: coursesObject.ascedCode,
              subList: "",
              type: BookmarkType.COURSE.name,
              skillLevel: 0);

          await MyBookmarkTable.insert(myBookmarkTable: courseListTable);

          // set selected course detail
          await setCourseSelection(
              cricosCode: selectedCricosCode,
              ascedCode: selectedAscedCode,
              isAdded: true,
              courseName: selectedCourseName);
        } else {
          // when response of api is not proper!or api fail due to any reason
          setCourseAddRemoveLoader = false;
          Toast.show(
              message: StringHelper.someThingWentWrong,
              context,
              type: Toast.toastError,
              gravity: Toast.toastTop);
        }
        setCourseAddRemoveLoader = false;
      } else {
        setCourseAddRemoveLoader = false;
        Toast.show(
            message: StringHelper.someThingWentWrong,
            context,
            type: Toast.toastError,
            gravity: Toast.toastTop);
      }
    } catch (e) {
      debugPrint(e.toString());
      setCourseAddRemoveLoader = false;
    }
  }

  // [DELETE] Course API
  deleteCourse(
      {required BuildContext context,
      required AddCourseData coursesObject,
      required UserInfoData userInfoData}) async {
    String errorMsg = "";
    try {
      setCourseAddRemoveLoader = true;

      var params = {
        NetworkAPIConstant.reqResKeys.leadId: userInfoData.userId,
        NetworkAPIConstant.reqResKeys.companyId: userInfoData.companyId,
        NetworkAPIConstant.reqResKeys.branchId: userInfoData.branchId,
        NetworkAPIConstant.reqResKeys.cricosCode: coursesObject.cricos
      };

      BaseResponseModel response =
          await CoursesRepository.deleteCourseData(params);

      if (response.statusCode == NetworkAPIConstant.statusCodeSuccess &&
          response.flag == true) {
        CommonResponseModel model = CommonResponseModel.fromJson(response.data);
        if (model.flag == true) {
          //BaseResponseModel model = BaseResponseModel.completed(response.data);

          //Delete from My Bookmark Table
          MyBookmarkTable.deleteBookmarkById(bookmarkID: coursesObject.cricos!);

          // set selected course detail
          await setCourseSelection(
              cricosCode: selectedCricosCode,
              ascedCode: selectedAscedCode,
              isAdded: false,
              courseName: selectedCourseName);

          setCourseAddRemoveLoader = false;

          Toast.show(
              message: StringHelper.courseRemovedMsg,
              type: Toast.toastSuccess,
              context,
              gravity: Toast.toastTop);
        } else {
          // when response of api is not proper!or api fail due t any reason
          setCourseAddRemoveLoader = false;
          Toast.show(
              message: StringHelper.someThingWentWrong,
              type: Toast.toastError,
              context,
              gravity: Toast.toastTop);
        }
      } else {
        if (response.statusCode == NetworkAPIConstant.statusCodeNoInternet) {
          errorMsg = StringHelper.internetConnection;
        } else {
          errorMsg = StringHelper.occupationFailToDelete;
        }
        Toast.show(context,
            message: errorMsg, type: Toast.toastError, gravity: Toast.toastTop);

        setCourseAddRemoveLoader = false;
      }
    } catch (e) {
      printLog(e);
      setCourseAddRemoveLoader = false;
    }
  }

  // [GET] Top Universities List
  final topUniversitiesLoader = BehaviorSubject<bool>.seeded(false);
  final topUniversitiesListStream = BehaviorSubject<List<TopInstitute>?>();

  Stream<List<TopInstitute>?> get getTopUniversitiesListStream =>
      topUniversitiesListStream.stream;

  Future<void> getTopUniversitiesInAustraliaList() async {
    try {
      topUniversitiesLoader.sink.add(true);
      BaseResponseModel response =
          await CoursesRepository.getTopUniversitiesData();
      if ((response.statusCode == NetworkAPIConstant.statusCodeSuccess ||
              response.statusCode == NetworkAPIConstant.statusCodeCaching) &&
          response.flag == true) {
        TopUniversitiesModel topUniversitiesModel =
            TopUniversitiesModel.fromJson(response.data);

        if (topUniversitiesModel.data != null) {
          topUniversitiesListStream.sink
              .add(topUniversitiesModel.data!.topInstitute ?? []);
        } else {
          topUniversitiesListStream.sink.add([]);
        }
        topUniversitiesLoader.sink.add(false);
      } else {
        topUniversitiesLoader.sink.add(false);
        topUniversitiesListStream.sink.add([]);
      }
    } catch (e) {
      topUniversitiesLoader.sink.add(false);
      topUniversitiesListStream.sink.add([]);
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    selectedIndex.close();
    courseFilterStream.close();
    searchStream.close();
  }
}

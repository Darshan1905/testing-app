// ignore_for_file: depend_on_referenced_packages

import 'package:occusearch/constants/enum.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class MyBookmarkBloc extends RxBlocTypeBase {
  //ALL BOOKMARK LIST
  final courseBookmarkTypeCount = BehaviorSubject<int>.seeded(0);
  final occupationBookmarkTypeCount = BehaviorSubject<int>.seeded(0);
  List<MyBookmarkTable> allBookmarkList = [];
  var noDataFoundType = " Data ";

  final bookmarkByTypeListStream = BehaviorSubject<List<MyBookmarkTable>>();

  Stream<List<MyBookmarkTable>> get getBookmarkListStream =>
      bookmarkByTypeListStream.stream;

  //category type
  final bookmarkTypeStream =
      BehaviorSubject<BookmarkType>.seeded(BookmarkType.ALL);

  //Set
  set setBookmarkType(BookmarkType searchCategoryType) {
    bookmarkTypeStream.value = searchCategoryType;
  }

  //Get All Bookmark List
  getAllBookmarkList({required String type}) async {
    List<MyBookmarkTable>? courseBookmarkList =
        await MyBookmarkTable.getAllBookmarkList();
    allBookmarkList.clear();
    allBookmarkList.addAll(courseBookmarkList);

    //get list length of Course Type
    List<MyBookmarkTable>? myCourseBookmarkList = allBookmarkList
        .where((element) => element.type == BookmarkType.COURSE.name)
        .toList();

    //get list length of Course Type
    List<MyBookmarkTable>? occuBookmarkList = allBookmarkList
        .where((element) => element.type == BookmarkType.OCCUPATION.name)
        .toList();
    courseBookmarkTypeCount.sink.add(myCourseBookmarkList.length);
    occupationBookmarkTypeCount.sink.add(occuBookmarkList.length);

    setBookmarkListByType(bookmarkType: type);
  }

  //Get Bookmark List by Type
  setBookmarkListByType({String? bookmarkType}) async {
    if (bookmarkType != null &&
        bookmarkType != "" &&
        allBookmarkList.isNotEmpty &&
        bookmarkType != BookmarkType.values[0].name) {
      List<MyBookmarkTable>? allAddedBookmarkList = allBookmarkList
          .where((element) => element.type == bookmarkType)
          .toList();
      noDataFoundType = bookmarkType.toLowerCase();
      bookmarkByTypeListStream.sink.add(allAddedBookmarkList);
    } else {
      bookmarkByTypeListStream.sink.add(allBookmarkList);
    }
  }

  @override
  void dispose() {
    bookmarkByTypeListStream.close();
    allBookmarkList.clear();
  }
}

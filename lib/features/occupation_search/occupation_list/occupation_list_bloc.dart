// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/all_bookmark_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_occupation_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/occupation_search/occupation_list/model/all_occupation_list_model.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class OccupationListBloc extends RxBlocTypeBase {
  bool loader = false;
  bool loaderForDeleteOccu = false;
  String errorMsg = "";
  int currentPos = 0; // PageView Index

  //SearchCategoryType variables
  final categoryTypeStream =
      BehaviorSubject<SearchCategoryType>.seeded(SearchCategoryType.OCCUPATION);

  set setCategoryType(SearchCategoryType searchCategoryType) {
    categoryTypeStream.value = searchCategoryType;
  }

  Stream<SearchCategoryType> get getCategoryTypeStream =>
      categoryTypeStream.stream;

  /* Loading status getter, setter*/
  final isLoadingSubject = BehaviorSubject<bool>.seeded(true);

  // GET
  Stream<bool> get loadingStream => isLoadingSubject.stream;

  set setOccuDeleteLoader(bool loading) {
    loaderForDeleteOccu = loading;
  }

  //SEARCH TEXT
  final searchTextStream = BehaviorSubject<String>();

  String get getSearchText => searchTextStream.stream.value;
  TextEditingController searchTextController = TextEditingController();

  set setSearchText(String text) {
    searchTextStream.sink.add(text);
  }

  clearSearch() {
    searchTextController.text = "";
    searchFilter = "";
  }

  //OCCUPATION LIST
  final occupationListStream = BehaviorSubject<List<OccupationRowData>>();
  final searchOccupationListStream = BehaviorSubject<List<OccupationRowData>>();

  // Occupation hit search list
  final occupationHintSearchList = BehaviorSubject<List<String>?>();

  List<OccupationRowData> get getSearchOccupationList =>
      searchOccupationListStream.stream.value;

  set occupationsList(List<OccupationRowData> list) {
    occupationListStream.sink.add(list);
    searchOccupationListStream.sink.add(list);
  }

  //MY OCCUPATION SEARCH STREAM
  final myOccupationListFromSearchStream =
      BehaviorSubject<List<OccupationRowData>>();

  set searchFilter(String search) {
    searchOccupationListStream.sink.add([]);
    List<OccupationRowData> temp = [];

    if (_isNumeric(search.trim())) {
      for (var row in occupationListStream.stream.value) {
        if ((row.mainId ?? '').contains(search.trim())) {
          // [START] here I check if already occupation add then ignore
          if (!(temp.isNotEmpty
              ? temp.any((tempRow) => tempRow.id == row.id)
              : false)) temp.add(row);
          // [END]
        }
      }
    } else if (!_isNumeric(search)) {
      for (var row in occupationListStream.stream.value) {
        if (("${row.mainId} ${row.name}")
            .toLowerCase()
            .contains(search.toLowerCase().trim())) {
          // [START] here I check if already occupation add then ignore
          if (!(temp.isNotEmpty
              ? temp.any((tempRow) =>
                  tempRow.name!.toLowerCase() == row.name!.toLowerCase())
              : false)) temp.add(row);
          // [END]
        }
      }
    }
    searchOccupationListStream.sink.add(temp);
    List<OccupationRowData> mySearchList = searchOccupationListStream
        .stream.value
        .where((element) => element.isAdded == true)
        .toList();
    myOccupationListFromSearchStream.sink.add(mySearchList);
  }

  //MY OCCUPATION LIST STREAM
  final myOccupationListStream = BehaviorSubject<List<OccupationRowData>>();

  List<OccupationRowData> get getMyOccupationList =>
      myOccupationListStream.stream.value;

  //OCCUPATION DASHBOARD RECENT UPDATE
  final occupationRecentUpdateStream =
      BehaviorSubject<List<RecentOccupationTable>>();
  final mostVisitedOccupationListStream =
      BehaviorSubject<List<RecentOccupationTable>>();

  final occupationDashboardSearchStream = BehaviorSubject<String>.seeded("");

  final coursesDashboardSearchStream = BehaviorSubject<String>.seeded("");

  set setOccupationsRecentList(List<RecentOccupationTable> list) {
    occupationRecentUpdateStream.sink.add(list);
  }

  set setMostVisitedOccupationList(List<RecentOccupationTable> list) {
    mostVisitedOccupationListStream.sink.add(list);
  }

  Future<List<RecentOccupationTable>> getOccupationsRecentList() async {
    List<RecentOccupationTable> occupationsList = [];
    occupationsList = await RecentOccupationTable.getAllList();
    occupationsList.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    setOccupationsRecentList = occupationsList;

    //MOST VISITED DATA STORE
    List<RecentOccupationTable> mostVisitedList = [];
    mostVisitedList.addAll(occupationsList);
    mostVisitedList.sort((a, b) => b.mostVisited!.compareTo(a.mostVisited!));
    setMostVisitedOccupationList = mostVisitedList;
    return occupationsList;
  }

  bool _isNumeric(String result) {
    // ignore: unnecessary_null_comparison
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  /*
  *   // [GET] All Occupation List
  *   Http API calling to get occupations list...
  * */
  Future<int> getOccupationsList() async {
    try {
      isLoadingSubject.sink.add(true);
      errorMsg = "";
      setSearchText = "";
      occupationsList = [];
      occupationHintSearchList.sink.add([]);
      if (await shouldFetchOccupationFromRemote()) {
        if (await NetworkController.isConnected() == false) {
          isLoadingSubject.sink.add(false);
          occupationsList = [];
          return 0;
        }

        // GET Occupation List from Firebase RealTime database
        DatabaseReference databaseReference = FirebaseDatabase.instance
            .ref(FirebaseRealtimeDatabaseConstants.occupationVisitListString);
        await databaseReference.once().then((event) async {
          if (event.snapshot.exists) {
            final data = jsonEncode(event.snapshot.value);
            List<OccupationRowData> fbOccupationList =
                (jsonDecode(data) as List)
                    .map<OccupationRowData>(
                        (json) => OccupationRowData.fromJson(json))
                    .toList();
            fbOccupationList =
                await setAddedFlagToAllOccupationList(fbOccupationList);
            occupationsList = fbOccupationList;
            //searchFilter = "";
            OccupationListRepository.insertAllOccupationInDb(data);
            isLoadingSubject.sink.add(false);

            occupationHintSearchList.sink
                .add(fbOccupationList.map((e) => e.name ?? '').toList());
          } else {
            errorMsg = "Failed to get occupations.";
            isLoadingSubject.sink.add(false);
            occupationsList = [];
            occupationHintSearchList.sink.add([]);
          }
        });
      } else {
        isLoadingSubject.sink.add(true);
        var occupationData =
            await OccupationListRepository.getAllOccupationFromDb() ?? [];
        occupationsList = occupationData;
        isLoadingSubject.sink.add(false);
        occupationHintSearchList.sink
            .add(occupationData.map((e) => e.name ?? '').toList());
        //searchFilter = "";
      }
    } catch (e) {
      isLoadingSubject.sink.add(false);
      errorMsg = e.toString();
      occupationsList = [];
      occupationHintSearchList.sink.add([]);
      debugPrint(e.toString());
    } finally {
      if (await getOccupationsByUser()) {
        isLoadingSubject.sink.add(false);
      }
    }
    return (occupationListStream.valueOrNull ?? []).length;
  }

  static Future<List<OccupationRowData>> setAddedFlagToAllOccupationList(
      List<OccupationRowData> occupationList) async {
    List<MyBookmarkTable>? myOccuList =
        await MyBookmarkTable.getBookmarkDataByType(
            bookmarkType: BookmarkType.OCCUPATION.name);

    if (myOccuList != null && myOccuList.isNotEmpty) {
      for (OccupationRowData occupationRowData in occupationList) {
        for (MyBookmarkTable myOccuData in myOccuList) {
          if (myOccuData.code.toString() == occupationRowData.id) {
            occupationRowData.isAdded = true;
          }
        }
      }
    }
    return occupationList;
  }

  // [GET] My Occupation List
  Future<bool> getOccupationsByUser() async {
    return false;
  }

  Future<bool> shouldFetchOccupationFromRemote() async {
    /*check today's date with the date in database for occupation list sync.
    If date is mismatched, occupation list will be fetched from API and response will be saved(updated) in local database.
    If date is same, then occupation list will be fetched from db. (getAllOccupationFromDb()).*/

    ConfigTable? configTable =
        await ConfigTable.read(strField: ConfigFields.configFieldOccupationSyncDate);
    String strLastSyncDate = configTable?.fieldValue ?? '';
    if (strLastSyncDate != "") {
      return strLastSyncDate != Utility.getTodayDate();
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    occupationRecentUpdateStream.close();
  }
}

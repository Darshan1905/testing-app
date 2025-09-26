// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/firebase/realtime_database/firebase_realtime_database_constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/config_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_constants.dart';
import 'package:occusearch/features/discover_dream/unit_group/model/unit_group_model.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class UnitGroupBloc extends RxBlocTypeBase {
  //OCCUPATION UNIT GROUP LOADER STREAM
  final unitGroupLoaderSubject = BehaviorSubject<bool>.seeded(false);

  // Expanded page viewer position index
  final pageViewPositionIndex = BehaviorSubject<int>.seeded(0);

  int get getPageViewPositionIndex => pageViewPositionIndex.stream.value;

  set setPagePosition(int index) {
    pageViewPositionIndex.sink.add(index);
  }

  // TRUE = Table view, FALSE = Chart view
  //no of workers
  final viewWorkersChartMode = BehaviorSubject<bool>.seeded(false);

  bool get getViewWorkersChartMode => viewWorkersChartMode.stream.value;

  setViewWorkersChartMode() {
    viewWorkersChartMode.sink.add(!getViewWorkersChartMode);
    setPagePosition = 0;
  }

  //weekly earnings
  final earningPagePositionIndex = BehaviorSubject<int>.seeded(0);

  set setEarningPagePosition(int index) {
    earningPagePositionIndex.sink.add(index);
  }

  final viewEarningsMode = BehaviorSubject<bool>.seeded(false);

  bool get getViewEarningsChartMode => viewEarningsMode.stream.value;

  setViewEarningsChartMode() {
    viewEarningsMode.sink.add(!getViewEarningsChartMode);
    setEarningPagePosition = 0;
  }

  //age Profile
  final agePagePositionIndex = BehaviorSubject<int>.seeded(0);

  set setAgePagePosition(int index) {
    agePagePositionIndex.sink.add(index);
  }

  final viewAgeMode = BehaviorSubject<bool>.seeded(false);

  bool get getViewAgeChartMode => viewAgeMode.stream.value;

  setViewAgeChartMode() {
    viewAgeMode.sink.add(!getViewAgeChartMode);
    setAgePagePosition = 0;
  }

  //highest qualification
  //age Profile
  final educationPositionIndex = BehaviorSubject<int>.seeded(0);

  set setEducationPagePosition(int index) {
    educationPositionIndex.sink.add(index);
  }

  final viewEducationMode = BehaviorSubject<bool>.seeded(false);

  bool get getViewEducationChartMode => viewEducationMode.stream.value;

  setViewEducationChartMode() {
    viewEducationMode.sink.add(!getViewEducationChartMode);
    setEducationPagePosition = 0;
  }

  //////////////////SEARCH TEXT////////////////////////////////////
  TextEditingController searchTextController = TextEditingController();

  //Unit Group API variable List
  final occupationUnitGroupSubject =
      BehaviorSubject<List<UnitGroupListData>?>();

  // Set
  set setSearchFieldController(controller) => searchTextController = controller;

  // Get
  Stream<List<UnitGroupListData>?> get getUnitListOccupationStream =>
      occupationUnitGroupSubject.transform(streamTransformer);

  BehaviorSubject<List<UnitGroupListData>?> get getUnitGroupList =>
      occupationUnitGroupSubject;

  // Search
  onSearch(query) {
    getUnitGroupList.add(getUnitGroupList.value);
  }

  clearSearch() {
    searchTextController.text = "";
    onSearch("");
  }

  StreamTransformer<List<UnitGroupListData>?, List<UnitGroupListData>?>
      get streamTransformer => StreamTransformer<List<UnitGroupListData>?,
              List<UnitGroupListData>?>.fromHandlers(
            handleData: (list, sink) {
              if ((searchTextController.text).isNotEmpty) {
                List<UnitGroupListData>? newList = list?.where(
                  (item) {
                    return item.name!.toLowerCase().contains(
                            searchTextController.text.toLowerCase()) ||
                        item.ugCode!
                            .toLowerCase()
                            .contains(searchTextController.text.toLowerCase());
                  },
                ).toList();
                return sink.add(newList);
              } else {
                return sink.add(list);
              }
            },
          );

  List<UnitGroupListData>? get getOccupationUnitGroupData =>
      occupationUnitGroupSubject.stream.value;

  // Http [GET]  API calling to get occupation unit_group group data...
  Future<void> getOccupationUnitGroupList() async {
    try {
      if (await shouldFetchUnitGroupFromRemote()) {
        if (await NetworkController.isConnected() == false) {
          unitGroupLoaderSubject.sink.add(false);
          occupationUnitGroupSubject.sink.add([]);
          return;
        }
        // GET Unit group List from Firebase RealTime database
        DatabaseReference databaseReference = FirebaseDatabase.instance
            .ref(FirebaseRealtimeDatabaseConstants.unitGroupListString);

        await databaseReference.once().then((event) async {
          if (event.snapshot.exists) {
            final data = jsonEncode(event.snapshot.value);
            List<UnitGroupListData> fbOccupationUnitGroupList =
                (jsonDecode(data) as List)
                    .map<UnitGroupListData>(
                        (json) => UnitGroupListData.fromJson(json))
                    .toList();
            occupationUnitGroupSubject.sink.add(fbOccupationUnitGroupList);
            //insert/update unit_group group data in local database
            UnitGroupRepository.insertAllUnitGroupInDb(data);
            unitGroupLoaderSubject.sink.add(false);
          } else {
            unitGroupLoaderSubject.sink.add(false);
            occupationUnitGroupSubject.sink.add([]);
          }
        });
      } else {
        //get data from local DB
        unitGroupLoaderSubject.sink.add(true);
        var occupationData =
            await UnitGroupRepository.getAllUnitGroupFromDb() ?? [];
        occupationUnitGroupSubject.sink.add(occupationData);
        unitGroupLoaderSubject.sink.add(false);
      }
    } catch (e) {
      unitGroupLoaderSubject.sink.add(false);
      occupationUnitGroupSubject.sink.add([]);
      debugPrint(e.toString());
    }
  }

  Future<bool> shouldFetchUnitGroupFromRemote() async {
    /*check today's date with the date in database for unit_group group list sync.
    If date is mismatched, unit_group group list will be fetched from API and response will be saved(updated) in local database.
    If date is same, then unit_group group list will be fetched from db. (getAllOccupationFromDb()).*/

    ConfigTable? configTable =
        await ConfigTable.read(strField: ConfigFields.unitGroupSyncDate);
    String strLastSyncDate = configTable?.fieldValue ?? '';
    if (strLastSyncDate != "") {
      return strLastSyncDate != Utility.getTodayDate();
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    occupationUnitGroupSubject.close();
    searchTextController.text = "";
    searchTextController.clear();
  }
}

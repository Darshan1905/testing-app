// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/features/dashboard/recent_updates/model/recent_update_model.dart';
import 'package:occusearch/features/dashboard/recent_updates/recent_update_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

@RxBloc()
class RecentUpdatesBloc extends RxBlocTypeBase {
  bool loader = false;

  final recentUpdateList = BehaviorSubject<List<Recordset>>();

  Stream<List<Recordset>> get getRecentUpdateList => recentUpdateList.stream;

  set setRecentUpdateList(List<Recordset> recordList) {
    recentUpdateList.sink.add(recordList);
  }

  // USE WHEN USER TAP ON SHARE ICON
  final sharePostLoader = BehaviorSubject<bool>.seeded(false);

  //Page number for pagination
  final pageNo = BehaviorSubject<int>.seeded(1);

  set setPageNo(index) => pageNo.sink.add(index);

  Stream<int> get getPageNo => pageNo.stream;

  Recordset? recentPostData;

  set setRecentUpdatePost(Recordset? postData) {
    recentPostData = postData;
  }

  /*
  *     Loading status getter, setter
  * */
  bool get loading => loader;

  set loading(bool loading) {
    loader = loading;
  }

  Future<bool> getRecentUpdateDataList(
      BuildContext context, bool byRecentID, String recentID) async {
    final completer = Completer<bool>();
    try {
      loading = true;
      String param =
          "page_no=${pageNo.value}&from_date=&to_date=&pagesize=20&recent_id=0";
      setRecentUpdatePost = null;
      if (byRecentID) {
        // byRecentID = get recent update post by id[dynamic link sharing]
        param = "page_no=0&from_date=&to_date=&pagesize=1&recent_id=$recentID";
      }

      BaseResponseModel result =
          await RecentUpdateRepository.getRecentUpdatesDio(param);
      if (result.statusCode == Constants.statusCodeForApiData &&
          result.flag == true) {
        //debugPrint(result.body);
        LatestUpdateModel model = LatestUpdateModel.fromJson(result.data);
        if (model.flag == true &&
            model.data != null &&
            model.data!.recentChanges != null) {
          if (byRecentID && model.data!.recentChanges!.isNotEmpty) {
            setRecentUpdatePost = model.data!.recentChanges![0];
          } else {
            if (recentUpdateList.hasValue) {
              recentUpdateList.value.addAll(model.data!.recentChanges!);
            } else {
              setRecentUpdateList = model.data!.recentChanges!;
            }
          }
          completer.complete(true);
        } else {
          setRecentUpdateList = [];
        }
        loading = false;
      } else {
        setRecentUpdateList = [];
        loading = false;
        completer.complete(false);
      }
    } catch (e) {
      loading = false;
      completer.complete(false);
    }
    return completer.future;
  }

  @override
  void dispose() {}
}

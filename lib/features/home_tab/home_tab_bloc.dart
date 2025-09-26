// ignore_for_file: depend_on_referenced_packages

import 'package:rxdart/rxdart.dart';
import 'package:rx_bloc/rx_bloc.dart';

@RxBloc()
class HomeBloc extends RxBlocTypeBase {

  final currentIndexSubject = BehaviorSubject<int>();

  Stream<int> get currentIndexStream => currentIndexSubject.stream;

  final isInternet = BehaviorSubject<bool>.seeded(true);

  void setTabBarIndex(int index) {
    currentIndexSubject.sink.add(index);
  }

  @override
  void dispose() {
    currentIndexSubject.close();
  }
}
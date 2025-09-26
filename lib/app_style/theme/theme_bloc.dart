// ignore_for_file: depend_on_referenced_packages

import 'package:occusearch/app_style/theme/constant/theme_constant.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_bloc/rx_bloc.dart';

class ThemeBloc extends RxBlocTypeBase {
  final themeController = BehaviorSubject.seeded(true);

  ThemeBloc() {
    Future.delayed(Duration.zero, () async {
      bool val = await ThemeConstant.getTheme();
      setTheme(val);
    });
  }

  Stream<bool> get themeStream => themeController.stream;

  bool get currentTheme => themeController.value;

  void setTheme(bool theme) async {
    ThemeConstant.setTheme(theme);
    themeController.sink.add(theme);
  }

  @override
  dispose() {
    //themeController.close();
  }
}

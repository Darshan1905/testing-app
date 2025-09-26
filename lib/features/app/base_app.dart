// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:occusearch/app_style/theme/theme_bloc.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/sqflite_database/entity/recent_occupation_table.dart';
import 'package:occusearch/data_provider/sqflite_database/sqflite_database_controller.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';

abstract class BaseApp extends StatefulWidget {
  final dynamic arguments;
  final screeMode;
  final title;

  const BaseApp.builder(
      {super.key, this.title, this.arguments, this.screeMode});

  @override
  BaseState createState();
}

abstract class BaseState extends State<BaseApp>
    with RouteAware, WidgetsBindingObserver {
  ThemeBloc? themeBloc;

  GlobalBloc? globalBloc;
  FirebaseAnalyticLog analyticLog = FirebaseAnalyticLog();

  Widget body(BuildContext context);

  @override
  void initState() {
    super.initState();
    initializeData();
    init();
  }

  initializeData() async {
    RxBlocProvider.of<GlobalBloc>(context).context = context;
    globalBloc ??= RxBlocProvider.of<GlobalBloc>(context);
    themeBloc ??= RxBlocProvider.of<ThemeBloc>(context);
    await SqfLiteController.initDatabase();
    //CHECK COLUMN EXIST skillLevel OR NOT IN RECENT OCCUPATION TABLE
    await RecentOccupationTable.columnExistInTable();
    if (globalBloc != null && globalBloc!.userInfoStream.valueOrNull != null) {
      UserInfoData userInfoData = globalBloc!.userInfoStream.value;
      analyticLog.setUserInformation(
        fullName: userInfoData.name ?? "",
        mobileNumber: userInfoData.phone ?? "",
        emailAddress: userInfoData.email ?? "",
        userID: "${userInfoData.userId}",
        firebaseUserID: "",
        // TODO pass Firebase store database user id
        firebaseToken: "", // TODO pass Firebase store database user token
      );
    }
  }

  init();

  onResume();

  @override
  Widget build(BuildContext context) {
    themeBloc = RxBlocProvider.of<ThemeBloc>(context);
    return _app();
  }

  Widget _app() {
    return FocusDetector(
      child: Scaffold(body: body(context)),
      onFocusGained: () {
        onResume();
      },
    );
  }
}

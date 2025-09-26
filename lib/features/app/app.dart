import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:occusearch/app_style/theme/model/theme_config.dart';
import 'package:occusearch/app_style/theme/theme_bloc.dart';
import 'package:occusearch/data_provider/api_service/dio_cache_controller.dart';
import 'package:occusearch/data_provider/api_service/network_controller.dart';
import 'package:occusearch/navigation/go_router.dart';
import 'global_bloc.dart';

/// To initialize firebase class object
class AppDefaultConfigInitialization {
  AppDefaultConfigInitialization() {
    // initialize all the firebase related function or classes
    NetworkController.initialiseNetworkManager();
    // Document Directory Path declaration for Dio cache data
    documentDirectoryPathInitialization();
  }

  documentDirectoryPathInitialization() async {
    await AppPathProvider.initPath();
  }
}

/// App class
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ThemeBloc theme = ThemeBloc();

  @override
  void initState() {
    super.initState();
    // Initialize Firebase and others classes
    AppDefaultConfigInitialization();

    theme.themeController.listen((bool key) {
      if (key) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          // navigation bar color
          systemNavigationBarColor: Color(0xFF161616),
          systemNavigationBarIconBrightness: Brightness.light,
        ));
      } else {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          // navigation bar color
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RxMultiBlocProvider(
      providers: [
        RxBlocProvider<GlobalBloc>(
          create: (context) => GlobalBloc(),
        ),
        RxBlocProvider<ThemeBloc>(
          create: (context) => theme,
        ),
      ],
      child: StreamBuilder<bool>(
        stream: theme.themeStream,
        initialData: true,
        builder: (_, snapshot) {
          return ScreenUtilInit(
              designSize: const Size(430, 930),
              minTextAdapt: true,
              splitScreenMode: false,
              builder: (context , child) {
                return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: ThemeConfig.instance.buildThemeData(snapshot.data ?? false),
                routeInformationProvider:
                    GoRouterConfig.router.routeInformationProvider,
                routeInformationParser:
                    GoRouterConfig.router.routeInformationParser,
                routerDelegate: GoRouterConfig.router.routerDelegate,
              );
            }
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    theme.themeController.close();
    super.dispose();
  }
}

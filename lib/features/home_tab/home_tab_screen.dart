import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/common_widgets/no_internet_screen.dart';
import 'package:occusearch/common_widgets/toast_widget.dart';
import 'package:occusearch/common_widgets/will_pop_scope_widget.dart';
import 'package:occusearch/constants/constants.dart';
import 'package:occusearch/data_provider/shared_preference/shared_preference_controller.dart';
import 'package:occusearch/features/ai_webview/ai_webview_page.dart';
import 'package:occusearch/features/authentication/model/user_profile_model.dart';
import 'package:occusearch/features/dashboard/dashboard_screen.dart';
import 'package:occusearch/features/discover_dream/discover_dream_screen.dart';
import 'package:occusearch/features/home_tab/widget/home_tab_widget.dart';
import 'package:occusearch/features/more_menu/more_menu_screen.dart';
import 'package:occusearch/features/subscription/subscription_plan.dart';

import 'home_tab_bloc.dart';

class HomeScreen extends BaseApp {
  const HomeScreen({super.key}) : super.builder();

  @override
  BaseState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends BaseState {
  final HomeBloc _homeBloc = HomeBloc();

  List<Widget> bottomBarPages = <Widget>[];

  DateTime preBackPress = DateTime.now();
  AppType appType = AppType.FREE_TRIAL;

  @override
  init() {
    getAppType().then((value) {
      appType = value;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isNetworkConnected = await NetworkController.isConnected();
      if (!isNetworkConnected) {
        _homeBloc.isInternet.sink.add(false);
      }
      bottomBarPages = <Widget>[
        DashboardScreen(changeTab: changeTabMethod),
        const DiscoverDreamScreen(),
        appType == AppType.PAID
            ? const AIWebViewPage()
            : const SubscriptionPlan(arguments: false),
        const MoreMenuScreen()
      ];
      _homeBloc.setTabBarIndex(0);
    });
  }

  Future<AppType> getAppType() async {
    UserInfoData userInfoData = await SharedPreferenceController.getUserData();
    AppType appType = AppType.FREE_TRIAL;
    if (userInfoData.subName != null && userInfoData.subName!.isNotEmpty) {
      if (userInfoData.subRemainingDays != null && userInfoData.subRemainingDays! <= 0) {
        appType = AppType.EXPIRED;
      } else {
        switch (userInfoData.subName) {
          case StringHelper.freePlan:
          case StringHelper.miniPlan:
            appType = AppType.FREE_TRIAL;
            break;
          case StringHelper.premiumPlan:
            appType = AppType.PAID;
            break;
          default:
            appType = AppType.FREE_TRIAL;
            break;
        }
      }
    }
    return appType;
  }

  @override
  onResume() {}

  void changeTabMethod(int index) {
    _homeBloc.setTabBarIndex(1);
  }

  @override
  Widget body(BuildContext context) {
    return RxBlocProvider<HomeBloc>(
      create: (BuildContext context) => _homeBloc,
      child: WillPopScopeWidget(
        onWillPop: () async {
          if (_homeBloc.currentIndexSubject.value == 0) {
            final timeGap = DateTime.now().difference(preBackPress);
            final cantExit = timeGap >= const Duration(seconds: 2);
            preBackPress = DateTime.now();
            if (cantExit) {
              Toast.show(
                  message: StringHelper.pressBackAgain,
                  context,
                  gravity: Toast.toastTop);
              return false;
            } else {
              return true; // true will exit the app
            }
          } else if (_homeBloc.currentIndexSubject.value == 1 ||
              _homeBloc.currentIndexSubject.value == 2 ||
              _homeBloc.currentIndexSubject.value == 3) {
            _homeBloc.setTabBarIndex(0);
            return false;
          } else {
            return true;
          }
        },
        child: Container(
          color: AppColorStyle.background(context),
          child: SafeArea(
            top: false,
            bottom: false,
            child: StreamBuilder<bool>(
              stream: _homeBloc.isInternet.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data == false) {
                  return NoInternetScreen(onRetry: () async {
                    bool isNetworkConnected =
                        await NetworkController.isConnected();
                    if (isNetworkConnected) {
                      _homeBloc.isInternet.sink.add(true);
                    }
                  });
                } else {
                  return Scaffold(
                    backgroundColor: AppColorStyle.background(context),
                    body: StreamBuilder<int>(
                        stream: _homeBloc.currentIndexStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          return bottomBarPages.elementAt(snapshot.data ?? 0);
                        }),
                    bottomNavigationBar: BottomNavigationBarWidget(
                        theme: themeBloc?.currentTheme ?? false,
                        appType: appType),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

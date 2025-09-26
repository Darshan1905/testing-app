
import 'package:flutter/material.dart';
import 'package:occusearch/data_provider/firebase/event_log/firebase_analytic_event.dart';
import 'package:occusearch/data_provider/firebase/event_log/firebase_event_constants.dart';
import 'go_router.dart';

class NavigationObserver extends NavigatorObserver with WidgetsBindingObserver {
  /// Navigation route global key [navigationKey] hold the route state
  /// provide information about route

  NavigationObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Every time user came to new screen we assign
  /// current time to [navigationObserverStartTime] variable
  DateTime? navigationObserverStartTime;

  /// Hold the currently visible screen name
  String navigationObserverVisibleScreenName = "";

  /// [didChangeAppLifecycleState] method use to get application lifecycle
  /// background & foreground event
  /// so, we can log screen spent time in firebase analytics.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// The application is visible and responding to user input.
    if (state == AppLifecycleState.resumed) {
      // String currentPath = GoRouterConfig.router.location;
      /*navigationKey?.currentState?.popUntil((route) {
        currentPath = route.settings.name;
        return true;
      });*/
      navigationObserverStartTime = DateTime.now();
      //debugPrint("resumed() $currentPath time ${_START_TIME}");
    }

    /// [AppLifecycleState.resumed] method called when
    /// the application is not currently visible to the user,
    /// not responding to user input, and running in the background.
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      // var usageTime = DateTime.now().difference(_START_TIME ?? DateTime.now());
      String currentPath = GoRouterConfig.router.location;
      /*navigationKey?.currentState?.popUntil((route) {
        currentPath = route.settings.name;
        return true;
      });*/

      /// Log the Firebase Event before application going into background
      navigationObserverVisibleScreenName = currentPath;
      var usageTime =
      DateTime.now().difference(navigationObserverStartTime ?? DateTime.now());
      // writing firebase analytics event log...
      FirebaseAnalyticLog.shared.screenTimeTracking(
          screenName: navigationObserverVisibleScreenName,
          spentTime: usageTime.toString(),
          navigationAction: FBActionEvent.fbActionPause);
      navigationObserverStartTime = DateTime.now();
      //debugPrint("paused() $currentPath time ${DateTime.now()} :: $usageTime");
    }
  }

  void _sendScreenView(String status, PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    debugPrint('$status :: $screenName');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(FBActionEvent.fbActionPop, previousRoute);

      /// Log the Firebase Event for spent time on screen
      if (route.settings.name != null) {
        navigationObserverVisibleScreenName = route.settings.name!;
        var usageTime =
        DateTime.now().difference(navigationObserverStartTime ?? DateTime.now());
        // writing firebase analytics event log...
        FirebaseAnalyticLog.shared.screenTimeTracking(
            visibleScreenName: route.settings.name,
            screenName:
            // ignore: unnecessary_null_comparison
            previousRoute != null ? previousRoute.settings.name : "",
            previousScreenName: navigationObserverVisibleScreenName,
            spentTime: usageTime.toString(),
            navigationAction: FBActionEvent.fbActionPop);
      }
      // Hold route name when pop() method called
      if (route.settings.name != null) {
        navigationObserverStartTime = DateTime.now();
        navigationObserverVisibleScreenName = previousRoute.settings.name!;
      }
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    /// CALLED WHEN USER NAVIGATE TO SCREEN
    /// here we initialize the starting time with current time
    if (route is PageRoute) {
      _sendScreenView("PUSH", route);

      /// Log the Firebase Event for spent time on screen
      var usageTime = DateTime.now().difference(navigationObserverStartTime ?? DateTime.now());
      // writing firebase analytics event log...
      FirebaseAnalyticLog.shared.screenTimeTracking(
          visibleScreenName: route.settings.name,
          screenName: previousRoute != null ? previousRoute.settings.name : "",
          previousScreenName: navigationObserverVisibleScreenName,
          spentTime: usageTime.toString(),
          navigationAction: FBActionEvent.fbActionPause);

      // Hold route name when pop() navigation called
      if (previousRoute != null) {
        navigationObserverVisibleScreenName = previousRoute.settings.name ?? "";
        navigationObserverStartTime = DateTime.now();
      }
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView("REPLACE", newRoute);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView("REMOVE", route);
    }
  }

  /// Remove the [Observer] when application state dispose
  void dispose() {
    navigationObserverVisibleScreenName = "";
    WidgetsBinding.instance.removeObserver(this);
  }
}

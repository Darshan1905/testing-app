import 'package:go_router/go_router.dart';
import 'package:occusearch/constants/constants.dart';

enum NavigatorMode { push, replace, remove, pop }

class GoRoutesPage {
  // Navigate to method
  static go(
      {required NavigatorMode mode, required String moveTo, var param}) async {
    BuildContext? context =
        GoRouterConfig.router.routerDelegate.navigatorKey.currentContext;
    try {
      switch (mode) {
        case NavigatorMode.push:
          context?.push(RouteName.root + moveTo, extra: param);
          break;
        case NavigatorMode.replace:
          context?.pushReplacement(RouteName.root + moveTo, extra: param);
          break;
        case NavigatorMode.remove:
          context?.go(RouteName.root);
          context?.pushReplacement(RouteName.root + moveTo, extra: param);
          break;
        case NavigatorMode.pop:
          context?.pop(param);
          break;
      }
    } catch (e) {
      printLog(e);
    }
  }
}

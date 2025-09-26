import 'package:occusearch/constants/constants.dart';

import 'custom_progress_dialog.dart';

class LoadingWidget {
  static show() {
    BuildContext? context =
        GoRouterConfig.router.routerDelegate.navigatorKey.currentContext;
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (_) {
        return const Center(child: CustomProgressDialog());
      },
    );
  }

  static hide() {
    try {
      BuildContext? context =
          GoRouterConfig.router.routerDelegate.navigatorKey.currentContext;
      Navigator.pop(context!);
    } catch (e) {
      printLog(e.toString());
    }
  }
}

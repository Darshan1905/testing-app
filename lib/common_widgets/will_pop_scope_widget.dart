import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class WillPopScopeWidget extends StatelessWidget {
  const WillPopScopeWidget(
      {required this.child, Key? key, required this.onWillPop})
      : super(key: key);

  final Widget child;
  final WillPopCallback onWillPop;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? GestureDetector(
            // onPanEnd: (details) {
            //   if (details.velocity.pixelsPerSecond.dx > 0) {
            //     printLog("details.velocity.pixelsPerSecond.dx ${details.velocity.pixelsPerSecond.dx}");
            //     onWillPop();
            //   }
            // },
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: child,
            ))
        : WillPopScope(
            onWillPop: onWillPop,
            child: child);
  }
}

import 'package:flutter/material.dart';
import 'package:occusearch/data_provider/firebase/event_log/firebase_analytic_event.dart';
import 'package:occusearch/navigation/go_router.dart';

class InkWellWidget extends StatelessWidget {
  final Widget child;
  final Function onTap;

  // Firebase event log variable
  final String? logActionEvent;
  final String? logSectionName;
  final String? logSubSectionName;
  final String? logMessage;
  final String? logOther;

  const InkWellWidget(
      {super.key,
      required this.child,
      required this.onTap,
      this.logActionEvent,
      this.logSectionName,
      this.logSubSectionName,
      this.logMessage,
      this.logOther});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: child,
      onTap: () {
        // Firebase event log
        if (logActionEvent != null) {
          FirebaseAnalyticLog.shared.eventTracking(
              screenName: GoRouterConfig.router.location,
              actionEvent: logActionEvent ?? "",
              sectionName: logSectionName,
              subSectionName: logSubSectionName,
              message: logMessage,
              other: logOther);
        }
        // onClick function
        onTap();
      },
    );
  }
}

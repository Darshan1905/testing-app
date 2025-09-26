import 'package:flutter/cupertino.dart';

class WidgetNone extends StatelessWidget {
  final String? message;

  const WidgetNone({super.key, this.message = ""});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

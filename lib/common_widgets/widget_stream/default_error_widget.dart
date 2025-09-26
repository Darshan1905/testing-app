import 'package:flutter/material.dart';

class WidgetError extends StatelessWidget {
  final Object? errorMessage;

  const WidgetError(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(errorMessage == null ? "Error" : errorMessage.toString());
  }
}

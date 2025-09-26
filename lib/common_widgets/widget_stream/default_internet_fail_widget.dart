import 'package:flutter/material.dart';

class WidgetInternetLost extends StatelessWidget {
  final String? message;

  const WidgetInternetLost({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
        color: Colors.redAccent,
        child: Text(
          message ?? "Connection lost",
          style: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}

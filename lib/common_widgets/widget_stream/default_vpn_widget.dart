import 'package:flutter/material.dart';

class WidgetVPNConnected extends StatelessWidget {
  final String? message;

  const WidgetVPNConnected({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
        color: Colors.deepOrange,
        child: Text(
          message ?? "APN Connected",
          style: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'features/app/app.dart';
import 'data_provider/firebase/firebase_configuration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfiguration.configure();
  FacebookAppEvents().setAutoLogAppEventsEnabled(true);
  FacebookAppEvents().setAdvertiserTracking(enabled: true);
  runApp(const App());
}

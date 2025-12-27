import 'package:flutter/material.dart';
import 'services/api_client.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiClient.preloadToken();
  runApp(const App());
}

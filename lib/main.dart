import 'package:flutter/material.dart';
import 'prc/auth/stub.dart';

import 'prc/main_screen.dart';
if (dart.library.io) 'prc/auth/android_auth_provider.dart' 
if (dart.library.html) 'prc/auth/web_auth_provider.dart'; 




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthProvider().initialize();

  runApp(MyApp());
}

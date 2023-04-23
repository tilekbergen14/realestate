import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/root.dart';
import 'theme/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Estate App',
      theme: ThemeData(
        primaryColor: primary,
      ),
      home: RootApp(),
    );
  }
}

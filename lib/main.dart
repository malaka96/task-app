import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_firebase_project/pages/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Firebase App',
      theme: ThemeData.dark(),
      home: HomePage()
    );
  }
}

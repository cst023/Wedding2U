import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wedding2u_app/presentation/screens/general/landing_page.dart';
import 'package:wedding2u_app/routes/app_routes.dart'; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LandingPage(),
      routes: appRoutes,
    );
  }
}
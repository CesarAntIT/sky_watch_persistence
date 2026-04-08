import 'package:flutter/material.dart';
import 'package:sky_watch/pages/add_observation.dart';
import 'package:sky_watch/pages/add_profile.dart';
import 'package:sky_watch/pages/home_page.dart';
import 'package:sky_watch/pages/profile_page.dart';
import 'package:sky_watch/services/objectbox.dart';

late Objectbox objectbox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await Objectbox.create();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        appBarTheme: AppBarTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          backgroundColor: const Color.fromARGB(255, 2, 10, 52),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontWeight: FontWeight(700), fontSize: 20),
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        appBarTheme: AppBarTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          backgroundColor: Colors.blue[500],
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontWeight: FontWeight(700), fontSize: 20),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/profile': (context) => ProfilePage(),
        '/observation': (context) => AddObservation(),
        '/edit-profile': (context) => AddProfile(),
      },
    );
  }
}

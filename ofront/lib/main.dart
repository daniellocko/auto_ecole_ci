import 'package:epik/screens/home_screen.dart';
import 'package:epik/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.prefs});
  final SharedPreferences prefs;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "PORTAIL DES AUTO ECOLE DE CÔTE D'IVOIRE",
        theme: ThemeData.light().copyWith(
          highlightColor: const Color.fromARGB(255, 1, 14, 27),
          focusColor: const Color.fromARGB(255, 14, 133, 238),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            brightness: Brightness.light,
            surface: Colors.white,
          ),
          scaffoldBackgroundColor:
              Colors.white, // Color.fromARGB(255, 10, 10, 11),
        ),
        home: Padding(
          padding: const EdgeInsets.only(top: 1),
          child: prefs.getString('User') == null
              ? const LoginScreen()
              : const HomeScreen(),
        ));
  }
}

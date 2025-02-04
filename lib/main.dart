import 'package:flutter/material.dart';
import 'package:pet_paradise_app/register_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'themes.dart';
import 'cart_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData themeData = lightTheme; // Set initial theme to light

  void toggleTheme() {
    setState(() {
      themeData = themeData.brightness == Brightness.light ? darkTheme : lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Paradise',
      theme: themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(toggleTheme: toggleTheme),
        '/home': (context) => HomePage(toggleTheme: toggleTheme),
        '/register': (context) => RegisterPage(),  // Add the RegisterPage route here
        '/cart': (context) => CartPage(),
      },
    );
  }
}

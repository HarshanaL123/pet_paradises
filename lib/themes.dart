import 'package:flutter/material.dart';

// Define light theme
final ThemeData lightTheme = ThemeData(
  primaryColor: Color(0xFF8B5E3C), // Main color for the app
  primarySwatch: createMaterialColor(Color(0xFF8B5E3C)), // Use the color for swatch
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF8B5E3C), // AppBar color
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF8B5E3C),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);

// Define dark theme
final ThemeData darkTheme = ThemeData(
  primaryColor: Color(0xFF8B5E3C),
  primarySwatch: createMaterialColor(Color(0xFF8B5E3C)),
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF6E432B), // Darker shade for dark theme
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6E432B), // Darker FAB for dark mode
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);

// Utility function to generate a swatch from a single color
MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

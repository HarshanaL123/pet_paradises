import 'package:flutter/material.dart';
import 'package:pet_paradise_app/register_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'themes.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import 'contactus_page.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Stripe
    Stripe.publishableKey = 'pk_test_51QjmbvECUcZ8Sbh5xbPcYrmWqmfBx8JFYOTjtNhydf9PZXsOEXiVrxJKLz7N1fkjWQp5M5RafyFW1GkoYDu4uEEJ005HyUqx90';
    await Stripe.instance.applySettings();
  } catch (e) {
    print('Error initializing Stripe: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData themeData = lightTheme;

  void toggleTheme() {
    setState(() {
      themeData = themeData.brightness == Brightness.light ? darkTheme : lightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      title: 'Pet Paradise',
      theme: themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(toggleTheme: toggleTheme),
        '/home': (context) => HomePage(toggleTheme: toggleTheme),
        '/register': (context) => RegisterPage(),
        '/cart': (context) => CartPage(),
        '/profile': (context) => ProfilePage(),
        '/contactus': (context) => ContactUsPage(),
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pet_paradise_app/register_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'themes.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import 'contactus_page.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'services/light_sensor_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
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
  final LightSensorService _lightSensor = LightSensorService();
  bool _isAutoDarkMode = true;  // Keep this

  @override
  void initState() {
    super.initState();
    _initLightSensor();
  }

  void _initLightSensor() {
    _lightSensor.onLightChanged = (luxValue) {
      if (_isAutoDarkMode) {  // This check is necessary
        final shouldBeDark = luxValue < 5.0;
        setState(() {
          themeData = shouldBeDark ? darkTheme : lightTheme;
        });
      }
    };
    _lightSensor.init();
  }

  void toggleTheme() {
    setState(() {
      _isAutoDarkMode = false;  // Disable auto mode on manual toggle
      themeData = themeData.brightness == Brightness.light ? darkTheme : lightTheme;
    });
  }

  // Pass isAutoDarkMode to required widgets
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Paradise',
      theme: themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(
              toggleTheme: toggleTheme,
              isAutoDarkMode: _isAutoDarkMode,
            ),
        '/home': (context) => HomePage(
              toggleTheme: toggleTheme,
              isAutoDarkMode: _isAutoDarkMode,
            ),
        '/register': (context) => RegisterPage(),
        '/cart': (context) => CartPage(),
        '/profile': (context) => ProfilePage(),
        '/contactus': (context) => ContactUsPage(),
      },
    );
  }
}
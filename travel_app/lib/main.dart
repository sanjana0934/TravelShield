import 'package:flutter/material.dart';
import 'screens/login/login_page.dart';
import 'screens/home/main_navigation.dart';
import 'screens/home/tools/currency_page.dart';
import 'screens/home/tools/qr_scanner_page.dart';
import 'screens/home/tools/translator_page.dart';
import 'screens/home/tools/clothing_page.dart';
import 'screens/home/tools/price_checker_page.dart';
import 'screens/settings/settings_page.dart';
import 'screens/about/about_page.dart';
import 'screens/trip_planner/trip_planner_screen.dart';
import 'screens/sos/sos_page.dart';

void main() {
  runApp(const KeralaApp());
}

class KeralaApp extends StatelessWidget {
  const KeralaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginPage(),
        "/home": (context) => const MainNavigation(),
        "/currency": (context) => const CurrencyPage(),
        "/qr": (context) => const QRScannerPage(),
        "/translator": (context) => const TranslatorPage(),
        "/clothing": (context) => const ClothingPage(),
        "/settings": (context) => const SettingsPage(),
        "/about": (context) => const AboutPage(),
        "/trip": (context) => const TripPlannerScreen(),
        "/sos": (context) => const SOSPage(),
        "/price": (context) => const PriceCheckerPage(),
      },
    );
  }
}
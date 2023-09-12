import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mbansw/configs/config.dart';
import 'package:mbansw/screens/ContactUsScreen.dart';
import 'package:mbansw/screens/ReferalScreen.dart';
import 'package:mbansw/screens/StatisticsScreen.dart';
import 'package:mbansw/screens/SubscriptionScreen.dart';

import 'http/AuthService.dart';
import 'screens/DonateUsScreen.dart';
import 'screens/DonationsScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/MainScreen.dart';
import 'screens/RegisterScreen.dart';
import 'screens/ThankyouScreen.dart';
import 'screens/WhatWeDo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NUSr5KEj4yLoEM33QyNzgAKSs3UflMYJVAhmQJKhjAW38pBbK83rTfLeiTtcnW5OLNU6KK5BUaE9jNuzTw5DJqO00PEKiHNux";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // DevicePreview(
        //   enabled: !kReleaseMode,
        //   builder: (context) => // Wrap your app
        MaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Config.primaryTheme,
      ),
      initialRoute: '/home',
      routes: {
        "/login": (context) =>
            AuthService.token == '' ? const LoginScreen() : const MainScreen(),
        "/register": (context) => AuthService.token == ''
            ? const RegisterScreen()
            : const RegisterScreen(),
        "/home": (context) => const MainScreen(),
        "/whatwedo": (context) => const WhatWeDo(),
        "/referal": (context) => const ReferalScreen(),
        "/contactus": (context) => const ContactUsScreen(),
        "/donateus": (context) => AuthService.token == ''
            ? const LoginScreen()
            : const DonateUsScreen(),
        "/statistics": (context) => AuthService.token == ''
            ? const LoginScreen()
            : const StatisticsScreen(),
        "/thankyou": (context) => AuthService.token == ''
            ? const LoginScreen()
            : const ThankyouScreen(),
        "/subscription": (context) => AuthService.token == ''
            ? const LoginScreen()
            : const SubscriptionScreen(),
        "/donations": (context) => AuthService.token == ''
            ? const LoginScreen()
            : const DonationsScreen(),
      },
      title: "MBANSW",
    );
    // );
  }
}
  // device_preview: ^1.1.0
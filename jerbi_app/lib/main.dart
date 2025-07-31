import 'package:flutter/material.dart';
import 'dart:io';
import 'features/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Get platform-specific font family
  String get _fontFamily {
    if (Platform.isIOS) {
      return 'SFPro';
    } else if (Platform.isAndroid) {
      return 'GoogleSans';
    } else {
      return 'GoogleSans'; // Default for web/desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jerbi Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: _fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF061138),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

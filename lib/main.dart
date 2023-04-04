import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/providers/auth_provider.dart';
import 'package:silverspy/views/landing_page.dart';

import 'views/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const SilverspyApp(),
    ),
  );
}

class SilverspyApp extends StatelessWidget {
  const SilverspyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silverspy',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // home: const HomePage(), // No login
      home: const LandingPage(),
    );
  }
}

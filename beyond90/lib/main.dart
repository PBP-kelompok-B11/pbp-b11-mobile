import 'package:flutter/material.dart';

// FIXED: Lokasi yang benar!
import 'package:beyond90/landing_page/screeen/landing_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:beyond90/search/screen/search_default_page.dart';
import 'package:beyond90/category/category_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Beyond90',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF261893),
        ),
      ),

      // ROUTES untuk navbar
      routes: {
        '/home': (context) => const MyHomePage(),
        '/category': (context) => const CategoryPage(),
      },

      home: const MyHomePage(),
    );
  }
}

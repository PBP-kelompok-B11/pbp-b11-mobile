import 'package:beyond90/authentication/screens/register.dart';
import 'package:beyond90/media_gallery/screens/medialist_form.dart';
import 'package:beyond90/event/screens/eventlist_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:beyond90/authentication/screens/login.dart';
import 'landing_page/screeen/landing_page.dart';
import 'search/screen/search_default_page.dart';
import 'category/screens/category_page.dart';


void main() {
  runApp(
    Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: const MyApp(),
    ),
  );
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
      routes: { // Named Route
        '/home': (context) => const MyHomePage(),
        '/search': (context) => const SearchDefaultPage(),
        '/category': (context) => const CategoryPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/media_gallery': (context) => const MediaFormPage(),
        '/event/create': (context) => const EventFormPage(),
      },

      home: const MyHomePage(),
    );
  }
}
import 'package:beyond90/authentication/screens/login.dart';
import 'package:beyond90/clubs/screens/club_list_admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'landing_page/screeen/landing_page.dart';
import 'search/screen/search_default_page.dart';
import 'category/category_page.dart';
// import 'package:beyond90/landing_page/screeen/landing_page.dart';

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
      routes: {
        '/home': (context) => const MyHomePage(),
        '/search': (context) => const SearchDefaultPage(),
        '/category': (context) => const CategoryPage(),
      },
      home: const ClubListAdmin(),
    );
  }
}


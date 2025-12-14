import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/landing_page/widgets/main_title.dart';
import 'package:beyond90/landing_page/widgets/tagline_section.dart';
import 'package:beyond90/landing_page/widgets/stat_section.dart';
import 'package:beyond90/landing_page/widgets/tagline_section_2.dart';
import 'package:beyond90/landing_page/widgets/gallery_button.dart';
import 'package:beyond90/landing_page/widgets/login_button.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/media_gallery/screens/medialist_form.dart';
import 'package:beyond90/search/screen/search_default_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Stack(
          children: [
            // ==== SCROLLABLE MAIN CONTENT ====
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      const MainTitle(),
                      const SizedBox(height: 32),
                      const TaglineSection(),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const StatsSection(),
                          const SizedBox(width: 24),
                          Container(
                            width: 4,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.lime,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 24),
                          const TaglineSection2(),
                        ],
                      ),
                      const SizedBox(height: 48),
                      const GalleryButton(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),

            // ===== LOGIN / LOGOUT BUTTON =====
            const Positioned(
              top: 16,
              right: 16,
              child: LoginButton(),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavbar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 0) return;

          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              Navigator.pushNamed(context, '/category');
              break;
            case 3:
              Navigator.pushNamed(context, '/media_gallery'
              );
              break;
          }
        },
      ),
    );
  }
}

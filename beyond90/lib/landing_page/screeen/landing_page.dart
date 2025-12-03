import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

import 'package:beyond90/landing_page/widgets/main_title.dart';
import 'package:beyond90/landing_page/widgets/tagline_section.dart';
import 'package:beyond90/landing_page/widgets/stat_section.dart';
import 'package:beyond90/landing_page/widgets/tagline_section_2.dart';
import 'package:beyond90/landing_page/widgets/gallery_button.dart';
import 'package:beyond90/landing_page/widgets/login_button.dart';

import 'package:beyond90/widgets/bottom_navbar.dart';

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

            // ==== LOGIN BUTTON FLOATING ====
            Positioned(
              top: 16,
              right: 20,
              child: LoginButton(
                onPressed: () {
                  // TODO: Navigate ke Login Page
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavbar(
        selectedIndex: 0,
        onTap: (index) {
          // TODO: navigate nanti
        },
      ),
    );
  }
}

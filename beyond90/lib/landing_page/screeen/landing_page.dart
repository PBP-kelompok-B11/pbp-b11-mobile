import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/landing_page/widgets/main_title.dart';
import 'package:beyond90/landing_page/widgets/tagline_section.dart';
import 'package:beyond90/landing_page/widgets/stat_section.dart';
import 'package:beyond90/landing_page/widgets/tagline_section_2.dart';
import 'package:beyond90/landing_page/widgets/gallery_button.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                // BEYOND + 90
                const MainTitle(),
                const SizedBox(height: 32),

                // Tagline atas
                const TaglineSection(),
                const SizedBox(height: 48),

                // Stats + Divider + Tagline Section 2
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

                // Button Gallery
                const GalleryButton(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavbar(
  selectedIndex: 0,
  onTap: (index) {
    // TODO: nanti buat navigate ke halaman lain
  },
),
    );
  }
}

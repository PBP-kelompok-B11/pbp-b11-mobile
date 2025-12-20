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
  final bool isAdmin; 

  const MyHomePage({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              // Menambahkan BouncingScrollPhysics agar scroll terasa halus di mobile
              physics: const BouncingScrollPhysics(),
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

                      // ==== BAGIAN RESPONSIVE STATS & TAGLINE ====
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Jika lebar layar kurang dari 350, ubah Row jadi Column
                          if (constraints.maxWidth < 350) {
                            return Column(
                              children: [
                                const StatsSection(),
                                const SizedBox(height: 16),
                                Container(
                                  width: 80, // Ubah dari vertikal ke horizontal
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.lime,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const TaglineSection2(),
                              ],
                            );
                          } else {
                            // Tampilan Normal untuk layar yang cukup lebar
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Flexible(child: StatsSection()),
                                const SizedBox(width: 20),
                                Container(
                                  width: 4,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.lime,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Flexible(child: TaglineSection2()),
                              ],
                            );
                          }
                        },
                      ),
                      
                      const SizedBox(height: 48),
                      const GalleryButton(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),

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
            case 1: Navigator.pushNamed(context, '/search'); break;
            case 2: Navigator.pushNamed(context, '/category'); break;
            case 3: Navigator.pushNamed(context, '/media_gallery'); break;
          }
        },
      ),
    );
  }
}
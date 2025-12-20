import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:beyond90/category/widgets/category_title.dart';
import 'package:beyond90/category/widgets/category_card.dart';
import 'package:beyond90/event/screens/event_entry_list.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';

import 'package:beyond90/player/screens/player_entry_list.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ===== PAGE TITLE =====
              const CategoryTitle(),

              const SizedBox(height: 24),

              // ===== PLAYER CATEGORY =====
              CategoryCard(
                title: 'Player',
                subtitle: 'See various players from all over the world!',
                actionText: 'See all players',
                onTap: () {
                  // Navigator.pushReplacementNamed(context, '/players');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerEntryListPage(filter: "All"),
                    ),
                  );
                },
              ),

              // ===== CLUB CATEGORY =====
              CategoryCard(
                title: 'Club',
                subtitle: 'Meet the greatest clubs around the world!',
                actionText: 'See all clubs',
                onTap: () {
                  if (AuthService.isAdmin) {
                    Navigator.pushReplacementNamed(context, '/clubs/admin');
                  } else {
                    Navigator.pushReplacementNamed(context, '/clubs');
                  }
                },
              ),

              // ===== EVENT CATEGORY =====
              CategoryCard(
                title: 'Event',
                subtitle: "Witness the battle of the world's greatest",
                actionText: 'See all events',
                onTap: () {
                  Navigator.push(
                    context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const EventEntryListPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

      // ===== BOTTOM NAVBAR =====
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 2, // CATEGORY
        onTap: (index) {
          if (index == 2) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/search');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/media_gallery');
              break;
          }
        },
      ),
    );
  }
}

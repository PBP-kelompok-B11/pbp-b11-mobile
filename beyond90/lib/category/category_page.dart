import 'package:flutter/material.dart';
import '../category/widgets/category_card.dart';
import '../../clubs/screens/club_list_custom.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF1E1B4B);
    final lime = const Color(0xFFBEF264);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Categories",
          style: TextStyle(
            fontFamily: "Geologica",
            color: lime,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // PLAYER
            CategoryCard(
              title: "Player",
              description: "See various players from all over the world!",
              buttonText: "See all players",
              highlightColor: lime,
              mainColor: bg,
              onTap: () {},
            ),

            // CLUB
            CategoryCard(
              title: "Club",
              description: "Meet the greatest clubs around the world!",
              buttonText: "See all clubs",
              highlightColor: lime,
              mainColor: bg,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClubListCustom()),
                );
              },
            ),

            // EVENT
            CategoryCard(
              title: "Event",
              description: "Witness the battle of the world's greatest",
              buttonText: "See all events",
              highlightColor: lime,
              mainColor: bg,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

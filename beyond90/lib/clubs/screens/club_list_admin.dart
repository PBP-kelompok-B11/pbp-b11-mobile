import 'package:flutter/material.dart';
import '../service/club_service.dart';
import '../models/club.dart';
import 'club_detail_admin.dart';
import 'club_form.dart';

class ClubListAdmin extends StatefulWidget {
  const ClubListAdmin({super.key});

  @override
  State<ClubListAdmin> createState() => _ClubListAdminState();
}

class _ClubListAdminState extends State<ClubListAdmin> {
  final bool isAdmin = true; // testing admin

  late Future<List<Club>> _futureClubs;

  Color get indigo => const Color(0xFF1E1B4B);
  Color get lime => const Color(0xFFBEF264);

  @override
  void initState() {
    super.initState();
    _futureClubs = ClubService.fetchClubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: indigo,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Club",
                style: TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: lime,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // SEARCH + ADD CLUB
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(54),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),

                  const SizedBox(width: 12),

                  if (isAdmin)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ClubForm(),
                          ),
                        );
                      },
                      child: Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: lime,
                          borderRadius: BorderRadius.circular(54),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Add Club",
                          style: TextStyle(
                            fontFamily: "Geologica",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: indigo,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<Club>>(
                future: _futureClubs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final clubs = snapshot.data ?? [];

                  if (clubs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No clubs available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: clubs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final club = clubs[index];
                        return _buildClubCard(club);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CARD HELPER =================

  Widget _buildClubCard(Club club) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClubDetailAdmin(clubId: club.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(35)),
                color: Colors.grey.shade300,
                image: club.urlGambar != null
                    ? DecorationImage(
                        image: NetworkImage(club.urlGambar!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 12),

            // NAME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                club.nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Geologica",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: indigo,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // LOCATION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Text("📍", style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      club.negara,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Geologica",
                        fontSize: 18,
                        color: indigo,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // DETAILS BUTTON
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: lime,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Details",
                    style: TextStyle(
                      fontFamily: "Geologica",
                      fontSize: 20,
                      color: indigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

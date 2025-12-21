import 'package:beyond90/clubs/service/club_ranking_service.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import '../models/club.dart';
import '../service/club_service.dart';

class ClubForm extends StatefulWidget {
  final Club? club;
  final int? ranking;
  final int? rankingId;

  const ClubForm({
    super.key,
    this.club,
    this.ranking,
    this.rankingId,
  });

  @override
  State<ClubForm> createState() => _ClubFormState();
}

class _ClubFormState extends State<ClubForm> {
  late TextEditingController nameCtrl;
  late TextEditingController countryCtrl;
  late TextEditingController stadiumCtrl;
  late TextEditingController yearCtrl;
  late TextEditingController imageCtrl;
  late TextEditingController rankingCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.club?.nama ?? "");
    countryCtrl = TextEditingController(text: widget.club?.negara ?? "");
    stadiumCtrl = TextEditingController(text: widget.club?.stadion ?? "");
    yearCtrl =
        TextEditingController(text: widget.club?.tahunBerdiri?.toString() ?? "");
    imageCtrl = TextEditingController(text: widget.club?.urlGambar ?? "");
    rankingCtrl =
        TextEditingController(text: widget.ranking?.toString() ?? "");
  }

  Future<void> saveClub() async {
    final isEdit = widget.club != null;

    final clubData = {
      "nama": nameCtrl.text,
      "negara": countryCtrl.text,
      "stadion": stadiumCtrl.text,
      "tahun_berdiri": int.parse(yearCtrl.text),
      "url_gambar": imageCtrl.text,
    };

    try {
      if (!isEdit) {
        final clubId = await ClubService.createClub(clubData);

        if (rankingCtrl.text.isNotEmpty) {
          await ClubRankingService.createRanking(
            clubId: clubId,
            ranking: int.parse(rankingCtrl.text),
          );
        }
      } else {
        await ClubService.updateClub(widget.club!.id, clubData);

        if (widget.rankingId != null && rankingCtrl.text.isNotEmpty) {
          await ClubService.updateRanking(
            widget.rankingId!,
            int.parse(rankingCtrl.text),
          );
        }
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.club != null;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppColors.lime, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          isEdit ? "EDIT CLUB" : "ADD CLUB",
          style: const TextStyle(
            fontFamily: "Geologica",
            fontSize: 36,
            color: AppColors.lime,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 24),

            _input("Club Name", nameCtrl),
            _input("Country", countryCtrl),
            _input("Stadium", stadiumCtrl),
            _input("Year Founded", yearCtrl,
                keyboard: TextInputType.number),
            _input("Image URL", imageCtrl),
            _input("Ranking", rankingCtrl,
                keyboard: TextInputType.number),

            const SizedBox(height: 48),

            // ================= BUTTON =================
            GestureDetector(
              onTap: saveClub,
              child: Container(
                width: 260,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(54),
                ),
                alignment: Alignment.center,
                child: Text(
                  isEdit ? "Save Club" : "Add Club",
                  style: const TextStyle(
                    fontFamily: "Geologica",
                    fontSize: 24,
                    color: AppColors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavbar(
        selectedIndex: 2,
        onTap: (_) {},
      ),
    );
  }

  // ================= INPUT FIELD (BOLD & CLEAR) =================
  Widget _input(
    String hint,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(54),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: ctrl,
          keyboardType: keyboard,
          style: const TextStyle(
            fontFamily: "Geologica",
            fontSize: 22,
            fontWeight: FontWeight.w600, // 🔥 ISI TEKS TEBAL
            color: AppColors.indigo,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: "Geologica",
              fontSize: 22,
              fontWeight: FontWeight.bold, // 🔥 HINT TEBAL
              color: AppColors.indigo.withOpacity(0.7),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

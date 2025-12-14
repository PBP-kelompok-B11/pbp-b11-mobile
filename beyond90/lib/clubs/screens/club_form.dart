import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
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

    if (nameCtrl.text.isEmpty ||
        countryCtrl.text.isEmpty ||
        stadiumCtrl.text.isEmpty ||
        yearCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    final clubData = {
      "nama": nameCtrl.text,
      "negara": countryCtrl.text,
      "stadion": stadiumCtrl.text,
      "tahun_berdiri": int.parse(yearCtrl.text),
      "url_gambar": imageCtrl.text,
    };

    try {
      if (!isEdit) {
        // ADD CLUB
        final clubId = await ClubService.createClub(clubData);

        if (rankingCtrl.text.isNotEmpty) {
          await ClubService.createRanking(
            clubId,
            int.parse(rankingCtrl.text),
          );
        }
      } else {
        // EDIT CLUB
        await ClubService.updateClub(widget.club!.id, clubData);

        // EDIT RANKING
        if (widget.rankingId != null &&
            rankingCtrl.text.isNotEmpty) {
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          isEdit ? "EDIT CLUB" : "ADD CLUB",
          style: const TextStyle(
            fontFamily: "Geologica",
            fontSize: 32,
            color: AppColors.lime,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _field("Club Name", nameCtrl),
            _field("Country", countryCtrl),
            _field("Stadium", stadiumCtrl),
            _field("Year Founded", yearCtrl,
                keyboard: TextInputType.number),
            _field("Image URL", imageCtrl),
            _field("Ranking", rankingCtrl,
                keyboard: TextInputType.number),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: saveClub,
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  isEdit ? "Save" : "Add",
                  style: const TextStyle(
                    fontFamily: "Geologica",
                    fontSize: 20,
                    color: AppColors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.lime,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.lime),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: keyboard,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

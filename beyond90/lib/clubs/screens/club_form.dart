import 'package:flutter/material.dart';
import '../models/club.dart';
import '../service/club_service.dart';

class ClubForm extends StatefulWidget {
  final Club? club; // null = add, not null = edit

  const ClubForm({super.key, this.club});

  @override
  State<ClubForm> createState() => _ClubFormState();
}

class _ClubFormState extends State<ClubForm> {
  final Color indigo = const Color(0xFF1E1B4B);
  final Color lime = const Color(0xFFBEF264);

  late TextEditingController nameCtrl;
  late TextEditingController countryCtrl;
  late TextEditingController stadiumCtrl;
  late TextEditingController yearCtrl;
  late TextEditingController imageCtrl;
  late TextEditingController rankingCtrl; // NEW

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.club?.nama ?? "");
    countryCtrl = TextEditingController(text: widget.club?.negara ?? "");
    stadiumCtrl = TextEditingController(text: widget.club?.stadion ?? "");
    yearCtrl = TextEditingController(text: widget.club?.tahunBerdiri?.toString() ?? "");
    imageCtrl = TextEditingController(text: widget.club?.urlGambar ?? "");
    rankingCtrl = TextEditingController(); // only for ADD
  }

  Future<void> saveClub() async {
    if (nameCtrl.text.isEmpty ||
        countryCtrl.text.isEmpty ||
        stadiumCtrl.text.isEmpty ||
        yearCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("All fields required")));
      return;
    }

    final data = {
      "nama": nameCtrl.text,
      "negara": countryCtrl.text,
      "stadion": stadiumCtrl.text,
      "tahun_berdiri": int.tryParse(yearCtrl.text) ?? 0,
      "url_gambar": imageCtrl.text,
    };

    try {
      if (widget.club == null) {
        // ADD MODE
        final newId = await ClubService.createClub(data);

        // create ranking
        if (rankingCtrl.text.isNotEmpty) {
          await ClubService.createRanking(newId, int.parse(rankingCtrl.text));
        }

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Club Added!")));
      } else {
        // EDIT MODE
        await ClubService.updateClub(widget.club!.id, data);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Club Updated!")));
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.club != null;

    return Scaffold(
      backgroundColor: indigo,
      appBar: AppBar(
        backgroundColor: indigo,
        elevation: 0,
        title: Text(
          isEdit ? "EDIT CLUB" : "ADD CLUB",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 32,
            color: lime,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            _field("Club Name", nameCtrl),
            _field("Country", countryCtrl),
            _field("Stadium", stadiumCtrl),
            _field("Year Founded", yearCtrl),
            _field("Image URL", imageCtrl),

            if (!isEdit) _field("Ranking (1-100)", rankingCtrl),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: saveClub,
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: lime,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  isEdit ? "Save" : "Add",
                  style: TextStyle(
                    fontFamily: "Geologica",
                    fontSize: 20,
                    color: indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text(label, style: TextStyle(color: lime, fontSize: 18)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: lime),
          ),
          child: TextField(
            controller: ctrl,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

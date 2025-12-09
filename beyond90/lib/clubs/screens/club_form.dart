import 'package:flutter/material.dart';
import '../models/club.dart';
import '../service/club_service.dart';

class ClubFormPage extends StatefulWidget {
  final Club? club; 

  const ClubFormPage({super.key, this.club});

  @override
  _ClubFormPageState createState() => _ClubFormPageState();
}

class _ClubFormPageState extends State<ClubFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController negaraController;
  late TextEditingController stadionController;
  late TextEditingController tahunController;
  late TextEditingController urlGambarController;

  bool get isEdit => widget.club != null;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.club?.nama ?? "");
    negaraController = TextEditingController(text: widget.club?.negara ?? "");
    stadionController = TextEditingController(text: widget.club?.stadion ?? "");
    tahunController = TextEditingController(
        text: widget.club?.tahunBerdiri.toString() ?? "");
    urlGambarController =
        TextEditingController(text: widget.club?.urlGambar ?? "");
  }

  @override
  void dispose() {
    namaController.dispose();
    negaraController.dispose();
    stadionController.dispose();
    tahunController.dispose();
    urlGambarController.dispose();
    super.dispose();
  }

  Future<void> _saveClub() async {
    if (!_formKey.currentState!.validate()) return;

    final clubData = {
      "nama": namaController.text,
      "negara": negaraController.text,
      "stadion": stadionController.text,
      "tahun_berdiri": int.tryParse(tahunController.text) ?? 0,
      "url_gambar": urlGambarController.text.isEmpty
          ? null
          : urlGambarController.text,
    };

    try {
      if (isEdit) {
        // UPDATE club
        await ClubService.updateClub(widget.club!.id, clubData);
      } else {
        // CREATE new club
        await ClubService.createClub(clubData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEdit ? "Club updated!" : "Club created!")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Club" : "Buat Club Baru"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: "Nama Club"),
                validator: (value) =>
                    value!.isEmpty ? "Nama wajib diisi" : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: negaraController,
                decoration: InputDecoration(labelText: "Negara"),
                validator: (value) =>
                    value!.isEmpty ? "Negara wajib diisi" : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: stadionController,
                decoration: InputDecoration(labelText: "Stadion"),
                validator: (value) =>
                    value!.isEmpty ? "Stadion wajib diisi" : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: tahunController,
                decoration: InputDecoration(labelText: "Tahun Berdiri"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Tahun wajib diisi" : null,
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: urlGambarController,
                decoration: InputDecoration(labelText: "URL Gambar (optional)"),
              ),
              SizedBox(height: 32),

              ElevatedButton(
                onPressed: _saveClub,
                child: Text(isEdit ? "Update Club" : "Simpan Club"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

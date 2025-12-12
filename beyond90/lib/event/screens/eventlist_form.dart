import 'package:flutter/material.dart';
import 'package:beyond90/event/widgets/left_drawer.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/event/screens/menu_event.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  State<EventFormPage> createState() => EventFormPageState();
}

class EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _namaEvent = "";
  String _lokasi = "";
  DateTime? _tanggal;
  String _timHome = "";
  String _timAway = "";
  int _skorHome = 0;
  int _skorAway = 0;

  final TextEditingController _tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tanggal = DateTime.now();
    _tanggalController.text =
        "${_tanggal!.year}-${_tanggal!.month}-${_tanggal!.day}";
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tanggal = picked;
        _tanggalController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event Form'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Nama Event ===
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: "Nama Event", border: OutlineInputBorder()),
                onChanged: (value) => _namaEvent = value,
                validator: (value) =>
                    value == null || value.isEmpty ? "Tidak boleh kosong!" : null,
              ),
            ),

            // === Lokasi ===
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: "Lokasi", border: OutlineInputBorder()),
                onChanged: (value) => _lokasi = value,
                validator: (value) =>
                    value == null || value.isEmpty ? "Tidak boleh kosong!" : null,
              ),
            ),

            // === Tanggal ===
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _tanggalController,
                readOnly: true,
                decoration: const InputDecoration(
                    labelText: "Tanggal", border: OutlineInputBorder()),
                validator: (value) =>
                    value == null || value.isEmpty ? "Pilih tanggal!" : null,
                onTap: () => _selectDate(context),
              ),
            ),

            // === Tim Home ===
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: "Tim Home", border: OutlineInputBorder()),
                onChanged: (value) => _timHome = value,
                validator: (value) =>
                    value == null || value.isEmpty ? "Tidak boleh kosong!" : null,
              ),
            ),

            // === Tim Away ===
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: "Tim Away", border: OutlineInputBorder()),
                onChanged: (value) => _timAway = value,
                validator: (value) =>
                    value == null || value.isEmpty ? "Tidak boleh kosong!" : null,
              ),
            ),

            // === Skor Home ===
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Skor Home", border: OutlineInputBorder()),
                onChanged: (value) {
                  _skorHome = int.tryParse(value) ?? 0;
                },
                validator: (value) =>
                    value == null || value.isEmpty ? "Isi skor!" : null,
              ),
            ),

            // === Skor Away ===
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Skor Away", border: OutlineInputBorder()),
                onChanged: (value) {
                  _skorAway = int.tryParse(value) ?? 0;
                },
                validator: (value) =>
                    value == null || value.isEmpty ? "Isi skor!" : null,
              ),
            ),

            // === Tombol Simpan ===
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        "http://localhost:8000/event/add-flutter/",
                        jsonEncode({
                          "nama_event": _namaEvent,
                          "lokasi": _lokasi,
                          "tanggal": _tanggalController.text,
                          "tim_home": _timHome,
                          "tim_away": _timAway,
                          "skor_home": _skorHome,
                          "skor_away": _skorAway,
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Event successfully added!")),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Something went wrong.")),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

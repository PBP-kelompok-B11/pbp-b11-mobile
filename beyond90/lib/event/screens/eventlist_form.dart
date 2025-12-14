import 'package:flutter/material.dart';
import 'package:beyond90/event/widgets/left_drawer.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/event/screens/menu_event.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _namaEvent = "";
  String _lokasi = "";
  String _timHome = "";
  String _timAway = "";
  int _skorHome = 0;
  int _skorAway = 0;

  final TextEditingController _tanggalController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tanggalController.text =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
  }
  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        _tanggalController.text =
            "${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ==== NAMA EVENT ====
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Nama Event",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _namaEvent = v),
                  validator: (v) => v == null || v.isEmpty
                      ? "Nama event tidak boleh kosong!"
                      : null,
                ),
              ),

              // ==== LOKASI ====
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Lokasi Event",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _lokasi = v),
                  validator: (v) => v == null || v.isEmpty
                      ? "Lokasi tidak boleh kosong!"
                      : null,
                ),
              ),

              // ==== TANGGAL ====
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _tanggalController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Tanggal Event",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: _pickDate,

                  // FIX: Validasi cek controller, bukan cek _tanggal (karena _tanggal tdk nullable)
                  validator: (_) {
                    if (_tanggalController.text.isEmpty) {
                      return "Tanggal wajib diisi!";
                    }
                    return null;
                  },
                ),
              ),

              // ==== TIM HOME ====
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Tim Home",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _timHome = v),
                  validator: (v) => v == null || v.isEmpty
                      ? "Nama tim Home tidak boleh kosong!"
                      : null,
                ),
              ),

              // ==== TIM AWAY ====
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Tim Away",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _timAway = v),
                  validator: (v) => v == null || v.isEmpty
                      ? "Nama tim Away tidak boleh kosong!"
                      : null,
                ),
              ),

              // ==== SKOR HOME ====
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Skor Home (opsional)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    setState(() {
                      if (v.isNotEmpty) {
                        _skorHome = int.tryParse(v) ?? 0;
                      }
                    });
                  },
                ),
              ),

              // ==== SKOR AWAY ====
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Skor Away (opsional)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    setState(() {
                      if (v.isNotEmpty) {
                        _skorAway = int.tryParse(v) ?? 0;
                      }
                    });
                  },
                ),
              ),

              // ==== BUTTON SIMPAN ====
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        "http://localhost:8000/create-event-flutter/",
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

                      if (!mounted) return;

                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Event berhasil dibuat!"),
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventHomePage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Gagal membuat event. Coba lagi."),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

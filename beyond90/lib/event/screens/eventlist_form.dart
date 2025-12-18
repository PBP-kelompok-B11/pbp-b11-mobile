import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/event/screens/event_entry_list.dart';
import 'dart:convert';

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
      backgroundColor: AppColors.indigo,
      appBar: AppBar(
        title: const Text("Create Event", 
          style: TextStyle(fontFamily: 'LeagueGothic', fontSize: 28, letterSpacing: 1)),
        backgroundColor: AppColors.indigo,
        foregroundColor: AppColors.lime,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              _buildTextField(
                hint: "Nama Event",
                onChanged: (v) => _namaEvent = v,
                validator: (v) => v!.isEmpty ? "Nama event wajib diisi" : null,
              ),
              _buildTextField(
                hint: "Lokasi Event",
                onChanged: (v) => _lokasi = v,
                validator: (v) => v!.isEmpty ? "Lokasi wajib diisi" : null,
              ),
              _buildTextField(
                hint: "Tanggal Event",
                controller: _tanggalController,
                readOnly: true,
                onTap: _pickDate,
                suffixIcon: const Icon(Icons.calendar_today, color: AppColors.indigo),
              ),
              _buildTextField(
                hint: "Tim Home",
                onChanged: (v) => _timHome = v,
                validator: (v) => v!.isEmpty ? "Nama tim wajib diisi" : null,
              ),
              _buildTextField(
                hint: "Tim Away",
                onChanged: (v) => _timAway = v,
                validator: (v) => v!.isEmpty ? "Nama tim wajib diisi" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      hint: "Skor Home",
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _skorHome = int.tryParse(v) ?? 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      hint: "Skor Away",
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _skorAway = int.tryParse(v) ?? 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // BUTTON SIMPAN
              GestureDetector(
                behavior: HitTestBehavior.opaque, // Agar seluruh area kotak bisa diklik
                onTap: () async {
                  print("--- PROSES SIMPAN DIMULAI ---");
                  
                  if (_formKey.currentState!.validate()) {
                    print("Validasi Form: OK");
                    
                    try {
                      // PERHATIKAN: Tidak ada jsonEncode di sini! Langsung {...}
                      final response = await request.post(
                        "http://localhost:8000/events/create-flutter/",
                        {
                          "nama_event": _namaEvent,
                          "lokasi": _lokasi,
                          "tanggal": _tanggalController.text,
                          "tim_home": _timHome,
                          "tim_away": _timAway,
                          "skor_home": _skorHome.toString(),
                          "skor_away": _skorAway.toString(),
                        },
                      ).timeout(const Duration(seconds: 10));

                      print("Response Server Diterima: $response");

                      if (response['status'] == 'success') {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Event berhasil disimpan!")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const EventEntryListPage()),
                        );
                      } else {
                        print("Server menolak data: ${response['message']}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal: ${response['message']}")),
                        );
                      }
                    } catch (e) {
                      print("KONEKSI GAGAL/ERROR: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Terjadi kesalahan koneksi: $e")),
                      );
                    }
                  } else {
                    print("Validasi Form: GAGAL (Ada field kosong)");
                  }
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.lime,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Simpan Event",
                    style: TextStyle(
                      fontFamily: "Geologica",
                      fontSize: 18,
                      color: AppColors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.indigo, fontFamily: 'Geologica'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: InputBorder.none,
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}
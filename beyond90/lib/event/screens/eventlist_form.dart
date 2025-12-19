import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/screens/event_entry_list.dart';

class EventFormPage extends StatefulWidget {
  final EventEntry? event; // Data lama untuk Edit
  const EventFormPage({super.key, this.event});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Gunakan controller agar text bisa di-set saat initState (Edit mode)
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _timHomeController = TextEditingController();
  final TextEditingController _timAwayController = TextEditingController();
  final TextEditingController _skorHomeController = TextEditingController();
  final TextEditingController _skorAwayController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      // Jika Mode EDIT: Isi controller dengan data lama
      var f = widget.event!.fields;
      _lokasiController.text = f.lokasi;
      _timHomeController.text = f.timHome;
      _timAwayController.text = f.timAway;
      _skorHomeController.text = f.skorHome.toString();
      _skorAwayController.text = f.skorAway.toString();
      _tanggalController.text = "${f.tanggal.year}-${f.tanggal.month.toString().padLeft(2, '0')}-${f.tanggal.day.toString().padLeft(2, '0')}";
    } else {
      // Jika Mode CREATE: Default hari ini
      _tanggalController.text = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
    }
  }

  @override
  void dispose() {
    _lokasiController.dispose();
    _timHomeController.dispose();
    _timAwayController.dispose();
    _skorHomeController.dispose();
    _skorAwayController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    bool isEdit = widget.event != null;

    return Scaffold(
      backgroundColor: AppColors.indigo,
      appBar: AppBar(
        title: Text(isEdit ? "Edit Event" : "Create Event", 
          style: const TextStyle(fontFamily: 'Geologica', fontSize: 28)),
        backgroundColor: AppColors.indigo,
        foregroundColor: AppColors.lime,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTextField(hint: "Lokasi", controller: _lokasiController),
              _buildTextField(hint: "Tanggal", controller: _tanggalController, readOnly: true, onTap: _pickDate),
              _buildTextField(hint: "Tim Home", controller: _timHomeController),
              _buildTextField(hint: "Tim Away", controller: _timAwayController),
              Row(
                children: [
                  Expanded(child: _buildTextField(hint: "Skor Home", controller: _skorHomeController, keyboardType: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField(hint: "Skor Away", controller: _skorAwayController, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // Penentuan URL: Create pakai route lama, Edit pakai route edit-flutter
                    String url = isEdit 
                        ? "http://localhost:8000/events/${widget.event!.pk}/edit-flutter/"
                        : "http://localhost:8000/events/create-flutter/";

                    final response = await request.post(url, {
                      "lokasi": _lokasiController.text,
                      "tanggal": _tanggalController.text,
                      "tim_home": _timHomeController.text,
                      "tim_away": _timAwayController.text,
                      "skor_home": _skorHomeController.text,
                      "skor_away": _skorAwayController.text,
                    });

                    if (response['status'] == 'success') {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil!")));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EventEntryListPage()));
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(40)),
                  alignment: Alignment.center,
                  child: Text(isEdit ? "Perbarui Event" : "Simpan Event", 
                      style: const TextStyle(color: AppColors.indigo, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper pick date & textfield tetap sama seperti sebelumnya...
  Future<void> _pickDate() async {
    final selected = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (selected != null) setState(() => _tanggalController.text = "${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}");
  }

  Widget _buildTextField({required String hint, required TextEditingController controller, bool readOnly = false, VoidCallback? onTap, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.indigo, fontFamily: 'Geologica'),
          decoration: InputDecoration(hintText: hint, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), border: InputBorder.none),
        ),
      ),
    );
  }
}
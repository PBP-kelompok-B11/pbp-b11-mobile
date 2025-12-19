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
      var f = widget.event!.fields;
      _lokasiController.text = f.lokasi;
      _timHomeController.text = f.timHome;
      _timAwayController.text = f.timAway;
      
      // 🔥 HANDLE NULL SAAT INIT: Kalau skor null, biarkan textfield kosong
      _skorHomeController.text = f.skorHome?.toString() ?? "";
      _skorAwayController.text = f.skorAway?.toString() ?? "";
      
      _tanggalController.text = "${f.tanggal.year}-${f.tanggal.month.toString().padLeft(2, '0')}-${f.tanggal.day.toString().padLeft(2, '0')}";
    } else {
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
          style: const TextStyle(fontFamily: 'Geologica', fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.indigo,
        foregroundColor: AppColors.lime,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, bottom: 8),
                child: Text("Event Information", style: TextStyle(color: AppColors.lime, fontWeight: FontWeight.bold)),
              ),
              _buildTextField(hint: "Lokasi", controller: _lokasiController, icon: Icons.location_on),
              _buildTextField(hint: "Tanggal", controller: _tanggalController, readOnly: true, onTap: _pickDate, icon: Icons.calendar_today),
              _buildTextField(hint: "Tim Home", controller: _timHomeController, icon: Icons.home),
              _buildTextField(hint: "Tim Away", controller: _timAwayController, icon: Icons.airplanemode_active),
              
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15, bottom: 8),
                child: Text("Scores (Leave blank if not started)", style: TextStyle(color: AppColors.lime, fontSize: 12)),
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField(hint: "Home Score", controller: _skorHomeController, keyboardType: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField(hint: "Away Score", controller: _skorAwayController, keyboardType: TextInputType.number)),
                ],
              ),
              
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    String url = isEdit 
                        ? "http://localhost:8000/events/${widget.event!.pk}/edit-flutter/"
                        : "http://localhost:8000/events/create-flutter/";

                    // 🔥 LOGIC KIRIM DATA: Pastikan skor bisa kosong
                    final response = await request.post(url, {
                      "lokasi": _lokasiController.text,
                      "tanggal": _tanggalController.text,
                      "tim_home": _timHomeController.text,
                      "tim_away": _timAwayController.text,
                      // Jika kosong, tetap kirim "" agar di Django bisa dicek is_empty
                      "skor_home": _skorHomeController.text, 
                      "skor_away": _skorAwayController.text,
                    });

                    if (response['status'] == 'success') {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Event saved successfully!"), backgroundColor: Colors.green)
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EventEntryListPage()));
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Gagal menyimpan data"), backgroundColor: Colors.red)
                      );
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.lime, 
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
                  ),
                  alignment: Alignment.center,
                  child: Text(isEdit ? "UPDATE EVENT" : "CREATE EVENT", 
                      style: const TextStyle(color: AppColors.indigo, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Perbaikan UI TextField ---
  Widget _buildTextField({
    required String hint, 
    required TextEditingController controller, 
    bool readOnly = false, 
    VoidCallback? onTap, 
    TextInputType keyboardType = TextInputType.text,
    IconData? icon
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.indigo),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, color: AppColors.indigo, size: 20) : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          // Bikin border lebih rapi (tidak terlalu bulat seperti kapsul)
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
        validator: (value) {
          // Hanya Lokasi, Tanggal, Tim yang WAJIB. Skor boleh kosong.
          if (hint != "Home Score" && hint != "Away Score") {
            if (value == null || value.isEmpty) return "$hint cannot be empty";
          }
          return null;
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );
    if (selected != null) {
      setState(() => _tanggalController.text = "${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}");
    }
  }
}
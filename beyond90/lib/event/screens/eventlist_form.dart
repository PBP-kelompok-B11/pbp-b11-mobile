import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/service/event_service.dart';
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
  final TextEditingController _timHomeLogoController = TextEditingController();
  final TextEditingController _timAwayLogoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      var f = widget.event!.fields;
      _lokasiController.text = f.lokasi;
      _timHomeController.text = f.timHome;
      _timAwayController.text = f.timAway;
      
      _skorHomeController.text = f.skorHome?.toString() ?? "";
      _skorAwayController.text = f.skorAway?.toString() ?? "";
      _timHomeLogoController.text = f.logoHome ?? "";
      _timAwayLogoController.text = f.logoAway ?? "";

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
    _timHomeLogoController.dispose();
    _timAwayLogoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    bool isEdit = widget.event != null;
    return PopScope(
      canPop: false, 
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, false);
      },
      child: Scaffold(
        backgroundColor: AppColors.indigo,
        appBar: AppBar(
          title: Text(isEdit ? "Edit Event" : "Create Event", 
            style: const TextStyle(fontFamily: 'Geologica', fontSize: 24, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.indigo,
          foregroundColor: AppColors.lime,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
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
                _buildTextField(hint: "Logo Tim Home (filename, ex: burnley.png)", controller: _timHomeLogoController, icon: Icons.image,),
                _buildTextField(hint: "Logo Tim Away (filename, ex: arsenal.png)", controller: _timAwayLogoController, icon: Icons.image,),
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
                      final request = context.read<CookieRequest>();
                      
                      // 1. Kumpulkan data ke dalam Map
                      Map<String, dynamic> body = {
                        "lokasi": _lokasiController.text,
                        "tanggal": _tanggalController.text,
                        "tim_home": _timHomeController.text,
                        "tim_away": _timAwayController.text,
                        "skor_home": _skorHomeController.text, 
                        "skor_away": _skorAwayController.text,
                        "logo_home": _timHomeLogoController.text,
                        "logo_away": _timAwayLogoController.text,
                      };

                      bool success;
                      if (isEdit) {
                        // 2. Panggil Service untuk Update
                        success = await EventService.updateEvent(request, widget.event!.pk, body);
                      } else {
                        // 3. Panggil Service untuk Create
                        success = await EventService.createEvent(request, body);
                      }

                      if (success) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Event saved successfully!"), backgroundColor: Colors.green)
                        );
                        // Kirim 'true' agar ListPage tau dia harus refresh
                        Navigator.pop(context, true); 
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
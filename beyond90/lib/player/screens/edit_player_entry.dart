// import 'package:beyond90/player/screens/player_entry_list.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/player/service/player_service.dart';
import 'package:beyond90/player/models/player_entry.dart';
import 'package:beyond90/authentication/widgets/auth_back.dart';
import 'package:provider/provider.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';



class EditPlayerEntry extends StatefulWidget {
  final PlayerEntry player;

  const EditPlayerEntry({super.key, required this.player});

  @override
  State<EditPlayerEntry> createState() => _EditPlayerEntryState();
}

class _EditPlayerEntryState extends State<EditPlayerEntry> {

  final _formKey = GlobalKey<FormState>();

  String? selectedPosisi;

  final List<String> posisiList = [
    'GK',
    'DF',
    'DFFW',
    'DFMF',
    'MF',
    'MFDF',
    'MFFW',
    'FW',
    'FWDF',
    'FWMF',
  ];

  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController negaraCtrl = TextEditingController();
  final TextEditingController usiaCtrl = TextEditingController();
  final TextEditingController tinggiCtrl = TextEditingController();
  final TextEditingController beratCtrl = TextEditingController();
  final TextEditingController fotoCtrl = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    namaCtrl.text = widget.player.nama;
    negaraCtrl.text = widget.player.negara;
    usiaCtrl.text = widget.player.usia.toString();
    tinggiCtrl.text = widget.player.tinggi.toString();
    beratCtrl.text = widget.player.berat.toString();
    selectedPosisi = widget.player.posisi;
    fotoCtrl.text = widget.player.thumbnail ?? "";
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    negaraCtrl.dispose();
    usiaCtrl.dispose();
    tinggiCtrl.dispose();
    beratCtrl.dispose();
    fotoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // ===== MAIN CONTENT =====
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 80),

                      // BEYOND 90
                      Text(
                        "Edit Player",
                        style: TextStyle(
                          fontFamily: "Geologica",
                          color: AppColors.lime,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  
                      const SizedBox(height: 40),

                      _inputField(
                        controller: namaCtrl,
                        hint: "Nama Pemain",
                        obscure: false,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Nama tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      _inputField(
                        controller: negaraCtrl,
                        hint: "Negara",
                        obscure: false,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Negara tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      _inputField(
                        controller: usiaCtrl,
                        hint: "Usia",
                        obscure: false,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Usia wajib diisi";
                          }
                          if (int.tryParse(v) == null) {
                            return "Usia harus berupa angka";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      _inputField(
                        controller: tinggiCtrl,
                        hint: "Tinggi",
                        obscure: false,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Tinggi wajib diisi";
                          }
                          if (double.tryParse(v) == null) {
                            return "Tinggi harus berupa angka";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      _inputField(
                        controller: beratCtrl,
                        hint: "Berat",
                        obscure: false,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Berat wajib diisi";
                          }
                          if (double.tryParse(v) == null) {
                            return "Berat harus berupa angka";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      _posisiDropdown(),

                      const SizedBox(height: 15),

                     _inputField(
                        controller: fotoCtrl,
                        hint: "Foto URL (opsional)",
                        obscure: false,
                        validator: (v) {
                   
                          if (v == null || v.trim().isEmpty) {
                            return null;
                          }
                    
                          final uri = Uri.tryParse(v);

                          if (uri == null || !uri.isAbsolute) {
                            return "URL tidak valid";
                          }

                          if (!['http', 'https'].contains(uri.scheme)) {
                            return "URL harus http / https";
                          }

                      
                          return null;
                        },
                      ),


                      const SizedBox(height: 40),

                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                if (selectedPosisi == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Posisi harus dipilih")),
                                  );
                                  return;
                                }

                                setState(() => isLoading = true);

                                try {

                                  final request = context.read<CookieRequest>();

                                  if (!request.loggedIn) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Anda harus login terlebih dahulu")),
                                    );
                                    return;
                                  }

                                  await PlayerEntryService.updatePlayer(
                                    request, widget.player.id,
                                    {
                                      "nama": namaCtrl.text.trim(),
                                      "negara": negaraCtrl.text.trim(),
                                      "usia": usiaCtrl.text.trim(),
                                      "tinggi": tinggiCtrl.text.trim(),
                                      "berat": beratCtrl.text.trim(),
                                      "posisi": selectedPosisi,
                                      "thumbnail": fotoCtrl.text.trim().isEmpty
                                          ? null
                                          : fotoCtrl.text.trim(),
                                    },
                                  );


                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Player successfully saved!")),
                                  );

                                  Navigator.pop(context, true);

                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                } finally {
                                  if (mounted) setState(() => isLoading = false);
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
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.black)
                              : Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontFamily: "Geologica",
                                    fontSize: 20,
                                    color: AppColors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),



                      const SizedBox(height: 30),

                    ],
                  ),
                ),
              ),
            ),

            // 🔙 BACK BUTTON di atas semua widget
            Positioned(
              top: 16,
              left: 16,
              child: AuthBackButton(onTap: () => Navigator.pop(context)),
            ),

          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: 330,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: "Geologica",
            fontSize: 18,
            color: AppColors.indigo,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          errorStyle: const TextStyle(
            fontSize: 12,
            height: 0.8,
          ),
        ),
      ),
    );
  }


  Widget _posisiDropdown() {
    return Container(
      width: 330,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: selectedPosisi,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Posisi wajib dipilih";
          }
          return null;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        hint: Text(
          "Posisi",
          style: TextStyle(
            fontFamily: "Geologica",
            fontSize: 18,
            color: AppColors.indigo,
          ),
        ),
        items: posisiList
            .map(
              (pos) => DropdownMenuItem(
                value: pos,
                child: Text(
                  pos,
                  style: const TextStyle(
                    fontFamily: "Geologica",
                    fontSize: 18,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedPosisi = value;
          });
        },
      ),
    );
  }


}

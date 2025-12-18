import 'package:beyond90/player/screens/player_entry_list.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/player/service/player_service.dart';


class AddPlayerEntry extends StatefulWidget {
  const AddPlayerEntry({super.key});

  @override
  State<AddPlayerEntry> createState() => _AddPlayerEntryState();
}

class _AddPlayerEntryState extends State<AddPlayerEntry> {

  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController negaraCtrl = TextEditingController();
  final TextEditingController usiaCtrl = TextEditingController();
  final TextEditingController tinggiCtrl = TextEditingController();
  final TextEditingController beratCtrl = TextEditingController();
  final TextEditingController posisiCtrl = TextEditingController();
  final TextEditingController fotoCtrl = TextEditingController();

  bool isLoading = false;



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
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    // BEYOND 90
                    Text(
                      "Add Player",
                      style: TextStyle(
                        fontFamily: "Geologica",
                        color: AppColors.lime,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                
                    const SizedBox(height: 40),

      
                    _inputField(controller: namaCtrl, hint: "Nama Pemain", obscure: false),
                    const SizedBox(height: 15),
                    _inputField(controller: negaraCtrl, hint: "Negara", obscure: false),
                    const SizedBox(height: 15),
                    _inputField(controller: usiaCtrl, hint: "Usia", obscure: false),
                    const SizedBox(height: 15),
                    _inputField(controller: tinggiCtrl, hint: "Tinggi", obscure: false),
                    const SizedBox(height: 15),
                    _inputField(controller: beratCtrl, hint: "Berat", obscure: false),
                    const SizedBox(height: 15),
                    _inputField(controller: posisiCtrl, hint: "Posisi", obscure: false),
                    const SizedBox(height: 15),
                    _inputField(controller: fotoCtrl, hint: "Foto URL", obscure: false),

                    const SizedBox(height: 40),

                
                    GestureDetector(
                      // onTap: isLoading ? null : _doLogin,
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

                    // SIGN UP & ADMIN LOGIN
                  

                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),

            // 🔙 BACK BUTTON di atas semua widget
            
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
  }) {
    return Container(
      width: 330,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: "Geologica",
            fontSize: 18,
            color: AppColors.indigo,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}

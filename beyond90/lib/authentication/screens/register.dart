import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import '../widgets/auth_back.dart';
import '../service/auth_service.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  bool isLoading = false;

  void _doRegister() async {
    if (passwordCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak cocok!")),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await AuthService.register(
      username: usernameCtrl.text.trim(),
      email: "",
      password: passwordCtrl.text.trim(),
      confirmPassword: confirmCtrl.text.trim(),
      alamat: "",
      umur: "0",
      nomorHp: "",
      role: "user",
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akun berhasil dibuat!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi gagal.")),
      );
      setState(() => isLoading = false);
    }
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
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    // BEYOND 90
                    Text(
                      "BEYOND",
                      style: TextStyle(
                        fontFamily: "LeagueGothic",
                        color: Colors.white,
                        fontSize: 120,
                      ),
                    ),
                    Text(
                      "90",
                      style: TextStyle(
                        fontFamily: "LeagueGothic",
                        color: Colors.white,
                        fontSize: 120,
                      ),
                    ),

                    const SizedBox(height: 40),

                    _inputField(controller: usernameCtrl, hint: "Username", obscure: false),
                    const SizedBox(height: 20),
                    _inputField(controller: passwordCtrl, hint: "Password", obscure: true),
                    const SizedBox(height: 20),
                    _inputField(controller: confirmCtrl, hint: "Confirm Password", obscure: true),
                    const SizedBox(height: 40),

                    // SIGN UP BUTTON
                    GestureDetector(
                      onTap: isLoading ? null : _doRegister,
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
                                "Sign Up",
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

                    // LOGIN REDIRECT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontFamily: "Geologica",
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: Text(
                            "Log in!",
                            style: TextStyle(
                              fontFamily: "Geologica",
                              color: AppColors.lime,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),

            // 🔙 BACK BUTTON
            Positioned(
              top: 16,
              left: 16,
              child: AuthBackButton(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
              ),
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
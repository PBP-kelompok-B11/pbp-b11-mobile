import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import '../../landing_page/screeen/landing_page.dart';
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
        email: "",              // nanti bisa isi bener
        password: passwordCtrl.text.trim(),
        confirmPassword: confirmCtrl.text.trim(),
        alamat: "",
        umur: "0",
        nomorHp: "",
        role: "user",
      );

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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 100),

                // BEYOND
                Text(
                  "BEYOND",
                  style: TextStyle(
                    fontFamily: "LeagueGothic",
                    color: Colors.white,
                    fontSize: 120,
                  ),
                ),

                // 90
                Text(
                  "90",
                  style: TextStyle(
                    fontFamily: "LeagueGothic",
                    color: Colors.white,
                    fontSize: 120,
                  ),
                ),

                const SizedBox(height: 40),

                // USERNAME
                Container(
                  width: 330,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: usernameCtrl,
                    decoration: InputDecoration(
                      hintText: "Username",
                      hintStyle: TextStyle(
                        fontFamily: "Geologica",
                        fontSize: 18,
                        color: AppColors.indigo,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // PASSWORD
                Container(
                  width: 330,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                        fontFamily: "Geologica",
                        fontSize: 18,
                        color: AppColors.indigo,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CONFIRM PASSWORD
                Container(
                  width: 330,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(
                        fontFamily: "Geologica",
                        fontSize: 18,
                        color: AppColors.indigo,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),

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
      ),
    );
  }
}
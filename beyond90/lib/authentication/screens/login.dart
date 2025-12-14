import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import '../service/auth_service.dart';
import 'register.dart';
import '../../landing_page/screeen/landing_page.dart';
import '../widgets/auth_back.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool isLoading = false;

  void _doLogin() async {
    setState(() => isLoading = true);

    final result = await AuthService.login(
      usernameCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (result["success"] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username atau password salah."),
        ),
      );
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

                    // USERNAME
                    _inputField(
                      controller: usernameCtrl,
                      hint: "Username",
                      obscure: false,
                    ),

                    const SizedBox(height: 20),

                    // PASSWORD
                    _inputField(
                      controller: passwordCtrl,
                      hint: "Password",
                      obscure: true,
                    ),

                    const SizedBox(height: 40),

                    // LOGIN BUTTON
                    GestureDetector(
                      onTap: isLoading ? null : _doLogin,
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
                                "Log in",
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
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontFamily: "Geologica",
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign up!",
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
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _doLogin,
                          child: Text(
                            "Login as Admin",
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

            // 🔙 BACK BUTTON di atas semua widget
            Positioned(
              top: 16,
              left: 16,
              child: AuthBackButton(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MyHomePage()),
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

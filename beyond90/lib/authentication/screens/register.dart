import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:provider/provider.dart'; // Tambahkan ini
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Tambahkan ini
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
  final TextEditingController emailCtrl = TextEditingController(); // Tambahkan field email
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();
  
  // Field tambahan sesuai model UserProfile Django kamu
  final TextEditingController alamatCtrl = TextEditingController();
  final TextEditingController umurCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  // Role Selection
  String selectedRole = 'user'; 
  final List<String> roles = ['user', 'admin'];

  bool isLoading = false;

  void _doRegister() async {
    // Validasi dasar
    if (passwordCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak cocok!")),
      );
      return;
    }

    if (usernameCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan Password tidak boleh kosong!")),
      );
      return;
    }

    setState(() => isLoading = true);

    // AMBIL REQUEST DARI PROVIDER
    final request = context.read<CookieRequest>();

    // Panggil AuthService dengan parameter lengkap
    final result = await AuthService.register(
      request, 
      username: usernameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      confirmPassword: confirmCtrl.text.trim(),
      alamat: alamatCtrl.text.trim(),
      umur: umurCtrl.text.trim(),
      nomorHp: phoneCtrl.text.trim(),
      role: selectedRole,
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Akun berhasil dibuat!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Registrasi gagal.")),
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
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Text("BEYOND 90", style: TextStyle(fontFamily: "LeagueGothic", color: Colors.white, fontSize: 80)),
                    const SizedBox(height: 30),

                    // INPUT FIELDS
                    _inputField(controller: usernameCtrl, hint: "Username", obscure: false),
                    const SizedBox(height: 15),
                    _inputField(controller: emailCtrl, hint: "Email", obscure: false),
                    const SizedBox(height: 15),
                    _inputField(controller: alamatCtrl, hint: "Alamat", obscure: false),
                    const SizedBox(height: 15),
                    _inputField(controller: umurCtrl, hint: "Umur", obscure: false, keyboardType: TextInputType.number),
                    const SizedBox(height: 15),
                    _inputField(controller: phoneCtrl, hint: "Nomor Handphone", obscure: false, keyboardType: TextInputType.phone),
                    const SizedBox(height: 15),
                    
                    // DROPDOWN ROLE
                    _roleDropdown(),

                    const SizedBox(height: 15),
                    _inputField(controller: passwordCtrl, hint: "Password", obscure: true),
                    const SizedBox(height: 15),
                    _inputField(controller: confirmCtrl, hint: "Confirm Password", obscure: true),
                    const SizedBox(height: 30),

                    // SIGN UP BUTTON
                    GestureDetector(
                      onTap: isLoading ? null : _doRegister,
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(40)),
                        alignment: Alignment.center,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.black)
                            : Text("Sign Up", style: TextStyle(fontFamily: "Geologica", fontSize: 20, color: AppColors.indigo, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 20),
                    _loginRedirect(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),

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

  // Widget khusus untuk Dropdown Role
  Widget _roleDropdown() {
    return Container(
      width: 330,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          items: roles.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontFamily: "Geologica", color: AppColors.indigo)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedRole = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: 330,
      height: 55,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontFamily: "Geologica", fontSize: 18, color: AppColors.indigo),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }

  Widget _loginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ", style: TextStyle(fontFamily: "Geologica", color: Colors.white, fontSize: 16)),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
          child: Text("Log in!", style: TextStyle(fontFamily: "Geologica", color: AppColors.lime, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
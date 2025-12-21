import 'package:flutter/material.dart';
import 'package:beyond90/event/screens/eventlist_form.dart';
import 'package:beyond90/event/screens/event_entry_list.dart';
import 'package:beyond90/authentication/screens/login.dart'; // Import halaman login
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Import provider auth
import 'package:provider/provider.dart'; // Import provider

// Ganti BASE_URL ini ke http://10.0.2.2:8000 jika menggunakan Android Emulator
// ignore: constant_identifier_names
const String BASE_URL = "http://localhost:8000"; 

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>(); // Ambil request provider
    
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
            ),
            child: Column(
              children: [
                Text(
                  'Football Shop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Seluruh produk sepak bola terkini di sini!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          
          // --- ADD EVENT ---
          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('Add Event'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventFormPage(),
                )
              );
            },
          ),
          
          // --- EVENT LIST ---
          ListTile(
              leading: const Icon(Icons.list_alt), // Mengubah ikon agar lebih sesuai
              title: const Text('Event List'),
              onTap: () {
                  // Route ke EventEntryListPage (menampilkan semua produk secara default)
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EventEntryListPage()),
                  );
              },
          ),
          
          // --- LOGOUT (Tambahan Baru) ---
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                  // Panggil fungsi logout dari CookieRequest
                  final response = await request.logout(
                      "$BASE_URL/auth/logout/"); 
                  
                  String message = response["message"];
                  
                  if (context.mounted) {
                      if (response['status']) {
                          String uname = response["username"] ?? "User";
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Berhasil logout! Sampai jumpa lagi, $uname."),
                          ));
                          
                          // Arahkan ke halaman login
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                      } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Gagal logout: $message"),
                              ),
                          );
                      }
                  }
              },
          ),
        ],
      ),
    );
  }
}
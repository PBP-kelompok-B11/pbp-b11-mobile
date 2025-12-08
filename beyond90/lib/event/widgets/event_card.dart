import 'package:flutter/material.dart';
import 'package:beyond90/event/screens/menu_event.dart';
import 'package:beyond90/event/screens/eventlist_form.dart';
import 'package:beyond90/event/screens/event_entry_list.dart';
import 'package:beyond90/event/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// Ganti BASE_URL ini ke http://10.0.2.2:8000 jika menggunakan Android Emulator
// ignore: constant_identifier_names
const String BASE_URL = "http://localhost:8000"; 

class ItemCard extends StatelessWidget {
  // Menampilkan kartu dengan ikon dan nama.

  final ItemHomepage item; 

  const ItemCard(this.item, {super.key}); 

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      // Menentukan warna latar belakang dari tema aplikasi.
      color: item.color,
      // Membuat sudut kartu melengkung.
      borderRadius: BorderRadius.circular(12),

      child: InkWell(
        // Aksi ketika kartu ditekan.
        onTap: () async {
          // Menampilkan pesan SnackBar saat kartu ditekan.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")));
          
          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (item.name == "Add Event") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EventFormPage(),
              )
            );
          }
          else if (item.name == "All Events") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      // Panggil EventEntryListPage tanpa filter (default: false)
                      builder: (context) => const EventEntryListPage() 
                  ),
              );
          }
          // Logika untuk "My Events" (Memanggil daftar dengan filter)
          else if (item.name == "My Events") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      // Meneruskan flag filterByUser=true ke EventEntryListPage
                      builder: (context) => const EventEntryListPage(filterByUser: true) 
                  ),
              );
          }
          // Logika untuk "Logout"
          else if (item.name == "Logout") {
              final response = await request.logout(
                  "$BASE_URL/auth/logout/");
              String message = response["message"];
              if (context.mounted) {
                  if (response['status']) {
                      String uname = response["username"];
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$message Sampai jumpa lagi, $uname."),
                      ));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                  } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(message),
                          ),
                      );
                  }
              }
          }
        },
        // Container untuk menyimpan Icon dan Text
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              // Menyusun ikon dan teks di tengah kartu.
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
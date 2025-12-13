import 'package:flutter/material.dart';
import 'package:beyond90/event/screens/menu_event.dart';
import 'package:beyond90/event/screens/eventlist_form.dart';
import 'package:beyond90/event/screens/event_entry_list.dart';
import 'package:beyond90/authentication/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

const String BASE_URL = "http://localhost:8000"; 

class ItemCard extends StatelessWidget {
  final ItemHomepage item; 

  const ItemCard(this.item, {super.key}); 

  @override
  Widget build(BuildContext context) {
    // Pastikan main.dart punya ChangeNotifierProvider<CookieRequest>
    final request = context.watch<CookieRequest>();

    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),

      child: InkWell(
        onTap: () async {
          if (item.name == "Add Event") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventFormPage()),
            );
          } else if (item.name == "All Events") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventEntryListPage()),
            );
          } else if (item.name == "My Events") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventEntryListPage(filterByUser: true)),
            );
          } else if (item.name == "Logout") {
            final response = await request.logout("$BASE_URL/auth/logout/");
            String message = response["message"];
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$message Sampai jumpa lagi, $uname."))
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            }
          }
        },

        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const SizedBox(height: 3),
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

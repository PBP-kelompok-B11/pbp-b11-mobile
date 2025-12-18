import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/media_gallery/screens/media_entry_list.dart';

class GalleryButton extends StatelessWidget {
  const GalleryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to Gallery Page later
        // Example (aktifkan nanti):
        // Navigator.pushNamed(context, '/gallery');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaEntryListPage(),
          ));
      },
      child: Container(
        width: 300,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.lime,
          borderRadius: BorderRadius.circular(34),
        ),
        alignment: Alignment.center,
        child: Text(
          "Go to Gallery",
          style: TextStyle(
            fontFamily: 'Geologica',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.indigo,
          ),
        ),
      ),
    );
  }
}

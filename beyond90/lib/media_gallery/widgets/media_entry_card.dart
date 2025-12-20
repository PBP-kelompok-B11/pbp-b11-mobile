import 'package:beyond90/media_gallery/models/media_entry.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class MediaEntryCard extends StatelessWidget {
  final MediaEntry media;
  final VoidCallback onTap;

  const MediaEntryCard({
    super.key,
    required this.media,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.grey[200],
          child: media.thumbnail.isNotEmpty ?  Image.network(
            'http://localhost:8000/media-gallery/proxy-image/?url=${Uri.encodeComponent(media.thumbnail)}',
            fit: BoxFit.cover)
            : const Center(child: Icon(Icons.image, size: 40),
          ),
        ),
      ),
    );
  }
}
  // ClipRRect(
  //   borderRadius: BorderRadius.circular(6),
  //   child: Image.network(
  //     'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(media.thumbnail)}',
  //     height: 150,
  //     width: double.infinity,
  //     fit: BoxFit.cover,
  //     errorBuilder: (context, error, stackTrace) => Container(
  //       height: 150,
  //       color: Colors.grey[300],
  //       child: const Center(child: Icon(Icons.broken_image)),
  //     ),
  //   ),
  // ),
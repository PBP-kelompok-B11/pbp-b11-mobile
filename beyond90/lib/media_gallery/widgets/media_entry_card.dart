import 'package:beyond90/media_gallery/models/media_entry.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    final isVideo = media.category.toLowerCase() == 'video';

    String imageUrl;

    if(isVideo){
      final videoId = YoutubePlayer.convertUrlToId(media.thumbnail);
      imageUrl = videoId != null ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg' : " ";
    } else{
      imageUrl = 'https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/media-gallery/proxy-image/?url=${Uri.encodeComponent(media.thumbnail)}';
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // thumbnail
            Positioned.fill(
              child: imageUrl.isEmpty ? Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 40),
              ) : Image.network(
                imageUrl, 
                fit: BoxFit.cover,
              ),
            ),

            if (isVideo)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
          ],
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
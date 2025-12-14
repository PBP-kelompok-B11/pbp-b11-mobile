import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';

class EventEntryCard extends StatelessWidget {
  final EventEntry event;
  final VoidCallback onTap;

  const EventEntryCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan URL untuk Thumbnail. 
    // Jika event.thumbnail adalah null atau kosong, gunakan URL placeholder yang aman.
    final String imageUrl = (event.thumbnail?.isNotEmpty == true) 
        // Jika ada, gunakan URL aslinya dan panggil event.thumbnail! untuk memberi tahu Dart bahwa itu pasti String
        ? 'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(event.thumbnail!)}'
        // Jika null/kosong, gunakan URL placeholder yang tidak akan error.
        : 'https://placehold.co/600x400/CCCCCC/000000?text=No+Image';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  // Gunakan imageUrl yang sudah diproses
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Name
                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Category
                Text('Category: ${event.category}'),
                const SizedBox(height: 6),

                // Description Preview
                Text(
                  event.description.length > 100
                      ? '${event.description.substring(0, 100)}...'
                      : event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 6),

                // Featured indicator
                if (event.isFeatured)
                  const Text(
                    'Featured',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
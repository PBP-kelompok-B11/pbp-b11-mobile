import 'package:beyond90/app_colors.dart';
import 'package:beyond90/media_gallery/screens/media_edit.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/media_gallery/models/media_entry.dart';
import 'package:beyond90/media_gallery/service/media_service.dart';

class MediaDetailPage extends StatefulWidget {
  final MediaEntry media;

  const MediaDetailPage({super.key, required this.media});

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();

}

class _MediaDetailPageState extends State<MediaDetailPage>{
  late int _viewers;
  bool _isUpdate = false;

  final Map<String, String> categoryMap = {
    'foto': 'Photo',
    'video': 'Video',
  };


  @override
  void initState(){
    super.initState();
    _viewers = widget.media.viewers + 1;

    // update viewers ke backend
    _updateViewersToBackEnd();
  }

  Future<void> _updateViewersToBackEnd() async{
    if(_isUpdate){
      return;
    }

    _isUpdate = true;

    final success = await MediaService.updateViewers(
      mediaId: widget.media.id, 
      viewers: _viewers,
    );

    if(!success){
      debugPrint('Failed to update viewers to backend');
    }

    _isUpdate = false;
    
  }


  String _formatDate(DateTime date) {
    // Simple date formatter without intl package
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final displayCat = categoryMap[widget.media.category.toLowerCase()] ?? widget.media.category;
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.lime,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context, _viewers);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async{
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Delete"),
                    content: const Text('Are you sure you want to delete this media?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  )
                );

                if(confirm == true){
                  final success = await MediaService.deleteMedia(widget.media.id);

                  if(success && mounted){
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
            ElevatedButton(
              onPressed: () async{
                final updated = await Navigator.push(
                  context, MaterialPageRoute(
                    builder: (_) => MediaEditPage(
                      media: widget.media
                    ),
                  ),
                );

                if(updated != null && mounted){
                  setState(() {
                    widget.media.deskripsi = updated.deskripsi;
                    widget.media.category = updated.category;
                    widget.media.thumbnail = updated.thumbnail;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lime,
                foregroundColor: Colors.black,
              ),
              child: const Text('Edit'),
            ),
            // Thumbnail image
            if (widget.media.thumbnail.isNotEmpty)
              Image.network(
                'http://localhost:8000/media-gallery/proxy-image/?url=${Uri.encodeComponent(widget.media.thumbnail)}',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Category and Date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.indigo,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          displayCat.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lime,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(widget.media.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Views count
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Total Views\n$_viewers views',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  const Divider(height: 32),

                  // Full content
                  Text(
                    widget.media.deskripsi,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
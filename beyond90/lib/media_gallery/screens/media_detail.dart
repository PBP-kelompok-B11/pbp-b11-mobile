import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import ini wajib
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/media_gallery/screens/media_edit.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/media_gallery/models/media_entry.dart';
import 'package:beyond90/media_gallery/service/media_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MediaDetailPage extends StatefulWidget {
  final List<MediaEntry> mediaList;
  final int initIndx;

  const MediaDetailPage({
    super.key,
    required this.mediaList,
    required this.initIndx,
  });

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();

}

class _MediaDetailPageState extends State<MediaDetailPage>{
  late PageController _pageController;
  YoutubePlayerController? _ytController;
  String? _currVidId;
  late int _currIdx;
  bool _isUpdate = false;
  bool _hasError = false;
  bool _isAdmin = false;

  final Map<String, String> categoryMap = {
    'foto': 'Photo',
    'video': 'Video',
  };

  @override
  void initState() {
    super.initState();
    _currIdx = widget.initIndx;
    _pageController = PageController(initialPage: _currIdx);

    _isAdmin = AuthService.isAdmin; // ✅ SUMBER KEBENARAN

    widget.mediaList[_currIdx].viewers += 1;
    _updateViewersToBackEnd(widget.mediaList[_currIdx]);
  }


  
  void _initializeYoutubePlayer(String videoId) {
    _ytController?.dispose();
    setState(() {
      _hasError = false;
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      )..addListener(() {
          if (_ytController!.value.hasError && !_hasError) {
            setState(() => _hasError = true);
          }
        });
    });
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
    _ytController?.dispose();
  }

  Future<void> _updateViewersToBackEnd(MediaEntry media) async{
    if(_isUpdate){
      return;
    }

    _isUpdate = true;

    final success = await MediaService.updateViewers(
      mediaId: media.id, 
      viewers:media.viewers,
    );

    if(!success){
      debugPrint('Failed to update viewers to backend');
    }

    _isUpdate = false;
    
  }

  Future<void> _launchYoutube(String videoId) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  String _formatDate(DateTime date) {
    // Simple date formatter without intl package
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final displayCat = categoryMap[widget.mediaList[_currIdx].category.toLowerCase()] ?? widget.mediaList[_currIdx].category;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Detail'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.lime,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context, widget.mediaList[_currIdx]);
          },
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaList.length,
        onPageChanged: (index) {
          _ytController?.dispose(); // Matikan video saat geser halaman
          setState(() {
            _ytController = null;
            _hasError = false;
            _currIdx = index;
            widget.mediaList[index].viewers += 1;
          });
          _updateViewersToBackEnd(widget.mediaList[index]);
        },
        itemBuilder: (context, idx){
          final media = widget.mediaList[idx];

          return _buildMediaDetail(media, idx);
        },
      ),
    );
  }

  Widget _buildMediaContent(MediaEntry media){
    if(media.category.toLowerCase() == 'video'){
      return _buildVideo(media);
    }else{
      return _buildImage(media);
    }
  }

  Widget _buildMediaDetail(MediaEntry media, int idx) {
    final displayCat = categoryMap[widget.mediaList[_currIdx].category.toLowerCase()] ??
     widget.mediaList[_currIdx].category;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tambahkan Padding di sini agar MediaContent punya jarak dari atas/samping
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0), // (Kiri, Atas, Kanan, Bawah)
            child: _buildMediaContent(media),
          ),
          _buildActionButtons(media),
          _buildInfoSection(media, displayCat),
        ],
      ),
    );
  }

  Widget _buildActionButtons(MediaEntry media) {
    if(!_isAdmin){
      return const SizedBox(height: 16);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Delete"),
                  content: const Text('Are you sure you want to delete this media?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                  ],
                ),
              );
              if (confirm == true) {
                final success = await MediaService.deleteMedia(media.id);
                if (success && mounted) Navigator.pop(context, true);
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => MediaEditPage(media: media)));
              if (updated != null && mounted) {
                setState(() {
                  media.deskripsi = updated.deskripsi;
                  media.category = updated.category;
                  media.thumbnail = updated.thumbnail;
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.lime, foregroundColor: Colors.black),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(MediaEntry media, String displayCat) {
    // Mengambil lebar layar saat ini
    double screenWidth = MediaQuery.of(context).size.width;
    
    // Tentukan apakah ini mode "Wide" (Lebar) seperti tampilan Django di Web
    bool isWideScreen = screenWidth > 600;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DESKRIPSI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            media.deskripsi,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.lime, thickness: 3),
          const SizedBox(height: 16),

          // Layout yang menyesuaikan ukuran layar
          isWideScreen 
            ? Row(
                // MODE WEB/DJANGO: Jarak diatur merata ke seluruh lebar
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoContent('KATEGORI', _buildCategoryBadge(displayCat)),
                  _buildInfoContent('TOTAL VIEWS', _buildViewsInfo(media.viewers.toString())),
                  _buildInfoContent('UPLOAD DATE', _buildDateInfo(media.createdAt)),
                ],
              )
            : Wrap(
                // MODE HP: Jika layar sempit, otomatis turun ke bawah (tidak overflow)
                spacing: 40, // Jarak horizontal antar item
                runSpacing: 20, // Jarak vertikal jika baris baru
                children: [
                  _buildInfoContent('KATEGORI', _buildCategoryBadge(displayCat)),
                  _buildInfoContent('TOTAL VIEWS', _buildViewsInfo(media.viewers.toString())),
                  _buildInfoContent('UPLOAD DATE', _buildDateInfo(media.createdAt)),
                ],
              ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- FUNGSI HELPER UNTUK KONTEN (Agar kode bersih) ---

  Widget _buildInfoContent(String label, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildCategoryBadge(String displayCat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.indigo,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.lime, width: 1.5),
      ),
      child: Text(
        displayCat.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.lime),
      ),
    );
  }

  Widget _buildViewsInfo(String viewers) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.visibility_rounded, size: 20, color: AppColors.indigo.withOpacity(0.7)),
        const SizedBox(width: 8),
        Text(viewers, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.indigo)),
      ],
    );
  }

  Widget _buildDateInfo(DateTime date) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.calendar_month_outlined, size: 18, color: AppColors.indigo.withOpacity(0.7)),
        const SizedBox(width: 6),
        Text(_formatDate(date), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
      ],
    );
  }

  Widget _buildImage(MediaEntry media){
    if (media.thumbnail.isEmpty){
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No image available')),
      );
    }
    return AspectRatio(
      // Menggunakan rasio 16:9 agar bentuk box konsisten dengan video
      aspectRatio: 16 / 9, 
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200], // Background hitam untuk area sisa jika gambar tidak memenuhi box
          borderRadius: BorderRadius.circular(12), // Membuat sudut box sedikit melengkung agar lebih modern
          border: Border.all(color: AppColors.lime.withOpacity(0.5), width: 1), // Border tipis sesuai tema
        ),
        clipBehavior: Clip.antiAlias, // Memastikan gambar tetap berada di dalam radius border
        child: Image.network(
          'http://localhost:8000/media-gallery/proxy-image/?url=${Uri.encodeComponent(media.thumbnail)}',
          // Menggunakan contain agar seluruh gambar masuk ke dalam box tanpa ada yang terpotong
          fit: BoxFit.contain, 
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideo(MediaEntry media){
    final videoId = YoutubePlayer.convertUrlToId(media.thumbnail);

    if(videoId == null){
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Invalid video URL'),
      );
    }
    // Jika sedang error, tampilkan tombol YouTube
    if (_hasError) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Video tidak bisa diputar di sini", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _launchYoutube(videoId),
              icon: const Icon(Icons.open_in_new),
              label: const Text("Tonton di YouTube"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      );
    }
    // Jika player aktif, tampilkan player. Jika tidak, tampilkan thumbnail.
    if (_ytController != null) {
      return YoutubePlayer(
        controller: _ytController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.lime,
      );
    } else {
      final thumbUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
      return GestureDetector(
        onTap: () => _initializeYoutubePlayer(videoId),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(thumbUrl, height: 250, width: double.infinity, fit: BoxFit.cover),
            const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
          ],
        ),
      );
    }
  }
}


class YoutubePlayerPage extends StatefulWidget {
  final String videoId;

  const YoutubePlayerPage({super.key, required this.videoId});

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: false,
      ),
    )..addListener(_onControllerChange);
  }

  void _onControllerChange() {
    // Jika controller mendeteksi error (seperti di screenshot Anda)
    if (_controller.value.hasError && !_hasError) {
      setState(() {
        _hasError = true;
      });
    }
  }

  // Fungsi untuk membuka YouTube secara eksternal
  Future<void> _launchYoutube() async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=${widget.videoId}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Video Player'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.lime,
      ),
      body: Center(
        child: _hasError 
          ? _buildErrorFallback() // Tampilan jika error
          : YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onEnded: (meta) {
                },
              ),
              builder: (context, player) => player,
            ),
      ),
    );
  }

  // Widget Tampilan Error dengan Tombol YouTube
  Widget _buildErrorFallback() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 80),
        const SizedBox(height: 16),
        const Text(
          "Maaf, video tidak dapat diputar di sini.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _launchYoutube,
          icon: const Icon(Icons.play_arrow),
          label: const Text("Tonton di YouTube"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, 
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        TextButton(
          onPressed: () => setState(() { _hasError = false; _controller.reload(); }),
          child: const Text("Coba lagi", style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }
}
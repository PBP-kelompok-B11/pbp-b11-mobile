import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/media_gallery/models/media_entry.dart';
import 'package:beyond90/media_gallery/screens/media_detail.dart';
import 'package:beyond90/media_gallery/widgets/media_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/widgets/bottom_navbar.dart';
import 'package:beyond90/media_gallery/screens/medialist_form.dart';

class MediaEntryListPage extends StatefulWidget {
  const MediaEntryListPage({super.key});

  @override
  State<MediaEntryListPage> createState() => _MediaEntryListPageState();
}

class _MediaEntryListPageState extends State<MediaEntryListPage> {
  late Future<List<MediaEntry>> _mediaFuture;

  @override
  void initState(){
    super.initState();
    final request = context.read<CookieRequest>();
    _mediaFuture = fetchMedia(request);
  }

  Future<List<MediaEntry>> fetchMedia(CookieRequest request) async {
    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final response = await request.get('https://a-sheriqa-beyond-90.pbp.cs.ui.ac.id/media-gallery/json/');
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to MediaEntry objects
    List<MediaEntry> listMedia = [];
    for (var d in data) {
      if (d != null) {
        listMedia.add(MediaEntry.fromJson(d));
      }
    }
    return listMedia;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: AppColors.indigo,
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: AppColors.indigo,
        foregroundColor: AppColors.lime,
        actions: [
          
          _buildActionBtn(),
        ],
      ),
      body: FutureBuilder(
        future: _mediaFuture,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'There are no media in Beyond90 yet.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints){
                    final width = constraints.maxWidth;
                    int crossAxisCount;
                    if (width >= 900) {
                      crossAxisCount = 4; // tablet besar / desktop
                    } else if (width >= 600) {
                      crossAxisCount = 3; // tablet
                    } else {
                      crossAxisCount = 2; // HP
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => MediaEntryCard(
                        media: snapshot.data![index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaDetailPage(
                                mediaList: snapshot.data!,
                                initIndx: index,
                              ),
                            ),
                          ).then((_) {
                            setState(() {
                              _mediaFuture =fetchMedia(request);
                            });
                          });
                        },
                      ),
                    );
                  }
                ),
              );
            }
          }
        },
      ),

       // ===== BOTTOM NAVBAR =====
      bottomNavigationBar: BottomNavbar(
        selectedIndex: 3, // media
        onTap: (index) {
          if (index == 3) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/search');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/category');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/media_gallery');
              break;
          }
        },
      ),
    );
  }

  Widget _buildActionBtn(){
    final request = context.watch<CookieRequest>();

    if (!request.loggedIn) {
      return const SizedBox(height: 16);
    }

    bool isAdmin = request.jsonData['is_admin'] ?? false; 

  if (!isAdmin) {
    return const SizedBox.shrink(); // Jika bukan admin, jangan tampilkan apa-apa
  }

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ElevatedButton(
        onPressed: (){
          Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => const MediaFormPage()
            )
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        child: const Text(
          '+ Add Media',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
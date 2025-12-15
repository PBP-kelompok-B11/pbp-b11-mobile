import 'package:flutter/material.dart';
import 'package:beyond90/media_gallery/models/media_entry.dart';
// import 'package:beyond90/media_gallery/screens/media_detail.dart';
import 'package:beyond90/media_gallery/widgets/media_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MediaEntryListPage extends StatefulWidget {
  const MediaEntryListPage({super.key});

  @override
  State<MediaEntryListPage> createState() => _MediaEntryListPageState();
}

class _MediaEntryListPageState extends State<MediaEntryListPage> {
  Future<List<MediaEntry>> fetchMedia(CookieRequest request) async {
    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final response = await request.get('http://localhost:8000/media-gallery/json/');
    
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
      appBar: AppBar(
        title: const Text('Media Entry List'),
      ),
      body: FutureBuilder(
        future: fetchMedia(request),
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => MediaEntryCard(
                  media: snapshot.data![index],
                  onTap: () {
                    // Show a snackbar when news card is clicked
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text("You clicked on ${snapshot.data![index].title}"),
                        ),
                      );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
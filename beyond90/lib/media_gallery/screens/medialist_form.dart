import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/media_gallery/screens/media_entry_list.dart';

class MediaFormPage extends StatefulWidget{
  const MediaFormPage({super.key});

  @override
  State<MediaFormPage> createState() => _MediaFormPageState();

}

class _MediaFormPageState extends State<MediaFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _deskripsi = "";
  String _kategori = "foto"; // default
  String _thumbnail = "";


  final Map<String, String> _categoryMap = {
    'foto': 'Photo',
    'video': 'Video',
  };


  @override
  Widget build(BuildContext context){
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Upload Media'),
        ),
        backgroundColor: AppColors.indigo,
        foregroundColor: AppColors.white,
      ),
      body: Container(
        color: AppColors.background,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Deskripsi
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Masukkan deskripsi media",
                              hintStyle: const TextStyle(
                                color: AppColors.white,
                              ),
                              fillColor: AppColors.textPrimary,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onChanged: (String? value){
                              setState(() {
                                _deskripsi = value!;
                              });
                            },
                            validator: (String? value){
                              if (value == null || value.isEmpty){
                                return "Please fill in this field";
                              }
                              return null;
                            },
                          ),
                        ),

                        // Kategori
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Kategori",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                hint: const Text("Pilih Kategori"),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                initialValue: _kategori,
                                items: _categoryMap.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key, // DATA → foto / video
                                    child: Text(entry.value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue){
                                  setState(() {
                                    _kategori = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // Thumbnail URL
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Thumbnail URL",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "https://example.com/image.jpg",
                                  hintStyle: const TextStyle(
                                    color: AppColors.textPrimary
                                  ),
                                  fillColor: AppColors.textPrimary,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onChanged: (String? value){
                                  setState(() {
                                    _thumbnail = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // === Tombol Simpan ===
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                  WidgetStateProperty.all(AppColors.lime),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final response = await request.postJson(
                                    "http://localhost:8000/media-gallery/create-flutter/", jsonEncode({
                                      "deskripsi":  _deskripsi,
                                      "thumbnail": _thumbnail,
                                      "category": _kategori,
                                    }),
                                  );
                                  if(context.mounted){
                                    if (response['status'] == 'success') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("News successfully saved!"),
                                      ));
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MediaEntryListPage()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Something went wrong, please try again."),
                                      ));
                                    }
                                  }
                                }
                              },
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
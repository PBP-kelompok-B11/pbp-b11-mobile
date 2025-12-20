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
        title: const Text(
          'Upload Media',
          style: TextStyle(
            fontFamily: 'Geologica',
            fontWeight: FontWeight.bold,
            fontSize: 30,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.indigo,
        foregroundColor: AppColors.lime,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.indigo,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(height: 24),

                  // ===== DESKRIPSI =====
                  _roundedInput(
                    child: TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Deskripsi",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => _deskripsi = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Deskripsi wajib diisi" : null,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== KATEGORI =====
                  _roundedInput(
                    child: DropdownButtonFormField<String>(
                      initialValue: _kategori,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      items: _categoryMap.entries.map((e) {
                        return DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() {
                        _kategori = value!;
                      }),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== THUMBNAIL =====
                  _roundedInput(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Thumbnail URL",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => _thumbnail = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Thumbnail wajib diisi" : null,
                    ),
                  ),


                  const SizedBox(height: 32),

                  // ===== BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lime,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final response = await request.postJson(
                            "http://localhost:8000/media-gallery/add-flutter/",
                            jsonEncode({
                              "deskripsi": _deskripsi,
                              "thumbnail": _thumbnail,
                              "category": _kategori,
                            }),
                          );

                          if (context.mounted && response['status'] == 'success') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MediaEntryListPage(),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Add Media",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _roundedInput({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}


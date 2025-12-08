import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

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


  final List<String> _categories = [
    'foto',
    'video'
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Upload Media'),
        ),
        backgroundColor: AppColors.indigo,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                    labelText: "Deskripsi",
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
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _kategori,
                  items: _categories.map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat[0].toUpperCase() + cat.substring(1)),
                  )).toList(),
                  onChanged: (String? newValue){
                    setState(() {
                      _kategori = newValue!;
                    });
                  },
                ),
              ),

              // Thumbnail URL
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "https://example.com/image.jpg",
                    labelText: "Thumbnail URL",
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
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                        WidgetStateProperty.all(AppColors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Media berhasil disimpan!'),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
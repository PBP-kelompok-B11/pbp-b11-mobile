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
            ],
          ),
        ),
      ),
    );
  }
}
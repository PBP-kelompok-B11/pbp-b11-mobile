import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/media_gallery/models/media_entry.dart';
import 'package:beyond90/media_gallery/service/media_service.dart';

class MediaEditPage extends StatefulWidget{
  final MediaEntry media;

  const MediaEditPage({super.key, required this.media});

  @override
  State<MediaEditPage> createState() => _MediaEditPageState();
}

class _MediaEditPageState extends State<MediaEditPage>{
  late TextEditingController _descController;
  late TextEditingController _thumbController;

  String _selectedCat = 'foto';
  bool _isSaved = false;

  final Map<String, String> categoryMap = {
    'foto': 'Photo',
    'video': 'Video',
  };

  @override
  void initState(){
    super.initState();
    _descController = TextEditingController(text: widget.media.deskripsi);
    _thumbController = TextEditingController(text: widget.media.thumbnail);
    _selectedCat = widget.media.category;
  }

  @override
  void dispose(){
    _descController.dispose();
    _thumbController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async{
    setState(() {
      _isSaved = true;
    });
    try{
      final updateMedia = await MediaService.editMedia(
        id: widget.media.id,
        deskripsi: _descController.text,
        category: _selectedCat,
        thumbnail: _thumbController.text,
      );

      if (!mounted) return;

      if (updateMedia != null) {
        Navigator.pop(context, updateMedia);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update media')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaved = false);
      }
    }
     
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Media',
          style: TextStyle(
            fontFamily: 'Geologica',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.lime,
      ),
      body: Container(
        height: double.infinity,
        color: AppColors.background,
        child: 
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // deskripsi
              _roundedInput(
                child: TextField(
                  controller: _descController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Deskripsi',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // category
              _roundedInput(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCat,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  items: categoryMap.entries.map((e) {
                    return DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    );
                  }).toList(),
                  onChanged: (value){
                    if(value != null){
                      setState(() {
                        _selectedCat = value;
                      });
                    }
                  }
                ),
              ),

              const SizedBox(height: 16),

              // thumbnail
              _roundedInput(
                child: TextField(
                  controller: _thumbController,
                  decoration: const InputDecoration(
                    hintText: 'Thumbnail URL',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isSaved ? null : _onSave,
                  child: _isSaved ? const CircularProgressIndicator() :
                      const Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                ),
              ),
            ],
          ),
        ),
      )
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

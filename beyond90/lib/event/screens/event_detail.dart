import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/event/screens/eventlist_form.dart'; // Ganti dengan path form kamu

class EventDetailPage extends StatelessWidget {
  final EventEntry event;

  const EventDetailPage({super.key, required this.event});

  // LOGIC DELETE
  Future<void> _deleteEvent(BuildContext context, CookieRequest request) async {
    final response = await request.post(
      "http://localhost:8000/events/delete/${event.pk}", 
      {},
    );

    if (context.mounted) {
      if (response['status'] == 'success' || response.isEmpty) { 
        // Note: Django redirect sering menghasilkan response kosong di Flutter
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event berhasil dihapus!")),
        );
        Navigator.pop(context, true); // Kembali ke list dan beri sinyal untuk refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus event.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = event.fields;
    final isAdmin = AuthService.isAdmin;
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, color: AppColors.lime, size: 30),
                  ),
                  const SizedBox(width: 16),
                  const Text("Event details",
                    style: TextStyle(color: AppColors.lime, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: Column(
                children: [
                  // Placeholder Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                    child: Container(height: 250, color: Colors.grey[300], child: const Icon(Icons.image, size: 80, color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text("${f.timHome} vs ${f.timAway}".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.indigo, fontSize: 36, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        
                        // Calendar Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/calendar.png', width: 24, height: 24, color: AppColors.indigo),
                            const SizedBox(width: 10),
                            Text("${f.tanggal.day} February ${f.tanggal.year}",
                                style: const TextStyle(fontSize: 20, color: AppColors.indigo)),
                          ],
                        ),
                        const SizedBox(height: 30),

                        _buildInfoPill(f.lokasi),
                        _buildInfoPill("Skor: ${f.skorHome} - ${f.skorAway}"),
                        _buildInfoPill("Dibuat oleh: ${f.createdBy ?? 'Admin'}"),
                        
                        const SizedBox(height: 30),

                        // ACTION BUTTONS & COMMENT (REVISED POSITION)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // 1. COMMENT BUTTON SEKARANG DI KIRI
                            Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(24)),
                              child: IconButton(
                                icon: const Icon(Icons.chat_bubble_outline, color: AppColors.indigo, size: 36),
                                onPressed: () { /* TODO: Comment page */ },
                              ),
                            ),
                            
                            const SizedBox(width: 12),

                            // 2. ADMIN BUTTONS (EDIT & DELETE) DI KANAN
                            if (isAdmin)
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildActionButton(
                                      text: "Edit Event",
                                      color: const Color(0xFFFACC15),
                                      textColor: AppColors.indigo,
                                      onTap: () {
                                        // LOGIC EDIT: Kirim data event ke form
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EventFormPage(event: event),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildActionButton(
                                      text: "Delete Event",
                                      color: const Color(0xFFEA580C),
                                      textColor: Colors.white,
                                      onTap: () {
                                        _showDeleteConfirmation(context, request);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Event"),
        content: const Text("Apakah Anda yakin ingin menghapus event ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent(context, request);
            }, 
            child: const Text("Hapus", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(String text) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(20)),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.indigo, fontSize: 18)),
    );
  }

  Widget _buildActionButton({required String text, required Color color, required Color textColor, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/event/screens/eventlist_form.dart';

class EventDetailPage extends StatelessWidget {
  final EventEntry event;

  const EventDetailPage({super.key, required this.event});

  Future<void> _deleteEvent(BuildContext context, CookieRequest request) async {
    final response = await request.post(
      "http://localhost:8000/events/${event.pk}/delete/", 
      {},
    );

    if (context.mounted) {
      if (response['status'] == 'success' || response.isEmpty) { 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event berhasil dihapus!")),
        );
        Navigator.pop(context, true); 
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

    // 🕒 LOGIC 3 STATUS (LIVE, UPCOMING, FINISHED)
    final now = DateTime.now();
    final bool isToday = f.tanggal.year == now.year &&
                         f.tanggal.month == now.month &&
                         f.tanggal.day == now.day;
    final bool isUpcoming = f.tanggal.isAfter(now) && !isToday;

    String statusText;
    Color statusColor;

    if (isToday) {
      statusText = "LIVE / TODAY";
      statusColor = const Color(0xFFEF4444); // Merah
    } else if (isUpcoming) {
      statusText = "UPCOMING";
      statusColor = const Color(0xFF22C55E); // Hijau
    } else {
      statusText = "FINISHED";
      statusColor = const Color(0xFF64748B); // Abu-abu
    }

    // ⚽ HANDLING SKOR NULL / KOSONG
    // Menggunakan operator ?? untuk memberikan nilai default "-" jika null
    final String homeScore = (f.skorHome == null) ? "_" : f.skorHome.toString();
    final String awayScore = (f.skorAway == null) ? "_" : f.skorAway.toString();

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
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // 🔥 STATUS PILL
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor, width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isToday) ...[
                                Container(
                                  width: 10, height: 10,
                                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                statusText,
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text("${f.timHome} vs ${f.timAway}".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.indigo, fontSize: 32, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        
                        // Calendar Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_month, color: AppColors.indigo, size: 24),
                            const SizedBox(width: 10),
                            Text(isToday ? "Today" : "${f.tanggal.day}/${f.tanggal.month}/${f.tanggal.year}",
                                style: const TextStyle(fontSize: 20, color: AppColors.indigo)),
                          ],
                        ),
                        const SizedBox(height: 30),

                        _buildInfoPill("📍 ${f.lokasi}"),
                        // Menampilkan skor yang sudah diproses (biar "-" kalau null)
                        _buildInfoPill("⚽ Score: $homeScore - $awayScore"),
                        _buildInfoPill("👤 Created by: ${f.username}"),
                        
                        const SizedBox(height: 30),

                        // ACTION BUTTONS
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 70, height: 70,
                              decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(20)),
                              child: IconButton(
                                icon: const Icon(Icons.chat_bubble_outline, color: AppColors.indigo, size: 30),
                                onPressed: () { /* TODO: Comment page */ },
                              ),
                            ),
                            
                            const SizedBox(width: 12),

                            if (isAdmin)
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildActionButton(
                                      text: "Edit Event",
                                      color: const Color(0xFFFACC15),
                                      textColor: AppColors.indigo,
                                      onTap: () {
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
                                      onTap: () => _showDeleteConfirmation(context, request),
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

  // --- UI Helpers tetap sama ---
  void _showDeleteConfirmation(BuildContext context, CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Event"),
        content: const Text("Tindakan ini tidak bisa dibatalkan. Yakin?"),
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
      decoration: BoxDecoration(color: AppColors.lime.withOpacity(0.7), borderRadius: BorderRadius.circular(20)),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.indigo, fontSize: 17, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionButton({required String text, required Color color, required Color textColor, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
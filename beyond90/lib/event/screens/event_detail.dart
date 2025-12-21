import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/app_colors.dart';
import 'package:beyond90/authentication/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:beyond90/event/screens/eventlist_form.dart';
import 'package:beyond90/event/service/event_service.dart';

class EventDetailPage extends StatelessWidget {
  final EventEntry event;

  const EventDetailPage({super.key, required this.event});

  Future<void> _deleteEvent(BuildContext context, CookieRequest request) async {
    final success = await EventService.deleteEvent(request, event.pk);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event berhasil dihapus!")),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = event.fields;
    final isAdmin = AuthService.isAdmin;
    final request = context.watch<CookieRequest>();

    final String currentUser = request.jsonData['username'] ?? "";
    final bool isOwner = f.username == currentUser;

    // --- Logic Status ---
    final String statusText = EventService.getEventStatus(f.tanggal);
    Color statusColor;

    switch (statusText) {
      case "LIVE":
        statusColor = const Color(0xFFEF4444);
        break;
      case "UPCOMING":
        statusColor = const Color(0xFF22C55E);
        break;
      default:
        statusColor = const Color(0xFF64748B);
    }

    final String homeScore = (f.skorHome == null) ? "_" : f.skorHome.toString();
    final String awayScore = (f.skorAway == null) ? "_" : f.skorAway.toString();
    
    return Scaffold(
      backgroundColor: AppColors.indigo,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.lime, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Event Details",
          style: TextStyle(
            fontFamily: "Geologica",
            color: AppColors.lime,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // STATUS PILL
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
                          if (statusText == "LIVE") ...[
                            Container(
                              width: 10, height: 10,
                              decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            statusText,
                            style: TextStyle(
                              fontFamily: "Geologica",
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        teamLogo(f.logoHome, size: 72),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "${f.timHome} VS ${f.timAway}",
                            textAlign: TextAlign.center,
                            // BAGIAN PENTING:
                            softWrap: true, 
                            maxLines: null, // Menghapus batasan baris agar bisa turun ke bawah
                            style: const TextStyle(
                              fontFamily: "Geologica",
                              color: AppColors.indigo,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.5,
                              height: 1.1, // Agar jarak antar baris rapi saat turun ke bawah
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        teamLogo(f.logoAway, size: 72),
                      ],
                    ),

                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_month, color: AppColors.indigo, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          statusText == "LIVE" ? "Today" : "${f.tanggal.day}/${f.tanggal.month}/${f.tanggal.year}",
                          style: const TextStyle(
                            fontFamily: "Geologica",
                            fontSize: 20,
                            color: AppColors.indigo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    _buildInfoPill("📍 ${f.lokasi}"),
                    _buildScorePill(homeScore, awayScore),
                    _buildInfoPill("👤 Created by: ${f.username}"),
                                        
                    const SizedBox(height: 30),

                    // --- ACTION BUTTONS ---
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tombol EDIT
                          if (isAdmin && isOwner)
                            _actionButtonSquare(
                              icon: Icons.edit,
                              color: const Color(0xFFFACC15), // Kuning
                              iconColor: AppColors.indigo,
                              onTap: () async {
                                final refresh = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EventFormPage(event: event)),
                                );
                                if (refresh == true) Navigator.pop(context, true);
                              },
                            ),

                          if (isAdmin && isOwner) const SizedBox(width: 10),

                          // Tombol DELETE
                          if (isAdmin && isOwner)
                            _actionButtonSquare(
                              icon: Icons.delete_outline,
                              color: const Color(0xFFEA580C), // Orange/Red
                              iconColor: Colors.white,
                              onTap: () => _showDeleteConfirmation(context, request),
                            ),

                          if (isAdmin && isOwner) const SizedBox(width: 10),

                          GestureDetector(
                            onTap: () { /* TODO: Comment page */ },
                            child: Container(
                              width: 56, // Ukuran disamakan dengan tombol kotak
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.lime, 
                                borderRadius: BorderRadius.circular(18), 
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/icons/comment.png', 
                                  width: 28, height: 28,
                                  color: AppColors.indigo,
                                  errorBuilder: (context, error, stackTrace) => 
                                      const Icon(Icons.chat_bubble_outline, color: AppColors.indigo),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---
  Widget _actionButtonSquare({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18), // Membuat kotak dengan sudut tumpul
        ),
        child: Icon(
          icon,
          size: 28,
          color: iconColor,
        ),
      ),
    );
  }
  Widget teamLogo(String? url, {double size = 34}) {
    if (url == null || url.trim().isEmpty) {
      return Icon(Icons.shield, size: size, color: AppColors.indigo);
    }

    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      // Jika link error/mati, tampilkan icon tameng
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.shield, size: size, color: AppColors.indigo);
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, CookieRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Event", style: TextStyle(fontFamily: "Geologica", fontWeight: FontWeight.bold)),
        content: const Text("Yakin ingin menghapus event buatanmu ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent(context, request);
            }, 
            child: const Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
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
      child: Text(
        text, 
        textAlign: TextAlign.center, 
        style: const TextStyle(
          fontFamily: "Geologica",
          color: AppColors.indigo, 
          fontSize: 18, 
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildScorePill(String home, String away) {
    int s1 = int.tryParse(home) ?? -1;
    int s2 = int.tryParse(away) ?? -1;
    
    bool homeWins = s1 > s2 && s1 != -1;
    bool awayWins = s2 > s1 && s2 != -1;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lime, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (homeWins) const Text("🏆 ", style: TextStyle(fontSize: 20)),
          Text(home, style: const TextStyle(fontFamily: "Geologica", color: AppColors.indigo, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
          const Text(" - ", style: TextStyle(fontFamily: "Geologica", color: AppColors.indigo, fontSize: 22, fontWeight: FontWeight.w900)),
          Text(away, style: const TextStyle(fontFamily: "Geologica", color: AppColors.indigo, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
          if (awayWins) const Text(" 🏆", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String text, required Color color, required Color textColor, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Text(
          text, 
          textAlign: TextAlign.center, 
          style: TextStyle(
            fontFamily: "Geologica",
            color: textColor, 
            fontSize: 18, 
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),
      ),
    );
  }
}
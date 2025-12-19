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
    final now = DateTime.now();
    final bool isToday = f.tanggal.year == now.year &&
                         f.tanggal.month == now.month &&
                         f.tanggal.day == now.day;
    final bool isUpcoming = f.tanggal.isAfter(now) && !isToday;

    String statusText;
    Color statusColor;

    if (isToday) {
      statusText = "LIVE / TODAY";
      statusColor = const Color(0xFFEF4444);
    } else if (isUpcoming) {
      statusText = "UPCOMING";
      statusColor = const Color(0xFF22C55E);
    } else {
      statusText = "FINISHED";
      statusColor = const Color(0xFF64748B);
    }

    final String homeScore = (f.skorHome == null) ? "_" : f.skorHome.toString();
    final String awayScore = (f.skorAway == null) ? "_" : f.skorAway.toString();
    
    return Scaffold(
      backgroundColor: AppColors.indigo,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80, // Biar lebih lega di atas
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.lime, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Event Details",
          style: TextStyle(
            fontFamily: "Geologica",
            color: AppColors.lime,
            fontSize: 32, // Ukuran disesuaikan untuk AppBar
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
          ),
        ),
        centerTitle: false, // Judul nempel ke kiri samping tombol back
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // CARD CONTENT
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
                          if (isToday) ...[
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
                        teamLogo(f.timHome, size: 72),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            "${f.timHome} VS ${f.timAway}",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis, // 🔑
                            maxLines: 1,
                            style: const TextStyle(
                              fontFamily: "Geologica",
                              color: AppColors.indigo,
                              fontSize: 28, // 🔽 sedikit diturunin
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.5,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        teamLogo(f.timAway, size: 72),
                      ],
                    ),

                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_month, color: AppColors.indigo, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          isToday ? "Today" : "${f.tanggal.day}/${f.tanggal.month}/${f.tanggal.year}",
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isAdmin && isOwner)
                          Expanded(
                            child: Column(
                              children: [
                                _buildActionButton(
                                  text: "Edit Event",
                                  color: const Color(0xFFFACC15),
                                  textColor: AppColors.indigo,
                                  onTap: () async {
                                    final refresh = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EventFormPage(event: event)),
                                    );
                                    if (refresh == true) Navigator.pop(context, true);
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
                        
                        if (!(isAdmin && isOwner)) const Spacer(),

                        const SizedBox(width: 12),

                        // Tombol Chat (Sekarang bulat sempurna dan pakai Asset Image)
                        GestureDetector(
                          onTap: () { /* TODO: Comment page */ },
                          child: Container(
                            width: 70, 
                            height: 70,
                            decoration: const BoxDecoration(
                              color: AppColors.lime, 
                              shape: BoxShape.circle, // Bulat sempurna seperti desain Player
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/comment.png', 
                                width: 32, 
                                height: 32,
                                color: AppColors.indigo,
                                errorBuilder: (context, error, stackTrace) => 
                                    const Icon(Icons.chat_bubble_outline, color: AppColors.indigo),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  // --- UI Helpers dengan Font Geologica Tebal & Rapet ---
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
          if (homeWins) 
            const Text("🏆 ", style: TextStyle(fontSize: 20)),

          Text(
            home, 
            style: TextStyle(
              fontFamily: "Geologica", 
              color: AppColors.indigo, 
              fontSize: 22, 
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
            )
          ),
          
          const Text(
            " - ", 
            style: TextStyle(
              fontFamily: "Geologica", 
              color: AppColors.indigo, 
              fontSize: 22, 
              fontWeight: FontWeight.w900
            )
          ),
          
          Text(
            away, 
            style: TextStyle(
              fontFamily: "Geologica", 
              color: AppColors.indigo, 
              fontSize: 22, 
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
            )
          ),

          // 🏆 Piala untuk Away
          if (awayWins) 
            const Text(" 🏆", style: TextStyle(fontSize: 20)),
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
  Widget teamLogo(String teamName, {double size = 40}) {
    final filename = "${logoFromTeam(teamName)}.png";
    final url = "http://127.0.0.1:8000/events/logos/$filename/";

    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.shield,
        size: size,
        color: AppColors.indigo,
      ),
    );
  }
}
String logoFromTeam(String name) {
      return name
          .toLowerCase()
          .replaceAll("&", "")
          .replaceAll(RegExp(r'[^a-z0-9 ]'), "")
          .trim()
          .replaceAll(" ", "_");
}
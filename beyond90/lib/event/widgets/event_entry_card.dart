import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';
import 'package:beyond90/event/screens/event_detail.dart';
import 'package:beyond90/event/service/event_service.dart';
import 'package:beyond90/app_colors.dart';

class EventEntryCard extends StatelessWidget {
  final EventEntry event;
  final VoidCallback onTap;

  const EventEntryCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fields = event.fields;
    
    // 🔥 PANGGIL LOGIC DARI SERVICE
    final String status = EventService.getEventStatus(fields.tanggal);

    Color statusColor;
    String displayStatus;

    switch (status) {
      case "LIVE":
        displayStatus = "LIVE / TODAY";
        statusColor = const Color(0xFFEF4444);
        break;
      case "UPCOMING":
        displayStatus = "UPCOMING";
        statusColor = const Color(0xFF22C55E);
        break;
      default:
        displayStatus = "FINISHED";
        statusColor = const Color(0xFF64748B);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. STATUS BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dot merah berkedip (opsional) atau dot biasa jika LIVE
                  if (status == "LIVE") ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    displayStatus,
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. MATCH TITLE
            SizedBox(
              height: 42, // KUNCI TINGGI
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  teamLogo(fields.timHome, size: 34),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "${fields.timHome} VS ${fields.timAway}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Geologica',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.indigo,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  teamLogo(fields.timAway, size: 34),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // 3. DATE INFO
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 12, color: AppColors.indigo),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    status == "LIVE"
                        ? "Today"
                        : "${fields.tanggal.day}/${fields.tanggal.month}/${fields.tanggal.year}",
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      fontSize: 12,
                      color: AppColors.indigo.withOpacity(0.8),
                      fontWeight: status == "LIVE" ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 4. DETAILS BUTTON
            SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, // 🔥 WAJIB
                  minimumSize: Size.zero,   // 🔥 WAJIB
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 🔥 WAJIB
                  backgroundColor: AppColors.lime,
                  foregroundColor: AppColors.indigo,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onTap,
                child: const Text(
                  'Details',
                  style: TextStyle(
                    fontFamily: 'Geologica',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          ],
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
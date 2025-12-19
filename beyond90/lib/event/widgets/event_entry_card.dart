import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';
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
    
    // 🔥 LOGIC 3 STATUS (LIVE/TODAY, UPCOMING, FINISHED)
    final now = DateTime.now();
    final bool isToday = fields.tanggal.year == now.year &&
                         fields.tanggal.month == now.month &&
                         fields.tanggal.day == now.day;
    
    final bool isUpcoming = fields.tanggal.isAfter(now) && !isToday;

    String statusText;
    Color statusColor;

    if (isToday) {
      statusText = "LIVE / TODAY";
      statusColor = const Color(0xFFEF4444); // Merah Terang
    } else if (isUpcoming) {
      statusText = "UPCOMING";
      statusColor = const Color(0xFF22C55E); // Hijau
    } else {
      statusText = "FINISHED";
      statusColor = const Color(0xFF64748B); // Abu-abu
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
        child: ClipRect(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. STATUS LABEL (With indicator for Live)
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
                    if (isToday) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      statusText,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),

              // 2. TITLE
              Text(
                "${fields.timHome} vs ${fields.timAway}".toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.indigo,
                ),
              ),

              const SizedBox(height: 4),

              // 3. DATE
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 12, color: AppColors.indigo),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isToday ? "Today" : "${fields.tanggal.day}/${fields.tanggal.month}/${fields.tanggal.year}",
                      style: TextStyle(
                        fontSize: 12, 
                        color: AppColors.indigo,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 4. BUTTON
              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  AppColors.lime,
                    foregroundColor: AppColors.indigo,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: onTap,
                  child: const Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
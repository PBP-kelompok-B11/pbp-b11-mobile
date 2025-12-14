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
          mainAxisSize: MainAxisSize.min, // 🔥 INI KUNCI UTAMA
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TITLE =================
            Text(
              "${fields.timHome} vs ${fields.timAway}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.indigo,
              ),
            ),

            const SizedBox(height: 6),

            // ================= DATE =================
            Row(
              children: [
                Image.asset(
                  'assets/icons/calendar.png',
                  width: 14,
                  height: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  "${fields.tanggal.day}/"
                  "${fields.tanggal.month}/"
                  "${fields.tanggal.year}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.indigo,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================= BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lime,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: onTap,
                child: const Text(
                  'Details',
                  style: TextStyle(
                    color: AppColors.indigo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

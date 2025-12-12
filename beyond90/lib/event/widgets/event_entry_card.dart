import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';

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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =============================
                // NAMA EVENT
                // =============================
                Text(
                  fields.namaEvent,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // =============================
                // LOKASI
                // =============================
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 6),
                    Text(fields.lokasi),
                  ],
                ),

                const SizedBox(height: 6),

                // =============================
                // TANGGAL
                // =============================
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "${fields.tanggal.year}-${fields.tanggal.month.toString().padLeft(2, '0')}-${fields.tanggal.day.toString().padLeft(2, '0')}",
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 10),

                // =============================
                // MATCHUP
                // =============================
                Text(
                  "${fields.timHome} vs ${fields.timAway}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                // =============================
                // SKOR
                // =============================
                Text(
                  "${fields.skorHome} : ${fields.skorAway}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // =============================
                // CREATED BY (optional)
                // =============================
                if (fields.createdBy != null)
                  Text(
                    "Dibuat oleh: ${fields.createdBy}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

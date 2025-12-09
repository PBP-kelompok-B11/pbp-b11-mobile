import 'package:flutter/material.dart';
import 'package:beyond90/event/models/event_entry.dart';

class EventDetailPage extends StatelessWidget {
  final EventEntry event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final f = event.fields;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Event'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // ============================
              //  NAMA EVENT
              // ============================
              Text(
                f.namaEvent,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // ============================
              //  LOKASI & TANGGAL
              // ============================
              Row(
                children: [
                  const Icon(Icons.location_on, size: 20, color: Colors.indigo),
                  const SizedBox(width: 4),
                  Text(
                    f.lokasi,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.indigo),
                  const SizedBox(width: 6),
                  Text(
                    "${f.tanggal.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const Divider(height: 32, thickness: 1),

              // ============================
              //  PERTANDINGAN
              // ============================
              Center(
                child: Column(
                  children: [
                    Text(
                      "${f.timHome} vs ${f.timAway}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Skor
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${f.skorHome} : ${f.skorAway}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ============================
              //  DIBUAT OLEH?
              // ============================
              if (f.createdBy != null)
                Row(
                  children: [
                    const Icon(Icons.person, size: 20, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "Dibuat oleh: ${f.createdBy}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

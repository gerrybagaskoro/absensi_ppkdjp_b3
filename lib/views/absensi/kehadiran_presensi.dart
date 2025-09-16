// lib/views/kehadiran/kehadiran_presensi.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KehadiranPresensi extends StatelessWidget {
  KehadiranPresensi({super.key});

  // Dummy data daftar kehadiran
  final List<Map<String, dynamic>> _kehadiranList = [
    {
      "nama": "Gerry Bagaskoro Putro",
      "tanggal": DateTime(2025, 9, 16),
      "masuk": "08:05",
      "pulang": "16:00",
      "status": "Hadir",
    },
    {
      "nama": "Gerry Bagaskoro Putro",
      "tanggal": DateTime(2025, 9, 17),
      "masuk": "08:30",
      "pulang": "16:00",
      "status": "Telat",
    },
    {
      "nama": "Gerry Bagaskoro Putro",
      "tanggal": DateTime(2025, 9, 18),
      "masuk": "-",
      "pulang": "-",
      "status": "Izin",
    },
    {
      "nama": "Gerry Bagaskoro Putro",
      "tanggal": DateTime(2025, 9, 19),
      "masuk": "-",
      "pulang": "-",
      "status": "Alpha",
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "Hadir":
        return Colors.green;
      case "Telat":
        return Colors.orange;
      case "Izin":
        return Colors.blue;
      case "Alpha":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _kehadiranList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _kehadiranList[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(item["status"]),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                item["nama"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    DateFormat(
                      'EEEE, dd MMMM yyyy',
                      'id_ID',
                    ).format(item["tanggal"]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Masuk: ${item["masuk"]}"),
                      Text("Pulang: ${item["pulang"]}"),
                    ],
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(item["status"]).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(item["status"]).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  item["status"],
                  style: TextStyle(
                    color: _getStatusColor(item["status"]),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

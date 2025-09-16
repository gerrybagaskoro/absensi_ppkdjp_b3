// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPresensi extends StatelessWidget {
  HistoryPresensi({super.key});

  // Dummy data
  final List<Map<String, dynamic>> _riwayat = [
    {
      "tanggal": DateTime(2025, 9, 10),
      "masuk": "08:00",
      "pulang": "16:00",
      "status": "Hadir",
    },
    {
      "tanggal": DateTime(2025, 9, 9),
      "masuk": "08:30",
      "pulang": "16:00",
      "status": "Telat",
    },
    {
      "tanggal": DateTime(2025, 9, 8),
      "masuk": "-",
      "pulang": "-",
      "status": "Izin",
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
      // appBar: AppBar(
      //   title: const Text(
      //     "Riwayat Presensi",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Colors.orange[700],
      // ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _riwayat.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _riwayat[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                DateFormat(
                  'EEEE, dd MMMM yyyy',
                  'id_ID',
                ).format(item["tanggal"]),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Masuk: ${item["masuk"]}"),
                    Text("Pulang: ${item["pulang"]}"),
                  ],
                ),
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

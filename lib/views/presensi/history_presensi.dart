// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPresensi extends StatefulWidget {
  const HistoryPresensi({super.key});

  @override
  State<HistoryPresensi> createState() => _HistoryPresensiState();
}

class _HistoryPresensiState extends State<HistoryPresensi> {
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

  DateTimeRange? _selectedRange;

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

  Future<void> _pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(now.year + 1),
      initialDateRange:
          _selectedRange ??
          DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
      locale: const Locale("id", "ID"),
    );

    if (picked != null) {
      setState(() {
        _selectedRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // filter data sesuai range jika dipilih
    final List<Map<String, dynamic>> filteredRiwayat = _selectedRange == null
        ? _riwayat
        : _riwayat.where((item) {
            final DateTime tgl = item["tanggal"];
            return tgl.isAfter(
                  _selectedRange!.start.subtract(const Duration(days: 1)),
                ) &&
                tgl.isBefore(_selectedRange!.end.add(const Duration(days: 1)));
          }).toList();

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedRange == null
                      ? "Semua Tanggal"
                      : "${DateFormat('dd MMM yyyy', 'id_ID').format(_selectedRange!.start)} - "
                            "${DateFormat('dd MMM yyyy', 'id_ID').format(_selectedRange!.end)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _pickDateRange,
                  icon: const Icon(Icons.date_range, color: Colors.orange),
                  label: const Text("Pilih Tanggal"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                    foregroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Daftar riwayat
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredRiwayat.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = filteredRiwayat[index];
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
                          color: _getStatusColor(
                            item["status"],
                          ).withOpacity(0.3),
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
          ),
        ],
      ),
    );
  }
}

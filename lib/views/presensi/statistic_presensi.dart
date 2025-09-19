// lib/views/presensi/absen_stats_screen.dart
import 'package:absensi_ppkdjp_b3/api/statistic_presensi.dart';
import 'package:absensi_ppkdjp_b3/model/presensi/statistic_presensi.dart';
import 'package:flutter/material.dart';

class StatisticPresensi extends StatefulWidget {
  const StatisticPresensi({super.key});

  @override
  State<StatisticPresensi> createState() => _StatisticPresensiState();
}

class _StatisticPresensiState extends State<StatisticPresensi> {
  AbsenStats? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    setState(() => isLoading = true);
    final result = await AbsenStatsAPI.fetchAbsenStats(
      start: '2000-01-01', // tanggal awal sangat jauh
      end: '2100-12-31', // tanggal akhir sangat jauh
    );
    setState(() {
      stats = result;
      isLoading = false;
    });
  }

  Widget buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Presensi')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stats == null
          ? const Center(child: Text('Gagal memuat data'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                children: [
                  buildStatCard(
                    'Total Absen',
                    '${stats!.totalAbsen}',
                    Icons.event_available,
                    Colors.blue,
                  ),
                  buildStatCard(
                    'Total Masuk',
                    '${stats!.totalMasuk}',
                    Icons.login,
                    Colors.green,
                  ),
                  buildStatCard(
                    'Total Izin',
                    '${stats!.totalIzin}',
                    Icons.assignment_late,
                    Colors.orange,
                  ),
                  buildStatCard(
                    'Sudah Absen Hari Ini',
                    stats!.sudahAbsenHariIni ? 'Ya' : 'Belum',
                    stats!.sudahAbsenHariIni
                        ? Icons.check_circle
                        : Icons.cancel,
                    stats!.sudahAbsenHariIni ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
    );
  }
}

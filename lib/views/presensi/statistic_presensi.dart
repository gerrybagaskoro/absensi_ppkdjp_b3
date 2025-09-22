import 'package:absensi_ppkdjp_b3/api/statistic_presensi.dart';
import 'package:absensi_ppkdjp_b3/model/presensi/statistic_presensi.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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

    // Delay 1 detik supaya shimmer muncul dulu
    await Future.delayed(const Duration(seconds: 1));

    final result = await AbsenStatsAPI.fetchAbsenStats(
      start: '2000-01-01',
      end: '2100-12-31',
    );
    setState(() {
      stats = result;
      isLoading = false;
    });
  }

  Widget buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    int delay = 0,
  }) {
    final cardContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: delay),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 40, height: 40, color: Colors.white),
                      const SizedBox(height: 12),
                      Container(width: 60, height: 22, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(width: 80, height: 14, color: Colors.white),
                    ],
                  ),
                )
              : cardContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Presensi'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              stats != null ? '${stats!.totalAbsen}' : '0',
              Icons.event_available,
              Colors.blueAccent.shade400,
              delay: 100,
            ),
            buildStatCard(
              'Total Masuk',
              stats != null ? '${stats!.totalMasuk}' : '0',
              Icons.login,
              Colors.greenAccent.shade400,
              delay: 200,
            ),
            buildStatCard(
              'Total Izin',
              stats != null ? '${stats!.totalIzin}' : '0',
              Icons.assignment_late,
              Colors.orangeAccent.shade400,
              delay: 300,
            ),
            buildStatCard(
              'Absen Hari Ini',
              stats != null ? (stats!.sudahAbsenHariIni ? 'Ya' : 'Belum') : '-',
              stats != null
                  ? (stats!.sudahAbsenHariIni
                        ? Icons.check_circle
                        : Icons.cancel)
                  : Icons.hourglass_empty,
              stats != null
                  ? (stats!.sudahAbsenHariIni ? Colors.green : Colors.redAccent)
                  : Colors.grey,
              delay: 400,
            ),
          ],
        ),
      ),
    );
  }
}

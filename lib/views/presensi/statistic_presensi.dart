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

    // Delay shimmer muncul dulu
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
    final theme = Theme.of(context);

    final cardContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: delay),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
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
        surfaceTintColor: theme.colorScheme.primary,
        elevation: 1,
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
              theme.colorScheme.primary,
              delay: 100,
            ),
            buildStatCard(
              'Total Masuk',
              stats != null ? '${stats!.totalMasuk}' : '0',
              Icons.login,
              theme.colorScheme.secondary,
              delay: 200,
            ),
            buildStatCard(
              'Total Izin',
              stats != null ? '${stats!.totalIzin}' : '0',
              Icons.assignment_late,
              theme.colorScheme.tertiary,
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
                  ? (stats!.sudahAbsenHariIni
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error)
                  : theme.colorScheme.outline,
              delay: 400,
            ),
          ],
        ),
      ),
    );
  }
}

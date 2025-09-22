// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:absensi_ppkdjp_b3/api/absen_api.dart';
import 'package:absensi_ppkdjp_b3/model/auth/absen_today.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/history_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/izin_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/statistic_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/profile/profile_presensi.dart';
import 'package:absensi_ppkdjp_b3/widgets/absensi/header_section.dart';
import 'package:absensi_ppkdjp_b3/widgets/absensi/location_card.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class DashboardPresensi extends StatefulWidget {
  static const String id = '/dashboard_presensi';
  const DashboardPresensi({super.key});

  @override
  State<DashboardPresensi> createState() => _DashboardPresensiState();
}

class _DashboardPresensiState extends State<DashboardPresensi> {
  int _selectedIndex = 0;
  AbsenTodayData? _absenToday;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayAbsen();
  }

  Future<void> _loadTodayAbsen() async {
    setState(() => _loading = true);

    // beri delay 1 detik supaya animasi loading terasa
    await Future.delayed(const Duration(seconds: 1));

    final result = await AbsenAPI.getToday();
    setState(() {
      _absenToday = result?.data;
      _loading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> pages = [
      _buildDashboardPage(),
      const HistoryPresensi(),
      const StatisticPresensi(),
      const IzinPresensi(),
      const ProfilePresensi(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Presensi Kita',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: "Statistik",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Izin"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildDashboardPage() {
    return RefreshIndicator(
      onRefresh: _loadTodayAbsen,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            FadeInDown(child: const HeaderSection()),
            const SizedBox(height: 12),
            // Location Card
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: const LocationCard(),
            ),
            const SizedBox(height: 16),
            // Today Status Card
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: _buildTodayStatusCard(),
            ),
            const SizedBox(height: 24),
            // Absensi Buttons
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: _buildAbsensiButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStatusCard() {
    final theme = Theme.of(context);
    final status = _absenToday?.status?.toLowerCase() ?? "belum absen";
    Color statusColor;
    switch (status) {
      case "hadir":
      case "masuk":
        statusColor = Colors.green;
        break;
      case "telat":
      case "izin":
        statusColor = Colors.orange;
        break;
      case "alpha":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status Absen Hari Ini',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _absenToday?.status ?? "Belum Absen",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Check Tiles
          Row(
            children: [
              Expanded(
                child: _buildCheckTile(
                  label: "Masuk",
                  time: _absenToday?.checkInTime,
                  color: Colors.green,
                  icon: Icons.login,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCheckTile(
                  label: "Pulang",
                  time: _absenToday?.checkOutTime,
                  color: Colors.red,
                  icon: Icons.logout,
                ),
              ),
            ],
          ),
          // Alasan Izin
          if (_absenToday?.alasanIzin != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "Alasan Izin: ${_absenToday!.alasanIzin}",
                style: theme.textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckTile({
    required String label,
    required String? time,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final bool done = time != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: done ? color.withOpacity(0.1) : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: done ? color.withOpacity(0.2) : theme.dividerColor,
            child: Icon(icon, color: done ? color : theme.iconTheme.color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: done ? color : theme.textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              done ? time : "--:--",
              key: ValueKey(time),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsensiButtons() {
    final theme = Theme.of(context);
    return ValueListenableBuilder<double>(
      valueListenable: LocationCardStateNotifier.distanceNotifier,
      builder: (context, distance, _) {
        final status = _absenToday?.status?.toLowerCase();

        if (status == "izin") {
          return Center(
            child: Text(
              "📌 Anda sedang izin hari ini",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          );
        }

        if (distance > 50) {
          String distText = distance < 1000
              ? "${distance.toStringAsFixed(0)} m"
              : "${(distance / 1000).toStringAsFixed(2)} km";

          return Center(
            child: Text(
              "⚠️ Anda jauh dari lokasi PPKDJP (Jarak: $distText)",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (_absenToday == null || _absenToday?.checkInTime == null) {
          return _buildAbsenButton(
            'Absen Masuk',
            Icons.login,
            theme.primaryColor,
            _handleCheckIn,
          );
        } else if (_absenToday?.checkOutTime == null) {
          return _buildAbsenButton(
            'Absen Pulang',
            Icons.logout,
            Colors.green[700]!,
            _handleCheckOut,
          );
        } else {
          return Center(
            child: Text(
              "✅ Anda sudah absen masuk & pulang hari ini",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAbsenButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(colors: [color.withOpacity(0.9), color]),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          splashColor: Colors.white24,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// === HANDLER CHECKIN & CHECKOUT ===
  Future<void> _handleCheckIn() async {
    if (LocationCardState.lastLat == null ||
        LocationCardState.lastLng == null ||
        LocationCardState.lastAddress == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lokasi belum tersedia")));
      return;
    }

    final now = DateTime.now();
    final tanggal =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final jam =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    try {
      final response = await AbsenAPI.checkIn(
        attendanceDate: tanggal,
        checkIn: jam,
        lat: LocationCardState.lastLat!,
        lng: LocationCardState.lastLng!,
        address: LocationCardState.lastAddress!,
      );

      if (response?.data != null) {
        setState(() {
          _absenToday = AbsenTodayData(
            attendanceDate: tanggal,
            checkInTime: response!.data!.checkInTime,
            checkOutTime: _absenToday?.checkOutTime,
            status: response.data!.status,
            checkInAddress: LocationCardState.lastAddress!,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?.message ?? "Absen masuk berhasil")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?.message ?? "Gagal absen masuk")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi error saat absen: $e")));
    }
  }

  Future<void> _handleCheckOut() async {
    if (LocationCardState.lastLat == null ||
        LocationCardState.lastLng == null ||
        LocationCardState.lastAddress == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lokasi belum tersedia")));
      return;
    }

    final now = DateTime.now();
    final tanggal =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final jam =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    try {
      final response = await AbsenAPI.checkOut(
        attendanceDate: tanggal,
        checkOut: jam,
        lat: LocationCardState.lastLat!,
        lng: LocationCardState.lastLng!,
        address: LocationCardState.lastAddress!,
      );

      if (response?.data != null) {
        setState(() {
          _absenToday = AbsenTodayData(
            attendanceDate: tanggal,
            checkInTime: _absenToday?.checkInTime,
            checkOutTime: response!.data!.checkOutTime,
            status: response.data!.status,
            checkOutAddress: LocationCardState.lastAddress!,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?.message ?? "Absen pulang berhasil")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?.message ?? "Gagal absen pulang")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi error saat absen: $e")));
    }
  }
}

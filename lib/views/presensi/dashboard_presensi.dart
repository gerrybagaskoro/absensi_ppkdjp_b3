// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:absensi_ppkdjp_b3/api/absen_api.dart';
import 'package:absensi_ppkdjp_b3/model/auth/absen_today.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/history_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/izin_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/kehadiran_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/profile/profile_presensi.dart';
import 'package:absensi_ppkdjp_b3/widgets/absensi/header_section.dart';
import 'package:absensi_ppkdjp_b3/widgets/absensi/location_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardPresensi extends StatefulWidget {
  const DashboardPresensi({super.key});

  @override
  State<DashboardPresensi> createState() => _DashboardPresensiState();
}

class _DashboardPresensiState extends State<DashboardPresensi> {
  int _selectedIndex = 0;

  final String _userName = "Gerry Bagaskoro Putro";
  String _statusAbsen = "Belum Absen";
  String _jamMasuk = "--:--";
  String _jamPulang = "--:--";

  AbsenTodayData? _absenToday; // <-- simpan status hari ini

  final Map<String, int> _stats = {
    'Hadir': 20,
    'Izin': 2,
    'Telat': 1,
    'Alpha': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadTodayAbsen(); // cek status absen saat halaman dibuka
  }

  Future<void> _loadTodayAbsen() async {
    final result = await AbsenAPI.getToday();
    if (result != null && result.data != null) {
      setState(() {
        _absenToday = result.data;
        _statusAbsen = _absenToday?.status ?? "Belum Absen";
        _jamMasuk = _absenToday?.checkInTime ?? "--:--";
        _jamPulang = _absenToday?.checkOutTime ?? "--:--";
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardPage(),
      HistoryPresensi(),
      KehadiranPresensi(),
      IzinPresensi(),
      ProfilePresensi(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Presensi Kita',
          style: TextStyle(color: Colors.white),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[700],
        elevation: 0,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange[700],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: "Kehadiran",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Izin"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  /// === PAGE DASHBOARD ===
  Widget _buildDashboardPage() {
    return RefreshIndicator(
      // bisa tarik buat refresh absen hari ini
      onRefresh: _loadTodayAbsen,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(),
            const SizedBox(height: 8),
            LocationCard(),
            const SizedBox(height: 8),
            _buildTodayStatusCard(),
            const SizedBox(height: 12),
            _buildAbsensiButtons(),
            const SizedBox(height: 8),
            _buildStatsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStatusCard() {
    Color statusColor;

    switch (_statusAbsen) {
      case "Hadir":
        statusColor = Colors.green;
        break;
      case "Telat":
        statusColor = Colors.orange;
        break;
      case "Belum Absen":
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Status Hari Ini',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                _statusAbsen,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeInfo('Masuk', _jamMasuk),
                _buildTimeInfo('Pulang', _jamPulang),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsensiButtons() {
    // logika tombol
    if (_absenToday == null || _absenToday?.checkInTime == null) {
      // Belum absen masuk
      return _buildAbsenButton(
        'Absen Masuk',
        Icons.login,
        Colors.orange[700]!,
        () {
          if (LocationCardState.lastLat != null &&
              LocationCardState.lastLng != null &&
              LocationCardState.lastAddress != null) {
            _absenMasuk(
              LocationCardState.lastLat!,
              LocationCardState.lastLng!,
              LocationCardState.lastAddress!,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Lokasi belum tersedia")),
            );
          }
        },
      );
    } else if (_absenToday?.checkOutTime == null) {
      // Sudah masuk, belum pulang
      return _buildAbsenButton(
        'Absen Pulang',
        Icons.logout,
        Colors.green[700]!,
        () {
          if (LocationCardState.lastLat != null &&
              LocationCardState.lastLng != null &&
              LocationCardState.lastAddress != null) {
            _absenPulang(
              LocationCardState.lastLat!,
              LocationCardState.lastLng!,
              LocationCardState.lastAddress!,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Lokasi belum tersedia")),
            );
          }
        },
      );
    } else {
      // Sudah masuk dan pulang
      return const Center(
        child: Text(
          "✅ Anda sudah absen masuk & pulang hari ini",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );
    }
  }

  Widget _buildAbsenButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistik Presensi $_userName',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2,
          children: [
            _buildStatCard('Hadir', _stats['Hadir']!, Colors.green),
            _buildStatCard('Izin', _stats['Izin']!, Colors.orange),
            _buildStatCard('Telat', _stats['Telat']!, Colors.orange),
            _buildStatCard('Alpha', _stats['Alpha']!, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// === ABSEN API ===
  Future<void> _absenMasuk(double lat, double lng, String address) async {
    final now = DateTime.now();
    final tanggal = DateFormat('yyyy-MM-dd').format(now);
    final jam = DateFormat('HH:mm').format(now);

    final response = await AbsenAPI.checkIn(
      attendanceDate: tanggal,
      checkIn: jam,
      lat: lat,
      lng: lng,
      address: address,
    );

    if (response != null && response.data != null) {
      setState(() {
        _statusAbsen = response.data!.status ?? "Hadir";
        _jamMasuk = response.data!.checkInTime ?? jam;
        _absenToday?.checkInTime = response.data!.checkInTime;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Absen masuk berhasil")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal absen masuk")));
    }
  }

  Future<void> _absenPulang(double lat, double lng, String address) async {
    final now = DateTime.now();
    final tanggal = DateFormat('yyyy-MM-dd').format(now);
    final jam = DateFormat('HH:mm').format(now);

    final response = await AbsenAPI.checkOut(
      attendanceDate: tanggal,
      checkOut: jam,
      lat: lat,
      lng: lng,
      address: address,
    );

    if (response != null && response.data != null) {
      setState(() {
        _jamPulang = response.data!.checkOutTime ?? jam;
        _absenToday?.checkOutTime = response.data!.checkOutTime;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Absen pulang berhasil")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal absen pulang")));
    }
  }
}

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:absensi_ppkdjp_b3/api/absen_api.dart';
import 'package:absensi_ppkdjp_b3/model/auth/absen_today.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/history_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/izin_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/statistic_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/profile/profile_presensi.dart';
import 'package:absensi_ppkdjp_b3/widgets/absensi/header_section.dart';
import 'package:absensi_ppkdjp_b3/widgets/absensi/location_card.dart';
import 'package:flutter/material.dart';

class DashboardPresensi extends StatefulWidget {
  const DashboardPresensi({super.key});

  @override
  State<DashboardPresensi> createState() => _DashboardPresensiState();
}

class _DashboardPresensiState extends State<DashboardPresensi> {
  int _selectedIndex = 0;

  AbsenTodayData? _absenToday;

  @override
  void initState() {
    super.initState();
    _loadTodayAbsen();
  }

  Future<void> _loadTodayAbsen() async {
    final result = await AbsenAPI.getToday();
    setState(() {
      _absenToday = result?.data; // langsung assign, bisa null
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardPage(),
      HistoryPresensi(),
      StatisticPresensi(),
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
            icon: Icon(Icons.pie_chart),
            label: "Statistik",
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
      onRefresh: _loadTodayAbsen,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            const SizedBox(height: 8),
            const LocationCard(),
            const SizedBox(height: 8),
            _buildTodayStatusCard(),
            const SizedBox(height: 12),
            _buildAbsensiButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStatusCard() {
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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Row Judul + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status Absen Hari Ini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    _absenToday?.status ?? "Belum Absen",
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Row Masuk & Pulang
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
            if (_absenToday?.alasanIzin != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  "Alasan Izin: ${_absenToday!.alasanIzin}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckTile({
    required String label,
    required String? time,
    required Color color,
    required IconData icon,
  }) {
    final bool done = time != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: done ? color.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: done ? color.withOpacity(0.3) : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: done ? color.withOpacity(0.2) : Colors.grey[300],
            radius: 20,
            child: Icon(icon, color: done ? color : Colors.grey, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: done ? color : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: ScaleTransition(scale: anim, child: child),
            ),
            child: Text(
              done ? time : "--:--",
              key: ValueKey(time),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsensiButtons() {
    final status = _absenToday?.status?.toLowerCase();

    // Jika status izin, tombol disembunyikan
    if (status == "izin") {
      return const Center(
        child: Text(
          "📌 Anda sedang izin hari ini",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        ),
      );
    }

    if (_absenToday == null || _absenToday?.checkInTime == null) {
      return _buildAbsenButton(
        'Absen Masuk',
        Icons.login,
        Colors.orange[700]!,
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

  /// === HANDLER CHECKIN / CHECKOUT MENGGUNAKAN TANGGAL DARI SERVER ===
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
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
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

      if (response != null && response.data != null) {
        setState(() {
          _absenToday = AbsenTodayData(
            attendanceDate: tanggal,
            checkInTime: response.data!.checkInTime,
            checkOutTime: _absenToday?.checkOutTime,
            status: response.data!.status,
            checkInAddress: LocationCardState.lastAddress!,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Absen masuk berhasil")),
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
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
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

      if (response != null && response.data != null) {
        setState(() {
          _absenToday = AbsenTodayData(
            attendanceDate: tanggal,
            checkInTime: _absenToday?.checkInTime,
            checkOutTime: response.data!.checkOutTime,
            status: response.data!.status,
            checkOutAddress: LocationCardState.lastAddress!,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Absen pulang berhasil")),
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

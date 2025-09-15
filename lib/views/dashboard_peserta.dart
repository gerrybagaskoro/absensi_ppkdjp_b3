// ignore_for_file: deprecated_member_use

import 'package:absensi_ppkdjp_b3/widgets/absensi/header_section.dart';
import 'package:absensi_ppkdjp_b3/widgets/absensi/location_card.dart';
import 'package:absensi_ppkdjp_b3/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardPeserta extends StatefulWidget {
  const DashboardPeserta({super.key});

  @override
  State<DashboardPeserta> createState() => _DashboardPesertaState();
}

class _DashboardPesertaState extends State<DashboardPeserta> {
  String _statusAbsen = "Belum Absen";
  String _jamMasuk = "--:--";
  String _jamPulang = "--:--";

  // Data statistik dummy
  final Map<String, int> _stats = {
    'Hadir': 20,
    'Izin': 2,
    'Telat': 1,
    'Alpha': 0,
  };

  // Controller untuk form izin
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alasanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Dashboard Absensi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(),
            const SizedBox(height: 24),

            LocationCard(),
            const SizedBox(height: 24),

            _buildTodayStatusCard(),
            const SizedBox(height: 24),

            _buildAbsensiButtons(),
            const SizedBox(height: 24),

            _buildStatsSection(),
            const SizedBox(height: 24),

            _buildIzinForm(), // ⬅️ Tambahan form izin
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange[700],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '© 2025 Presensi Kita. All rights reserved.',
            style: TextStyle(color: Colors.grey[200], fontSize: 14),
            textAlign: TextAlign.center,
          ),
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

  Widget _buildAbsensiButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildAbsenButton(
            'Absen Masuk',
            Icons.login,
            Colors.orange[700]!,
            () {
              _simulateAbsenMasuk();
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAbsenButton(
            'Absen Pulang',
            Icons.logout,
            Colors.green[700]!,
            () {
              _simulateAbsenPulang();
            },
          ),
        ),
      ],
    );
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

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik Absensi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildIzinForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Form Izin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                label: "Nama Lengkap",
                hint: "Masukkan nama Anda",
                icon: Icons.person,
                controller: _namaController,
                validator: (value) =>
                    value!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                label: "Alasan Izin",
                hint: "Tuliskan alasan izin...",
                icon: Icons.note,
                controller: _alasanController,
                validator: (value) =>
                    value!.isEmpty ? "Alasan tidak boleh kosong" : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    "Kirim Izin",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Izin dikirim oleh ${_namaController.text}",
                          ),
                        ),
                      );
                      _stats['Izin'] = _stats['Izin']! + 1;
                      setState(() {});
                      _namaController.clear();
                      _alasanController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Simulasi fungsi absen
  void _simulateAbsenMasuk() {
    setState(() {
      _statusAbsen = "Hadir";
      _jamMasuk = DateFormat('HH:mm').format(DateTime.now());

      _stats['Hadir'] = _stats['Hadir']! + 1;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Absen masuk berhasil!')));
  }

  void _simulateAbsenPulang() {
    setState(() {
      _jamPulang = DateFormat('HH:mm').format(DateTime.now());
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Absen pulang berhasil!')));
  }
}

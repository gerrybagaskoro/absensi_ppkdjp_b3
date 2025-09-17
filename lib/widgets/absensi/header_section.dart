import 'package:absensi_ppkdjp_b3/model/auth/get_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  Data? _profile;
  final String _userName = "Gerry Bagaskoro Putro";
  final DateTime _currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang Kembali,',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          _userName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          _profile?.name ?? "Tidak ada nama",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, dd MMMM yyyy').format(_currentDate),
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

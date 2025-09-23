import 'dart:async';

import 'package:absensi_ppkdjp_b3/api/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  String? _userName;
  DateTime _currentDateTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startClock();
    _loadProfile();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService.fetchProfile();
    if (profile?.data?.name != null) {
      setState(() {
        _userName = profile!.data!.name!;
      });
    } else {
      final cached = await ProfileService.getProfileFromCache();
      setState(() {
        _userName = cached?['name'] ?? "Pengguna";
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryTextColor = theme.brightness == Brightness.light
        ? Colors.black87
        : Colors.white;
    final secondaryTextColor = theme.brightness == Brightness.light
        ? Colors.grey[600]
        : Colors.white70;

    final formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(_currentDateTime);
    final formattedTime = DateFormat(
      'HH:mm:ss',
      'id_ID',
    ).format(_currentDateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selamat Datang + username tanpa marquee
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Selamat Datang, ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: primaryTextColor,
                ),
              ),
              TextSpan(
                text: _userName ?? "Memuat...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis, // kalau terlalu panjang, potong dengan ...
        ),
        const SizedBox(height: 4),
        // Tanggal + waktu
        Text(
          "$formattedDate | $formattedTime",
          style: TextStyle(fontSize: 16, color: secondaryTextColor),
        ),
      ],
    );
  }
}

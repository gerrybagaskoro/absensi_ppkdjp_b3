// HEADER SECTION
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
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _currentDateTime = DateTime.now());
    });
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService.fetchProfile();
    setState(() {
      _userName = profile?.data?.name ?? "Pengguna";
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        Row(
          children: [
            Text(
              "Selamat Datang, ",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: Text(
                _userName ?? "Memuat...",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "$formattedDate | $formattedTime",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class TimeInfoCard extends StatefulWidget {
  final String label;
  final String time;

  const TimeInfoCard({super.key, required this.label, required this.time});

  @override
  State<TimeInfoCard> createState() => _TimeInfoCardState();
}

class _TimeInfoCardState extends State<TimeInfoCard> {
  final String _jamMasuk = "--:--";
  final String _jamPulang = "--:--";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          widget.time,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:absensi_ppkdjp_b3/api/absen_api_history.dart';
import 'package:absensi_ppkdjp_b3/api/absen_delete.dart';
import 'package:absensi_ppkdjp_b3/model/presensi/history_absensi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class HistoryPresensi extends StatefulWidget {
  const HistoryPresensi({super.key});

  @override
  State<HistoryPresensi> createState() => _HistoryPresensiState();
}

class _HistoryPresensiState extends State<HistoryPresensi> {
  List<Datum> _riwayat = [];
  DateTimeRange? _selectedRange;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final history = await AbsenApiHistory.getHistory();
    setState(() {
      _riwayat = history?.data ?? [];
      _isLoading = false;
    });
  }

  /// Mapping status ke warna Material You
  (Color bg, Color fg) _getStatusStyle(String? status, BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (status?.toLowerCase()) {
      case "hadir":
      case "masuk":
        return (scheme.primaryContainer, scheme.onPrimaryContainer);
      case "telat":
        return (scheme.tertiaryContainer, scheme.onTertiaryContainer);
      case "izin":
        return (scheme.secondaryContainer, scheme.onSecondaryContainer);
      case "alpha":
        return (scheme.errorContainer, scheme.onErrorContainer);
      default:
        return (scheme.surfaceVariant, scheme.onSurfaceVariant);
    }
  }

  Future<void> _pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(now.year + 1),
      initialDateRange:
          _selectedRange ??
          DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
      locale: const Locale("id", "ID"),
    );

    if (picked != null) {
      setState(() => _selectedRange = picked);
    }
  }

  Map<String, List<Datum>> _groupByMonth(List<Datum> data) {
    final grouped = <String, List<Datum>>{};
    for (var item in data) {
      if (item.attendanceDate == null) continue;
      final key = DateFormat("MMMM yyyy", "id_ID").format(item.attendanceDate!);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }
    return grouped;
  }

  Future<void> _deletePresensi(Datum item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Presensi"),
        content: const Text("Apakah Anda yakin ingin menghapus presensi ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await AbsenApiDelete.deleteHistory(item.id.toString());
    if (success) {
      setState(() => _riwayat.remove(item));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Presensi berhasil dihapus")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menghapus presensi")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final List<Datum> filteredRiwayat = _selectedRange == null
        ? _riwayat
        : _riwayat.where((item) {
            final tgl = item.attendanceDate;
            if (tgl == null) return false;
            return (tgl.isAtSameMomentAs(_selectedRange!.start) ||
                    tgl.isAfter(_selectedRange!.start)) &&
                (tgl.isAtSameMomentAs(_selectedRange!.end) ||
                    tgl.isBefore(_selectedRange!.end));
          }).toList();

    final grouped = _groupByMonth(filteredRiwayat);
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat("MMMM yyyy", "id_ID").parse(a);
        final dateB = DateFormat("MMMM yyyy", "id_ID").parse(b);
        return dateB.compareTo(dateA); // terbaru duluan
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Presensi"),
        centerTitle: true,
        surfaceTintColor: scheme.primary,
      ),
      body: Column(
        children: [
          // Filter bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(16),
              color: scheme.surfaceContainerLowest,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedRange == null
                            ? "Semua Tanggal"
                            : "${DateFormat('dd MMM yyyy', 'id_ID').format(_selectedRange!.start)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(_selectedRange!.end)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: _pickDateRange,
                      icon: const Icon(Icons.date_range),
                      tooltip: "Pilih rentang tanggal",
                    ),
                    if (_selectedRange != null)
                      IconButton(
                        tooltip: "Reset filter",
                        onPressed: () {
                          setState(() => _selectedRange = null);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Filter tanggal direset"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRiwayat.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: scheme.outline),
                        const SizedBox(height: 12),
                        Text(
                          "Belum ada data presensi",
                          style: TextStyle(
                            fontSize: 16,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: sortedKeys.length,
                    itemBuilder: (context, index) {
                      final bulan = sortedKeys[index];
                      final items = grouped[bulan]!;
                      return StickyHeader(
                        header: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(12),
                            color: scheme.surfaceContainerHigh,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    bulan,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        content: Column(
                          children: [
                            ...items.map((item) {
                              final (bgColor, fgColor) = _getStatusStyle(
                                item.status,
                                context,
                              );

                              return Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  onLongPress: () => _deletePresensi(item),
                                  title: Text(
                                    DateFormat(
                                      'EEEE, dd MMM yyyy',
                                      'id_ID',
                                    ).format(
                                      item.attendanceDate ?? DateTime.now(),
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Masuk: ${item.checkInTime ?? "-"}",
                                        ),
                                        Text(
                                          "Pulang: ${item.checkOutTime ?? "-"}",
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Chip(
                                    label: Text(
                                      item.status ?? "-",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: fgColor,
                                      ),
                                    ),
                                    backgroundColor: bgColor,
                                    side: BorderSide.none,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

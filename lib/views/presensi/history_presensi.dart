// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:absensi_ppkdjp_b3/api/absen_api_history.dart';
import 'package:absensi_ppkdjp_b3/api/absen_delete.dart';
import 'package:absensi_ppkdjp_b3/l10n/app_localizations.dart';
import 'package:absensi_ppkdjp_b3/model/presensi/history_absensi.dart';
import 'package:absensi_ppkdjp_b3/utils/lottie_overlay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class HistoryPresensi extends StatefulWidget {
  const HistoryPresensi({super.key});

  @override
  State<HistoryPresensi> createState() => _HistoryPresensiState();
}

class _HistoryPresensiState extends State<HistoryPresensi>
    with TickerProviderStateMixin {
  List<Datum> _riwayat = [];
  DateTimeRange? _selectedRange;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _startBannerTimer();
  }

  late AnimationController _timerController; // For the progress bar
  late AnimationController _sizeController; // For the collapse animation
  late Animation<double> _sizeAnimation;

  void _startBannerTimer() {
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0, // Start fully visible
    );

    _sizeAnimation = CurvedAnimation(
      parent: _sizeController,
      curve: Curves.easeInOut,
    );

    // Start timer: value goes 1.0 -> 0.0
    _timerController.reverse(from: 1.0).then((_) {
      if (mounted) {
        _sizeController.reverse(); // Collapse after timer ends
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final history = await AbsenApiHistory.getHistory();
    setState(() {
      _riwayat = history?.data ?? [];
      _isLoading = false;
    });
  }

  /// Mapping status ke warna & label localized
  (Color bg, Color fg, String label) _getStatusStyle(
    String? status,
    BuildContext context,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final s = status?.toLowerCase() ?? "";

    if (s.contains("hadir") || s.contains("masuk")) {
      return (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        l10n.statusPresent,
      );
    } else if (s.contains("telat")) {
      return (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
        l10n.statusLate,
      );
    } else if (s.contains("izin")) {
      return (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
        l10n.statusPermission,
      );
    } else if (s.contains("alpha")) {
      return (
        scheme.errorContainer,
        scheme.onErrorContainer,
        l10n.statusAbsent,
      );
    } else {
      return (
        scheme.surfaceContainerHigh,
        scheme.onSurfaceVariant,
        status ?? "-",
      );
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
      locale: Localizations.localeOf(context),
    );

    if (picked != null) {
      setState(() => _selectedRange = picked);
    }
  }

  Map<String, List<Datum>> _groupByMonth(
    List<Datum> data,
    BuildContext context,
  ) {
    final grouped = <String, List<Datum>>{};
    final locale = Localizations.localeOf(context).toString();
    for (var item in data) {
      if (item.attendanceDate == null) continue;
      final key = DateFormat("MMMM yyyy", locale).format(item.attendanceDate!);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }
    return grouped;
  }

  Future<void> _deletePresensi(Datum item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAttendance),
        content: Text(AppLocalizations.of(context)!.deleteAttendanceConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await AbsenApiDelete.deleteHistory(item.id.toString());
    if (success) {
      setState(() => _riwayat.remove(item));

      // ✅ Ganti SnackBar → Lottie success
      showLottieOverlay(
        context,
        success: true,
        message: AppLocalizations.of(context)!.deleteSuccess,
      );
    } else {
      // ✅ Ganti SnackBar → Lottie failed
      showLottieOverlay(
        context,
        success: false,
        message: AppLocalizations.of(context)!.deleteFailed,
      );
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

    final localeStr = Localizations.localeOf(context).toString();
    final grouped = _groupByMonth(filteredRiwayat, context);
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat("MMMM yyyy", localeStr).parse(a);
        final dateB = DateFormat("MMMM yyyy", localeStr).parse(b);
        return dateB.compareTo(dateA); // terbaru duluan
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.historyTitle),
        centerTitle: true,
        surfaceTintColor: scheme.primary,
      ),
      body: Column(
        children: [
          // Ephemeral Banner with Countdown
          SizeTransition(
            sizeFactor: _sizeAnimation,
            axisAlignment: -1.0,
            child: Container(
              color: scheme.surfaceContainerLowest,
              child: Column(
                children: [
                  MaterialBanner(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    content: Text(
                      AppLocalizations.of(context)!.holdToDelete,
                      style: TextStyle(
                        fontSize: 14,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    leading: Icon(Icons.info_outline, color: scheme.primary),
                    actions: const [SizedBox.shrink()],
                    dividerColor: Colors.transparent,
                  ),
                  // Countdown Progress Bar
                  AnimatedBuilder(
                    animation: _timerController,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _timerController.value,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          scheme.primary.withOpacity(0.3),
                        ),
                        minHeight: 2,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
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
                            ? AppLocalizations.of(context)!.allDates
                            : "${DateFormat('dd MMM yyyy', localeStr).format(_selectedRange!.start)} - ${DateFormat('dd MMM yyyy', localeStr).format(_selectedRange!.end)}",
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
                      tooltip: AppLocalizations.of(context)!.pickDateRange,
                    ),
                    if (_selectedRange != null)
                      IconButton(
                        tooltip: AppLocalizations.of(context)!.resetFilter,
                        onPressed: () {
                          setState(() => _selectedRange = null);

                          // ✅ Ganti SnackBar → Lottie success
                          showLottieOverlay(
                            context,
                            success: true,
                            message: AppLocalizations.of(context)!.filterReset,
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
                          AppLocalizations.of(context)!.noHistory,
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
                              final (bgColor, fgColor, statusLabel) =
                                  _getStatusStyle(item.status, context);

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
                                      localeStr,
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
                                          "${AppLocalizations.of(context)!.entryTime}${item.checkInTime ?? "-"}",
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.exitTime}${item.checkOutTime ?? "-"}",
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Chip(
                                    label: Text(
                                      statusLabel,
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

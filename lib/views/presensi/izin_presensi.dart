// lib/views/presensi/izin_presensi.dart
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:absensi_ppkdjp_b3/api/absen_api_history.dart';
import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/model/presensi/izin_presensi.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class IzinPresensi extends StatefulWidget {
  const IzinPresensi({super.key});

  @override
  State<IzinPresensi> createState() => _IzinPresensiState();
}

class _IzinPresensiState extends State<IzinPresensi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alasanController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;
  bool _isLoadingList = false;

  List<Map<String, dynamic>> _izinList = [];

  @override
  void initState() {
    super.initState();
    _loadIzinList();
  }

  Future<void> _loadIzinList() async {
    setState(() => _isLoadingList = true);
    try {
      final history = await AbsenApiHistory.getHistory();
      final allData = history?.data ?? [];

      final izinData = allData
          .where((item) => item.status?.toLowerCase() == "izin")
          .map(
            (item) => {
              "date": item.attendanceDate?.toIso8601String(),
              "alasan_izin": item.alasanIzin ?? "-",
            },
          )
          .toList();

      setState(() => _izinList = izinData);
    } catch (e) {
      print("Error izin list: $e");
    } finally {
      setState(() => _isLoadingList = false);
    }
  }

  Future<void> _submitIzin() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      _showErrorOverlay("Lengkapi tanggal & alasan izin");
      return;
    }

    setState(() => _isLoading = true);
    _showLoadingOverlay();

    try {
      final token = await PreferenceHandler.getToken();
      if (token == null) return;

      final res = await http.post(
        Uri.parse(Endpoint.izin),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "date": DateFormat("yyyy-MM-dd").format(_selectedDate!),
          "alasan_izin": _alasanController.text.trim(),
        }),
      );

      Navigator.of(context).pop(); // tutup loading

      if (res.statusCode == 200) {
        final izin = izinPresensiFromJson(res.body);
        _showSuccessOverlay(izin.message ?? "Izin berhasil diajukan");

        setState(() {
          _selectedDate = null;
          _alasanController.clear();
        });

        _loadIzinList();
      } else {
        _showErrorOverlay("Gagal mengajukan izin");
      }
    } catch (e) {
      Navigator.of(context).pop(); // tutup loading
      _showErrorOverlay("Terjadi kesalahan");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Overlay Loading dengan dots
  void _showLoadingOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _LoadingDots(),
      ),
    );
  }

  void _showSuccessOverlay(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/animations/success.json", repeat: false),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _showErrorOverlay(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/animations/failed.json", repeat: false),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale("id", "ID"),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Izin Presensi"),
        centerTitle: true,
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Card Input =====
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: Card(
                  elevation: 1,
                  color: scheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: scheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Formulir Izin",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Tanggal
                        Text(
                          "Tanggal",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: scheme.primary),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDate == null
                                      ? "Pilih Tanggal"
                                      : DateFormat(
                                          "EEEE, dd MMM yyyy",
                                          "id_ID",
                                        ).format(_selectedDate!),
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? scheme.onSurfaceVariant
                                        : scheme.onSurface,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_month,
                                  color: scheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Alasan
                        Text(
                          "Alasan",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _alasanController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Tuliskan alasan izin",
                            filled: true,
                            fillColor: scheme.surfaceContainerHighest
                                .withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          validator: (val) => val == null || val.isEmpty
                              ? "Alasan wajib diisi"
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Submit
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isLoading ? null : _submitIzin,
                    icon: const Icon(Icons.send),
                    label: Text(_isLoading ? "Mengajukan..." : "Ajukan Izin"),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ===== Daftar Izin =====
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Text(
                  "Daftar Izin Saya",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              _isLoadingList
                  ? const Center(child: CircularProgressIndicator())
                  : _izinList.isEmpty
                  ? FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Belum ada data izin",
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _izinList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _izinList[index];
                        return FadeInUp(
                          duration: const Duration(milliseconds: 950),
                          child: Card(
                            elevation: 0,
                            color: scheme.surfaceContainerHighest.withOpacity(
                              0.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: scheme.primaryContainer,
                                child: Icon(
                                  Icons.event_note,
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                              title: Text(
                                DateFormat(
                                  "dd MMM yyyy",
                                  "id_ID",
                                ).format(DateTime.parse(item["date"])),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Alasan: ${item["alasan_izin"] ?? "-"}",
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget animasi titik loading
class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        int dots = _animation.value.floor() + 1;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sedang memuat",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Opacity(
                    opacity: i < dots ? 1 : 0.2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: scheme.primary,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

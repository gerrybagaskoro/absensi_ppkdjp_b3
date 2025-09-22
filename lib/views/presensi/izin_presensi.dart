// lib/views/presensi/izin_presensi.dart
// ignore_for_file: use_build_context_synchronously, avoid_print

// lib/views/presensi/izin_presensi.dart
import 'dart:convert';

import 'package:absensi_ppkdjp_b3/api/absen_api_history.dart';
import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/model/presensi/izin_presensi.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Lengkapi tanggal & alasan izin"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

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

      setState(() => _isLoading = false);

      if (res.statusCode == 200) {
        final izin = izinPresensiFromJson(res.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(izin.message ?? "Izin berhasil diajukan"),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        setState(() {
          _selectedDate = null;
          _alasanController.clear();
        });

        _loadIzinList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Gagal mengajukan izin"),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Terjadi kesalahan"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
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
              // ===== Card Input (Tanggal + Alasan) =====
              Card(
                elevation: 0,
                color: scheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: scheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tanggal
                      Row(
                        children: [
                          Icon(Icons.date_range, color: scheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            "Pilih Tanggal",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: scheme.onSurface,
                            ),
                          ),
                        ],
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? "Belum dipilih"
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
                                Icons.arrow_drop_down,
                                color: scheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Alasan Izin
                      Row(
                        children: [
                          Icon(Icons.note_alt, color: scheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            "Alasan Izin",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _alasanController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Tuliskan alasan izin",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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

              const SizedBox(height: 24),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _submitIzin,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isLoading ? "Mengajukan..." : "Ajukan Izin"),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),

              // ===== Daftar Izin =====
              Text(
                "Daftar Izin Saya",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),

              _isLoadingList
                  ? const Center(child: CircularProgressIndicator())
                  : _izinList.isEmpty
                  ? Text(
                      "Belum ada data izin",
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _izinList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _izinList[index];
                        return Card(
                          elevation: 0,
                          color: scheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: scheme.outlineVariant),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.event_note,
                              color: scheme.primary,
                            ),
                            title: Text(
                              DateFormat(
                                "dd MMM yyyy",
                                "id_ID",
                              ).format(DateTime.parse(item["date"])),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              "Alasan: ${item["alasan_izin"] ?? "-"}",
                              style: TextStyle(color: scheme.onSurfaceVariant),
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

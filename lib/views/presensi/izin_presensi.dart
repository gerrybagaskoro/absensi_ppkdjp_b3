// lib/views/presensi/izin_presensi.dart
// ignore_for_file: use_build_context_synchronously, avoid_print

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

      setState(() {
        _izinList = izinData;
      });
    } catch (e) {
      print("Error izin list: $e");
    } finally {
      setState(() => _isLoadingList = false);
    }
  }

  Future<void> _submitIzin() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi tanggal & alasan izin")),
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
          SnackBar(content: Text(izin.message ?? "Izin berhasil diajukan")),
        );

        setState(() {
          _selectedDate = null;
          _alasanController.clear();
        });

        _loadIzinList();
      } else {
        print("Gagal izin: ${res.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal mengajukan izin")));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error izin: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Terjadi kesalahan")));
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
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Ajukan Izin"),
      //   backgroundColor: Colors.orange,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== Card Input (Tanggal + Alasan) ======
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label tanggal dengan icon
                    Row(
                      children: const [
                        Icon(Icons.date_range, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          "Pilih Tanggal",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pilih tanggal
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
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
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Label alasan dengan icon
                    Row(
                      children: const [
                        Icon(Icons.note_alt, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          "Alasan Izin",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Alasan izin
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

              const SizedBox(height: 30),

              // Tombol submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitIzin,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isLoading ? "Mengajukan..." : "Ajukan Izin"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Divider(),

              // ====== Daftar izin ======
              const Text(
                "Daftar Izin Saya",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),

              _isLoadingList
                  ? const Center(child: CircularProgressIndicator())
                  : _izinList.isEmpty
                  ? const Text(
                      "Belum ada data izin",
                      style: TextStyle(color: Colors.black54),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _izinList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = _izinList[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.event_note,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat(
                                      "dd MMM yyyy",
                                      "id_ID",
                                    ).format(DateTime.parse(item["date"])),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Alasan: ${item["alasan_izin"] ?? "-"}",
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
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

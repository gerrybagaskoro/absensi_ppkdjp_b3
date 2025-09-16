// lib/views/izin/izin_presensi.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IzinPresensi extends StatefulWidget {
  const IzinPresensi({super.key});

  @override
  State<IzinPresensi> createState() => _IzinPresensiState();
}

class _IzinPresensiState extends State<IzinPresensi> {
  final _formKey = GlobalKey<FormState>();
  final _alasanController = TextEditingController();

  DateTime? _selectedDate;
  final List<Map<String, String>> _izinList = [];

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale("id", "ID"),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _tambahIzin() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      setState(() {
        _izinList.add({
          "tanggal": DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDate!),
          "alasan": _alasanController.text,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin berhasil ditambahkan")),
      );

      _alasanController.clear();
      _selectedDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// === FORM IZIN ===
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Form Izin",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// PILIH TANGGAL
                      InkWell(
                        onTap: _pilihTanggal,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: "Tanggal Izin",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? "Pilih tanggal"
                                : DateFormat(
                                    'EEEE, dd MMMM yyyy',
                                    'id_ID',
                                  ).format(_selectedDate!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// ALASAN
                      TextFormField(
                        controller: _alasanController,
                        decoration: const InputDecoration(
                          labelText: "Alasan Izin",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.note),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Alasan tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 24),

                      /// BUTTON KIRIM
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.send, color: Colors.white),
                          label: const Text(
                            "Kirim",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _tambahIzin,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// === LIST IZIN ===
            const Text(
              "Daftar Izin",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _izinList.isEmpty
                ? const Center(child: Text("Belum ada data izin"))
                : ListView.builder(
                    itemCount: _izinList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final izin = _izinList[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange[700],
                            child: const Icon(Icons.event, color: Colors.white),
                          ),
                          title: Text(izin["tanggal"] ?? ""),
                          subtitle: Text("Alasan: ${izin["alasan"]}"),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

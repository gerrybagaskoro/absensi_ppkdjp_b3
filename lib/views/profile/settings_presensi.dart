import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:flutter/material.dart';

class SettingsPresensi extends StatefulWidget {
  const SettingsPresensi({super.key});

  @override
  State<SettingsPresensi> createState() => _SettingsPresensiState();
}

class _SettingsPresensiState extends State<SettingsPresensi> {
  bool _darkMode = false;
  bool _notifikasi = true;
  String _bahasa = "Indonesia";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Tema
          SwitchListTile(
            value: _darkMode,
            activeColor: Colors.orange,
            title: const Text("Mode Gelap"),
            subtitle: const Text("Aktifkan tema gelap untuk aplikasi"),
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          const Divider(),

          // Notifikasi
          SwitchListTile(
            value: _notifikasi,
            activeColor: Colors.orange,
            title: const Text("Notifikasi"),
            subtitle: const Text("Terima notifikasi presensi"),
            onChanged: (value) {
              setState(() {
                _notifikasi = value;
              });
            },
          ),
          const Divider(),

          // Bahasa
          ListTile(
            leading: const Icon(Icons.language, color: Colors.orange),
            title: const Text("Bahasa"),
            subtitle: Text(_bahasa),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showBahasaDialog();
            },
          ),
          const Divider(),

          // Privasi
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.orange),
            title: const Text("Privasi & Keamanan"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fitur akan datang!")),
              );
            },
          ),
          const SizedBox(height: 30),

          // Tombol simpan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pengaturan berhasil disimpan!"),
                  ),
                );
                context.pop();
              },
              child: const Text(
                "Simpan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBahasaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Bahasa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text("Indonesia"),
                value: "Indonesia",
                groupValue: _bahasa,
                onChanged: (value) {
                  setState(() {
                    _bahasa = value!;
                  });
                  context.pop();
                },
              ),
              RadioListTile<String>(
                title: const Text("English"),
                value: "English",
                groupValue: _bahasa,
                onChanged: (value) {
                  setState(() {
                    _bahasa = value!;
                  });
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

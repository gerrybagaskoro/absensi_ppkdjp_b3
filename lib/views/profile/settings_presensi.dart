import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPresensi extends StatefulWidget {
  const SettingsPresensi({super.key});

  @override
  State<SettingsPresensi> createState() => _SettingsPresensiState();
}

class _SettingsPresensiState extends State<SettingsPresensi> {
  bool _notifikasi = true;
  String _bahasa = "Indonesia";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengaturan",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primaryContainer, // soft orange
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        surfaceTintColor: Colors.transparent, // hilangkan overlay M3
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 🔹 Pilihan Tema
          ListTile(
            leading: const Icon(Icons.color_lens, color: Colors.orange),
            title: const Text("Tema Aplikasi"),
            subtitle: Text(_getThemeText(themeProvider.themeMode)),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              underline: const SizedBox(),
              onChanged: (mode) {
                if (mode != null) {
                  themeProvider.setThemeMode(mode);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text("Mengikuti Sistem"),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text("Terang")),
                DropdownMenuItem(value: ThemeMode.dark, child: Text("Gelap")),
              ],
            ),
          ),
          const Divider(),

          // 🔹 Notifikasi
          SwitchListTile(
            value: _notifikasi,
            activeColor: Theme.of(context).colorScheme.primary,
            title: const Text("Notifikasi"),
            subtitle: const Text("Terima notifikasi presensi"),
            onChanged: (value) {
              setState(() {
                _notifikasi = value;
              });
            },
          ),
          const Divider(),

          // 🔹 Bahasa
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

          // 🔹 Privasi
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

          // 🔹 Tombol simpan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
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

  // 🔹 Dialog pilih bahasa
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

  // 🔹 Helper untuk menampilkan teks tema
  String _getThemeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "Terang";
      case ThemeMode.dark:
        return "Gelap";
      case ThemeMode.system:
        return "Mengikuti Sistem";
    }
  }
}

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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengaturan",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: scheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: scheme.primaryContainer,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: scheme.onPrimaryContainer),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 🔹 Tema
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.color_lens, color: scheme.primary),
              title: const Text("Tema Aplikasi"),
              subtitle: Text(_getThemeText(themeProvider.themeMode)),
              trailing: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                underline: const SizedBox(),
                onChanged: (mode) {
                  if (mode != null) themeProvider.setThemeMode(mode);
                },
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text("Mengikuti Sistem"),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text("Terang"),
                  ),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text("Gelap")),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 🔹 Notifikasi
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: SwitchListTile(
              value: _notifikasi,
              activeColor: scheme.primary,
              title: const Text("Notifikasi"),
              subtitle: const Text("Terima notifikasi presensi"),
              onChanged: (value) => setState(() => _notifikasi = value),
            ),
          ),
          const SizedBox(height: 12),

          // 🔹 Bahasa
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.language, color: scheme.primary),
              title: const Text("Bahasa"),
              subtitle: Text(_bahasa),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: scheme.outline,
              ),
              onTap: _showBahasaDialog,
            ),
          ),
          const SizedBox(height: 12),

          // 🔹 Privasi
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.lock, color: scheme.primary),
              title: const Text("Privasi & Keamanan"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: scheme.outline,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fitur akan hadir mendatang!")),
                );
              },
            ),
          ),
          const SizedBox(height: 30),

          // 🔹 Tombol simpan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pengaturan berhasil disimpan!"),
                  ),
                );
                context.pop();
              },
              child: Text(
                "Simpan",
                style: TextStyle(
                  color: scheme.onPrimary,
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
        final scheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text("Pilih Bahasa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text("Indonesia"),
                value: "Indonesia",
                groupValue: _bahasa,
                activeColor: scheme.primary,
                onChanged: (value) {
                  setState(() => _bahasa = value!);
                  context.pop();
                },
              ),
              RadioListTile<String>(
                title: const Text("English"),
                value: "English",
                groupValue: _bahasa,
                activeColor: scheme.primary,
                onChanged: (value) {
                  setState(() => _bahasa = value!);
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

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

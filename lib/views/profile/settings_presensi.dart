import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/services/history_pdf_export_service.dart';
import 'package:absensi_ppkdjp_b3/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPresensi extends StatelessWidget {
  const SettingsPresensi({super.key});

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
        centerTitle: true,
        elevation: 0,
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
          const SizedBox(height: 8),

          // 🔹 Ekspor Data
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.picture_as_pdf, color: scheme.primary),
              title: const Text("Ekspor Riwayat Presensi"),
              subtitle: const Text("Unduh riwayat absensi dalam format PDF"),
              onTap: () => HistoryPdfExportService.exportHistory(context),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),

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

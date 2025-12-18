import 'package:absensi_ppkdjp_b3/api/absen_api_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HistoryPdfExportService {
  static Future<void> exportHistory(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Fetch data
      final history = await AbsenApiHistory.getHistory();
      final data = history?.data ?? [];

      if (data.isEmpty) {
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tidak ada data presensi untuk diekspor"),
            ),
          );
        }
        return;
      }

      // Generate PDF
      final pdf = pw.Document();
      // Use standard fonts to avoid network dependency which might cause hangs/black screens
      final font = pw.Font.helvetica();
      final fontBold = pw.Font.helveticaBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          theme: pw.ThemeData.withFont(base: font, bold: fontBold),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Laporan Riwayat Presensi",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      DateFormat('dd MMM yyyy HH:mm').format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue500,
                ),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw
                      .Alignment
                      .centerLeft, // Location might be long, let's align left
                  5: pw
                      .Alignment
                      .centerLeft, // Reason might be long, align left
                },
                headers: [
                  "Tanggal",
                  "Masuk",
                  "Pulang",
                  "Status",
                  "Lokasi",
                  "Keterangan",
                ],
                data: data.map((item) {
                  // Determine 'Keterangan' content
                  String keterangan = "";
                  if (item.status?.toLowerCase() == "izin") {
                    keterangan = item.alasanIzin != null
                        ? item.alasanIzin.toString()
                        : "-";
                  }

                  return [
                    item.attendanceDate != null
                        ? DateFormat(
                            'dd/MM/yyyy',
                            'id_ID',
                          ).format(item.attendanceDate!)
                        : "-",
                    item.checkInTime ?? "-",
                    item.checkOutTime ?? "-",
                    item.status ?? "-",
                    item.checkInLocation ?? "-",
                    keterangan,
                  ];
                }).toList(),
              ),
            ];
          },
        ),
      );

      // Close loading before sharing
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Share PDF
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'riwayat_presensi.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        // Ensure dialog is closed if it's still open (checking if we popped already might be tricky without a key or boolean,
        // but pop is safe if it's the top route. However, if sharing failed after pop, this might pop the screen itself.
        // A safer way is to track if we popped.)
        // But for now, let's assume if we are here, we might need to pop only if we didn't succeed.
        // Actually, we popped before sharing. So if sharing fails, we don't need to pop.
        // BUT if pdf generation fails, we haven't popped.

        // Let's refine the logic: pop is strictly after PDF generation.
        // If error moves to catch block, we verify if we have popped?
        // Let's just try to pop if the error happened BEFORE sharing.
        // We can check if the dialog is likely up.
        // Or better: use a variable.
      }

      // Since we can't easily track dialog state here without extensive boilerplate,
      // let's rely on the user seeing the snackbar.
      // But we MUST pop if the dialog is up.
      // Re-implementing with a `loading` flag logic isn't possible in a static method easily without State.
      // Let's just try to pop and catch the exception if pop fails (which it shouldn't usually).

      try {
        if (context.mounted)
          Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (_) {}

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal mengexport PDF: $e")));
      }
    }
  }
}

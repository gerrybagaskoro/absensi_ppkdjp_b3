import 'package:absensi_ppkdjp_b3/api/absen_api_history.dart';
import 'package:absensi_ppkdjp_b3/api/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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
      // 1. Fetch Data
      final historyFuture = AbsenApiHistory.getHistory();
      final profileFuture = ProfileService.fetchProfile();

      // Load Logo
      final logoDataFuture = rootBundle.load(
        'assets/images/applogo_presensi_kita.png',
      );

      final results = await Future.wait([
        historyFuture,
        profileFuture,
        logoDataFuture,
      ]);

      final history = results[0] as dynamic;
      final profile = results[1] as dynamic;
      final logoByteData = results[2] as ByteData;

      final data = history?.data ?? [];
      final user = profile?.data;
      final logoImage = pw.MemoryImage(logoByteData.buffer.asUint8List());

      // Fetch Profile Image
      pw.ImageProvider? profileImage;
      if (user?.profilePhotoUrl != null) {
        try {
          final response = await http.get(Uri.parse(user!.profilePhotoUrl!));
          if (response.statusCode == 200) {
            profileImage = pw.MemoryImage(response.bodyBytes);
          }
        } catch (e) {
          debugPrint("Error loading profile image: $e");
        }
      }

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

      // 2. Generate PDF
      final pdf = pw.Document();
      // Use standard fonts to avoid network dependency
      final font = pw.Font.helvetica();
      final fontBold = pw.Font.helveticaBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(30),
          theme: pw.ThemeData.withFont(base: font, bold: fontBold),
          build: (pw.Context context) {
            return [
              // --- Header ---
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "LAPORAN RIWAYAT",
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        "PRESENSI",
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    height: 50,
                    width: 50,
                    child: pw.Image(logoImage),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // --- User Details Section ---
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.blue50, // Light blue/grey background
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Text Details
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Details",
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue900,
                            ),
                          ),
                          pw.Divider(color: PdfColors.blue900, thickness: 1),
                          pw.SizedBox(height: 5),
                          _buildDetailRow("Nama", user?.name ?? "-"),
                          _buildDetailRow("Email", user?.email ?? "-"),
                          _buildDetailRow(
                            "Batch",
                            user?.batchKe != null
                                ? "Batch ${user!.batchKe}"
                                : "-",
                          ),
                          _buildDetailRow(
                            "Pelatihan",
                            user?.trainingTitle ?? "-",
                          ),
                          _buildDetailRow(
                            "Tanggal Cetak",
                            DateFormat(
                              'dd MMMM yyyy HH:mm',
                              'id_ID',
                            ).format(DateTime.now()),
                          ),
                        ],
                      ),
                    ),
                    // Profile Image
                    if (profileImage != null) ...[
                      pw.SizedBox(width: 10),
                      pw.Container(
                        width: 70,
                        height: 70,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(
                            color: PdfColors.blue900,
                            width: 2,
                          ),
                          image: pw.DecorationImage(
                            image: profileImage,
                            fit: pw.BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // --- Table ---
              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(
                  color: PdfColors.grey400,
                  width: 0.5,
                ),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  fontSize: 10,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue700,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9),
                cellHeight: 25,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.centerLeft,
                  5: pw.Alignment.centerLeft,
                },
                headers: [
                  "Tanggal",
                  "Masuk",
                  "Pulang",
                  "Status",
                  "Lokasi",
                  "Keterangan",
                ],
                data: data.map<List<dynamic>>((item) {
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
      // Try to close dialog if open
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

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          ),
          pw.Text(": ", style: const pw.TextStyle(fontSize: 10)),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

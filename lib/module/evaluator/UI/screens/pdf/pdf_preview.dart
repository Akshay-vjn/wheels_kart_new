import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/images.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/pdf/pages/page_1.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/pdf/pages/page_2.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/pdf/pages/page_3.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/pdf/pages/page_4.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';

class PdfPreviewScreen extends StatefulWidget {
  final InspectionModel model;

  const PdfPreviewScreen({super.key, required this.model});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    await _loadData();

    pdf.addPage(pageOne(context, logoImage));
    pdf.addPage(pageTwo(context, logoImage));
    pdf.addPage(pageThree(context, logoImage));
    pdf.addPage(pageFour(context, logoImage));
    return pdf.save();
  }

  late pw.MemoryImage logoImage;

  _loadData() async {
    logoImage = pw.MemoryImage(
      (await rootBundle.load(ConstImages.appLogoHr)).buffer.asUint8List(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      // dpi: ,
      // dynamicLayout: true,
      initialPageFormat: PdfPageFormat.a4,
      actionBarTheme: PdfActionBarTheme(
        backgroundColor: AppColors.DARK_PRIMARY,
      ),
      build: (format) => generatePdf(),
      // pages: [],
      allowPrinting: false,
      canChangeOrientation: false,
      canChangePageFormat: false,
      loadingWidget: AppLoadingIndicator(),
      onError: (context, error) {
        return Text(error.toString());
      },
      pdfFileName: "wheelskart.pdf",
      pdfPreviewPageDecoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Colors.black.withAlpha(89),
            offset: const Offset(2, 4),
          ),
        ],
      ),
      scrollViewDecoration: const BoxDecoration(
        color: AppColors.DARK_PRIMARY_LIGHT,
      ),
      canDebug: false,
    );
  }

  final color = AppColors.DEFAULT_BLUE_DARK;
}

// Custom

pw.SizedBox spacer(BuildContext context, {double? ht, double? wt}) =>
    pw.SizedBox(
      height: ht == null ? 0 : h(context) * ht,
      width: wt == null ? 0 : w(context) * wt,
    );
builtTitle(BuildContext context, title) {
  return pw.Column(
    children: [
      spacer(context, ht: .01),
      pw.Text(
        title,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: primaryColor,
        ),
      ),
      spacer(context, ht: .01),
    ],
  );
}

// COLORS

final primaryColor = PdfColor.fromHex('f1963b');

// HEADER AND FOOTER

buildHeader(BuildContext context, pw.ImageProvider logoImage) => pw.Container(
  padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  color: primaryColor,
  child: pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Image(logoImage, width: w(context) * .2),
      pw.Column(
        // crossAxisAlignment: ,
        children: [
          pw.Text(
            "INSPECTION REPORT",
            style: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            "10265437794/6581795",
            style: pw.TextStyle(color: PdfColors.white, fontSize: 12),
          ),
        ],
      ),
      pw.Text(
        "06 May 2024",
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 12,
          fontWeight: pw.FontWeight.normal,
        ),
      ),
    ],
  ),
);

buildFooter(pw.Context context) => pw.Column(
  mainAxisAlignment: pw.MainAxisAlignment.center,
  children: [
    pw.Divider(thickness: .5),
    pw.Text(
      "WHEESLS KART PVT. LTD. 10TH FLOOR, TOWER B, UNITECH CYBER PARK, SECTOR- 39, GURUGRAM - 122003, HARYANA, INDIA",
      style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex("365B67")),
    ),
    pw.Text(
      "www.cars24.com CIN : U74999HR2015FTCO56386 | HELPLINE NO : 1800 258 5656 | EMAIL : contactus@cars24.com",
      style: pw.TextStyle(fontSize: 8, color: PdfColor.fromHex("365B67")),
    ),
    pw.SizedBox(height: 10),
    pw.Align(
      alignment: pw.Alignment.bottomRight,
      child: pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
      ),
    ),
  ],
);

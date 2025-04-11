import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/pdf/pdf_preview.dart';

pw.MultiPage pageFour(BuildContext context, pw.ImageProvider image) {
  return pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(20),
    header: (contex) => buildHeader(context, image),
    build:
        (pw.Context contex) => [
          spacer(context, ht: .02),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                color: PdfColor.fromHex("272A2E"),
                height: h(context) * .28,
                width: w(context) * .55,
              ),
              spacer(context, wt: .05),
              pw.Expanded(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "MG HECTOR PLUS",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                        color: PdfColor.fromHex("272A2E"),
                      ),
                    ),
                    spacer(context, ht: .005),
                    pw.Text(
                      "SHARP 2.0 DIESEL TURBO MT 6-STR DUAL TONE -2020",
                      style: pw.TextStyle(
                        // fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                        color: PdfColor.fromHex('777777'),
                      ),
                    ),
                    spacer(context, ht: .01),
                    _buildTitleContnt(context, "Year Of Manufacturing", "2020"),
                    _buildTitleContnt(context, "No. oF Owners", "1"),
                    _buildTitleContnt(context, "Duplicate Key", "No"),
                    _buildTitleContnt(context, "Fuel Type", "Diesel"),
                    _buildTitleContnt(context, "Reg. State", "Kerala"),
                    _buildTitleContnt(context, "Reg. City", "Malappuram"),
                    _buildTitleContnt(
                      context,
                      "Insurance Type",
                      "Comprehensive",
                    ),
                    _buildTitleContnt(
                      context,
                      "Insurance Expiry",
                      "28-July-2024",
                    ),
                    _buildTitleContnt(context, "RC Availability", "Original"),
                    _buildTitleContnt(context, "Road Tax Paid", "OTT/LTT"),
                    _buildTitleContnt(
                      context,
                      "Road Tax Date (Validity)",
                      "06-May-2024",
                    ),
                    _buildTitleContnt(context, "CNG/LPG Fitment In RC", ""),
                  ],
                ),
              ),
            ],
          ),

          builtTitle(context, 'Positive Highlights'),
          pw.Text(
            "Engine Exhaust is colorless | Auto Climate Control | Sun Roof | Car with Safety AirBag | Car with ABS | Power Windows |Music System | Steering Mounted Audio Controls | Reverse Camera | Rear Defogger | Leather Seats",
            style: pw.TextStyle(fontSize: 10),
          ),
          builtTitle(context, 'Car Details'),
          pw.Container(
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Column(
              children: [
                _buildTebleRow(
                  context,
                  false,
                  "Registration Number",
                  "KA51XXXXXX",
                  "RTO",
                  "KA-51 Electronic City",
                ),
                _buildTebleRow(
                  context,
                  true,
                  "City",
                  "Bangalore",
                  "RTO NOC Issued",
                  "No",
                ),
                _buildTebleRow(
                  context,
                  false,
                  "Branch",
                  "HI-Bengaluru 1",
                  "Chassis Number Embossing",
                  "Not Traceable",
                ),
                _buildTebleRow(context, true, "To Be Scrapped", "No", "", ""),
                _buildTebleRow(
                  context,
                  false,
                  "Manufacturing Month",
                  "July",
                  "",
                  "",
                ),
                _buildTebleRow(
                  context,
                  true,
                  "Registration Year",
                  "2000",
                  "",
                  "",
                ),
                _buildTebleRow(
                  context,
                  false,
                  "Registration Month",
                  "July",
                  "",
                  "",
                ),
                _buildTebleRow(
                  context,
                  true,
                  "Fitness Upto",
                  "29-Jul-2035",
                  "",
                  "",
                ),
                _buildTebleRow(context, false, "RC Condition", "Ok", "", ""),
                _buildTebleRow(
                  context,
                  true,
                  "Mismatch In RC",
                  "No Mismatch",
                  "",
                  "",
                ),
              ],
            ),
          ),
        ],
    footer: (context) => buildFooter(context),
  );
}

_buildTebleRow(
  BuildContext context,
  bool isBgGrey,
  String title1,
  String content1,
  String title2,
  String content2,
) {
  return pw.Container(
    padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    color: isBgGrey ? PdfColor.fromHex('eaeaea') : PdfColors.white,
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.SizedBox(
                width: w(context) * .3,
                child: pw.Text(title1, style: pw.TextStyle(fontSize: 10)),
              ),
              pw.Text(
                content1,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.SizedBox(
                width: w(context) * .3,
                child: pw.Text(title2, style: pw.TextStyle(fontSize: 10)),
              ),
              pw.Text(
                content2,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

_buildTitleContnt(BuildContext context, String title, String content) =>
    pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: w(context) * .4,
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  color: PdfColor.fromHex('777777'),
                  fontSize: 10,
                ),
              ),
            ),
            pw.Text(' : $content', style: pw.TextStyle(fontSize: 10)),
          ],
        ),
        spacer(context, ht: .005),
      ],
    );

final primaryColor = PdfColor.fromHex('df7c35');

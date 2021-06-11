import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scanner_generator/Components/GridCard.dart';
import 'package:scanner_generator/Screens/UniversalScanner.dart';
import 'package:scanner_generator/Screens/ScanImage.dart';
import 'package:scanner_generator/Screens/ScannerGenerator.dart';
import 'package:scanner_generator/Screens/GenerateFromFile.dart';

gridDashboard(BuildContext context) {
  return ListView(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          gridCard(FontAwesomeIcons.questionCircle, "Don't know type of Code", context, UniversalScanner()),
          gridCard(FontAwesomeIcons.image, "Scan Code from Image", context, ScanImage()),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          gridCard(Icons.qr_code, "QR Code", context, ScannerGenerator(codeType: "QR Code", codeId: "qrcode")),
          gridCard(FontAwesomeIcons.barcode, "Barcode", context, ScannerGenerator(codeId: "upcA", codeType: "Barcode")),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          gridCard(FontAwesomeIcons.barcode, "Generate QR Code and Save to PDF", context, GenerateFromFile(codeId: "qrCode", codeType: "QR Code")),
          gridCard(FontAwesomeIcons.barcode, "Generate Barcode and Save to PDF", context, GenerateFromFile(codeId: "upcA", codeType: "Barcode")),
        ],
      ),
    ],
  );
}
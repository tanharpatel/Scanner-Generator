import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scanner_generator/Components/ListCard.dart';
import 'package:scanner_generator/Screens/UniversalScanner.dart';
import 'package:scanner_generator/Screens/ScanImage.dart';
import 'package:scanner_generator/Screens/ScannerGenerator.dart';
import 'package:scanner_generator/Screens/GenerateFromFile.dart';

listDashboard(BuildContext context) {
  return ListView(
    children: [
      rightListCard(FontAwesomeIcons.questionCircle, "Don't know type of Code", context, UniversalScanner()),
      leftListCard(FontAwesomeIcons.image, "Scan Code from Image", context, ScanImage()),
      rightListCard(Icons.qr_code, "QR Code", context, ScannerGenerator(codeType: "QR Code", codeId: "qrcode")),
      leftListCard(FontAwesomeIcons.barcode, "Barcode", context, ScannerGenerator(codeId: "upcA", codeType: "Barcode")),
      rightListCard(FontAwesomeIcons.barcode, "Generate QR Code and Save to PDF", context, GenerateFromFile(codeId: "qrCode", codeType: "QR Code")),
      leftListCard(FontAwesomeIcons.barcode, "Generate Barcode and Save to PDF", context, GenerateFromFile(codeId: "upcA", codeType: "Barcode")),
    ],
  );
}
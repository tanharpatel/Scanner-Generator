import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scanner_generator/Screens/ScanImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanner_generator/Components/Card.dart';
import 'package:scanner_generator/Components/GridCard.dart';
import 'package:scanner_generator/Components/ListCard.dart';
import 'package:scanner_generator/Utils/SharedPref.dart';
import 'package:scanner_generator/Utils/ViewModifier.dart';
import 'package:scanner_generator/Screens/GenerateFromFile.dart';
import 'package:scanner_generator/Screens/ScannerGenerator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scanner_generator/Screens/Scanner.dart';
import 'package:scanner_generator/Screens/Settings.dart';
import 'package:scanner_generator/Screens/UniversalScanner.dart';

class Dashboard extends StatefulWidget {
  static final String id = "Dashboard";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    getTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Theme.of(context).backgroundColor),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 25),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height*0.05,
                        child: Image.asset("assets/logo.png"),
                      ),
                      SizedBox(height: 10),
                      Text("UID Center", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.04, fontWeight: FontWeight.w600, color: Colors.white),),
                      Text("One stop for all unique identifiers", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02, fontWeight: FontWeight.w300, color: Colors.white),),
                      SizedBox(height: 15),
                      // card(FontAwesomeIcons.question, "Don't know type of Code? \n Click Me", context, UniversalScanner()),
                    ],
                  ),
                  Expanded(
                    child: Provider.of<ViewModifier>(context).currentView == ViewType.List
                      ? listDashboard()
                      : gridDashboard(),
                  )
                ],
              ),
              Positioned(
                top: 10, right: 10,
                child: IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, Settings.id);
                  }
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  gridDashboard() {
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

  listDashboard() {
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
}
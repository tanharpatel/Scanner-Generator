import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner_generator/Screens/Generator.dart';
import 'package:scanner_generator/Screens/Scanner.dart';

class ScannerGenerator extends StatefulWidget {
  static final String id = "ScannerGenerator";
  final String codeType, codeId;

  ScannerGenerator({@required this.codeType, @required this.codeId});
  @override
  _ScannerGeneratorState createState() => _ScannerGeneratorState();
}

class _ScannerGeneratorState extends State<ScannerGenerator> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Theme.of(context).backgroundColor),
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: TabBarView(
              children: [
                Scanner(codeType: "${widget.codeType}", codeId: "${widget.codeId}"),
                Generator(codeType: "${widget.codeType}", codeId: "${widget.codeId}"),
              ],
            ),
            bottomNavigationBar: TabBar(
              tabs: [
                Tab(text: "Scan ${widget.codeType}"),
                Tab(text: "Generate ${widget.codeType}"),
              ],
              indicatorPadding: EdgeInsets.all(5.0),
            ),
          ),
        ),
      ),
    );
  }
}
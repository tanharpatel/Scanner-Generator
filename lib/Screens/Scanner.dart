import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scanner_generator/Functions/launchURL.dart';
import 'package:scanner_generator/Functions/showToast.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

class Scanner extends StatefulWidget {
  static final String id = "Scanner";
  final String codeType, codeId;

  Scanner({@required this.codeType, @required this.codeId});
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey key = GlobalKey(debugLabel: 'code');
  QRViewController controller;
  String codeResult;
  bool notType = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      Vibration.vibrate(duration: 10);
      setState(() {
        if(scanData.format.toString() == "BarcodeFormat.${widget.codeId}") {
          codeResult = scanData.code;
        } else {
          codeResult = "This is not ${widget.codeType}";
          setState(() {
            notType = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Scan ${widget.codeType}"),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: QRView(
                  key: key,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: codeResult != null
                          ? Column(
                            children: [
                              Text(
                                codeResult,
                                style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                                  fontSize: MediaQuery.of(context).size.height*0.025
                                )),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              notType == true
                                ? Container()
                                : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {
                                        Share.share("Data scanned is: $codeResult");
                                      }
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.open_in_new),
                                      onPressed: () async => launchURL(context, codeResult)
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.copy),
                                      onPressed: () async {
                                        await Clipboard.setData(ClipboardData(text: codeResult));
                                        showToast(context,
                                          "Copied to Clipboard",
                                          ToastGravity.BOTTOM,
                                          Theme.of(context).iconTheme.color.withAlpha(125),
                                          Duration(seconds: 2)
                                        );
                                      }
                                    ),
                                  ],
                                )
                            ],
                          )
                          : Text(
                            "Scan a Code first",
                            style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                              color: Colors.red,
                              fontSize: MediaQuery.of(context).size.height*0.03,
                            )),
                            textAlign: TextAlign.center,
                          ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
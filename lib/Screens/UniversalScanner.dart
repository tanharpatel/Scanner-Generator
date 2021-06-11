import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scanner_generator/Functions/launchURL.dart';
import 'package:scanner_generator/Functions/showToast.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

class UniversalScanner extends StatefulWidget {
  static final String id = "UniversalScanner";
  @override
  _UniversalScannerState createState() => _UniversalScannerState();
}

class _UniversalScannerState extends State<UniversalScanner> {
  final GlobalKey key = GlobalKey(debugLabel: 'code');
  QRViewController controller;
  String codeResult, codeType;
  bool pause = false, flashOn = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      Vibration.vibrate(duration: 10);
      setState(() {
        codeResult = scanData.code;
        codeType = scanData.format.toString().substring(14);
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Theme.of(context).backgroundColor),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Scan Any Code")
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: QRView(
                    key: key,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.flip_camera_ios_rounded),
                        onPressed: () async => await controller.flipCamera()
                      ),
                      IconButton(
                        icon: flashOn ? Icon(Icons.flash_off_rounded) : Icon(Icons.flash_on_rounded),
                        onPressed: () async {
                          await controller.toggleFlash();
                          setState(() {
                            flashOn = !flashOn;
                          });
                        }
                      ),
                      IconButton(
                        icon: pause ? Icon(Icons.play_arrow_rounded) : Icon(Icons.pause_rounded),
                        onPressed: () async {
                          if(pause) await controller.resumeCamera();
                          else await controller.pauseCamera();
                          setState(() {
                            pause = !pause;
                          });
                        }
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: codeResult != null
                            ? Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Code Data is: $codeResult",
                                    style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                                      fontSize: MediaQuery.of(context).size.height*0.03
                                    )),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Code scanned is: ",
                                        style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                                          fontSize: MediaQuery.of(context).size.height*0.03
                                        )),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        codeType,
                                        style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                                          color: Colors.red,
                                          fontSize: MediaQuery.of(context).size.height*0.03
                                        )),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.share_rounded),
                                        onPressed: () {
                                          Share.share("Data scanned is: $codeResult");
                                        }
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.open_in_new_rounded),
                                        onPressed: () async => launchURL(context, codeResult)
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.copy_rounded),
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
                              ]),
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
      ),
    );
  }
}
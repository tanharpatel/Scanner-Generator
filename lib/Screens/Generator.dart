import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:scanner_generator/Functions/fileExplorer.dart';
import 'package:scanner_generator/Functions/showToast.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

class Generator extends StatefulWidget {
  static final String id = "Generator";
  final String codeType, codeId;

  Generator({@required this.codeType, @required this.codeId});
  @override
  _GeneratorState createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  String  data = "", codeData = "";
  Uint8List bytes = Uint8List(0);
  TextEditingController textController = TextEditingController();
  bool isupcA = false;
  Barcode codeToGenerate;
  final pdf = pw.Document();

  @override
  void initState() {
    super.initState();
    if(widget.codeId == "qrcode") {
      codeToGenerate = Barcode.qrCode();
    } else if (widget.codeId == "upcA") {
      codeToGenerate = Barcode.upcA();
      setState(() {
        isupcA = true;
      });
    }
    initDownloadsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Generate ${widget.codeType}"),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: ListView(
            children: [
              _qrCodeWidget(context),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                child: isupcA
                  ? TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    controller: textController,
                    onChanged: (value) { data = value; },
                    onSubmitted: (value) {
                      if(data.length == 12) {
                        setState(() { codeData = data; });
                      } else {
                        Vibration.vibrate(duration: 10);
                      }
                    },
                    decoration: InputDecoration(hintText: "Enter your data here..."))
                  : TextField(
                    controller: textController,
                    onChanged: (value) { data = value; },
                    onSubmitted: (value) { setState(() { codeData = data; }); },
                    decoration: InputDecoration(hintText: "Enter your data here..."))
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                child: Center(
                  child: RaisedButton(
                    onPressed: () async {
                      if(data.length == 12) {
                        setState(() { codeData = data; });
                      } else {
                        Vibration.vibrate(duration: 10);
                        showToast(context,
                          "Data can't be empty",
                          ToastGravity.TOP,
                          Colors.red,
                          Duration(seconds: 2)
                        );
                      }
                    },
                    child: Text("Generate"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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

  Widget _qrCodeWidget(BuildContext context) {
    return Card(
      elevation: 6,
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.verified_user, size: 18, color: Colors.green),
                Text('  Generated ${widget.codeType}', style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only( top: 20, bottom: 10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: codeData == ""
                    ? Center(child: Text('Enter text to generate Code...'))
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: BarcodeWidget(
                        barcode: codeToGenerate,
                        data: codeData,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    )
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                child: Text("Share ${widget.codeType}"),
                onPressed: () async {
                  if(codeData == "") {
                    Vibration.vibrate(duration: 10);
                    showToast(context,
                      "Data can't be empty",
                      ToastGravity.TOP,
                      Colors.red,
                      Duration(seconds: 2)
                    );
                  } else {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.file_copy),
                              title: Text("Share PDF"),
                              onTap: () async {
                                Navigator.pop(context);
                                await saveSharePdf(true);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text("Share Image"),
                              onTap: () async {
                                Navigator.pop(context);
                                if(isupcA) {
                                  buildBarcode(true, codeToGenerate, codeData);
                                } else {
                                  final img = await toQrImageData(codeData);
                                  await _download(true, img);
                                }
                              }
                            ),
                          ],
                        );
                      }
                    );
                  }
                },
              ),
              Text("|", style: TextStyle(fontSize: 25, color: Colors.black26)),
              TextButton(
                child: Text("Save to Downloads"),
                onPressed: () {
                  if(codeData == "") {
                    Vibration.vibrate(duration: 10);
                    showToast(context,
                      "Data can't be empty",
                      ToastGravity.TOP,
                      Colors.red,
                      Duration(seconds: 2)
                    );
                  } else {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.file_copy),
                              title: Text("Download PDF"),
                              onTap: () async {
                                Navigator.pop(context);
                                await saveSharePdf(false);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text("Download Image"),
                              onTap: () async {
                                Navigator.pop(context);
                                if(isupcA) {
                                  buildBarcode(false, codeToGenerate, codeData);
                                } else {
                                  final img = await toQrImageData(codeData);
                                  _download(false, img);
                                }
                              }
                            ),
                          ],
                        );
                      }
                    );
                  }
                },
              ),
            ],
          ),
          Divider(height: 2, color: Colors.black26),
          TextButton(
            onPressed: () {
              setState(() {
                codeData = ""; textController.text = "";
              });
            },
            child: Text("Discard", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        gapless: false,
        color: Colors.black,
        emptyColor: Colors.white,
        version: QrVersions.auto,
      ).toImage(300);
      final a = await image.toByteData(format: ImageByteFormat.png);
      return a.buffer.asUint8List();
    } catch (e) {
      print("not saved to gallery");
      throw e;
    }
  }

  void buildBarcode(
    bool isShare,
    Barcode code,
    String data, {
    String filename,
    double width,
    double height,
  }) async {
    final svg = code.toSvg(
      data,
      width: width ?? 200,
      height: height ?? 80,
    );

    if(isShare) {
      File('${tempDir.path}/$codeData-${widget.codeType}.svg').writeAsStringSync(await svg);
      Share.shareFiles(['${tempDir.path}/$codeData-${widget.codeType.toLowerCase()}.svg'], text: '${widget.codeType} for $codeData');
    } else {
      File('${downloadsDirectory.path}/$codeData-${widget.codeType}.svg').writeAsStringSync(await svg);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Barcode image saved under downloads folder!")));
    }
  }

  Future<void> _download(bool isShare, imgBytes) async {
    var localPath;
    if(isShare) {
      localPath = path.join(tempDir.path, "$codeData-qrCode.jpg");
    } else {
      localPath = path.join(downloadsDirectory.path, "$codeData-qrCode.jpg");
    }
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(imgBytes);
    
    if(isShare) {
      Share.shareFiles(['${tempDir.path}/$codeData-qrCode.jpg'], text: 'QR Code for $codeData');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("QR Code image saved under downloads folder!")));
    }
  }

  saveSharePdf(bool isShare) async {
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat(500, 500),
      build: (pw.Context context) {
        return pw.Center(
          child: pw.BarcodeWidget(
            data: codeData,
            width: 400,
            height: 400,
            barcode: codeToGenerate,
            drawText: true,
          ),
        );
      }
    ));

    if (await Permission.storage.request().isGranted) {
      if(isShare) {
        File("${tempDir.path}/$codeData-${widget.codeType}.pdf").writeAsBytesSync(await pdf.save());
        Share.shareFiles(['${tempDir.path}/$codeData-${widget.codeType}.pdf'], text: '${widget.codeType} for $codeData'); 
      } else {
        File("${downloadsDirectory.path}/$codeData-${widget.codeType}.pdf").writeAsBytesSync(await pdf.save());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PDF saved under downloads folder as $codeData-${widget.codeType}.pdf")));
      }
    }
  }
}
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:share/share.dart';

class GenerateBarcode extends StatefulWidget {
  static final String id = "GenerateBarcode";
  @override
  _GenerateBarcodeState createState() => _GenerateBarcodeState();
}

class _GenerateBarcodeState extends State<GenerateBarcode> {
  String  data = "", barcodeData = "";
  Uint8List bytes = Uint8List(0);
  TextEditingController textController = TextEditingController();
  Directory _downloadsDirectory, tempDir;

  @override
  void initState() {
    super.initState();
    initDownloadsDirectoryState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Barcode"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: ListView(
          children: [
            _qrCodeWidget(context),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
              child: TextField(
                keyboardType: TextInputType.number,
                maxLength: 12,
                controller: textController,
                onChanged: (value) { data = value; },
                onSubmitted: (value) {
                  if(data.length == 12) {
                    setState(() { barcodeData = data; });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter 12 digits number")));
                  }
                },
                decoration: InputDecoration(hintText: "Enter your data here..."),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
              child: Center(
                child: FlatButton(
                  onPressed: () async {
                    if(data.length == 12) {
                      setState(() { barcodeData = data; });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter 12 digits number")));
                    }
                  },
                  child: Text("Generate", style: TextStyle(color: Colors.indigo[900],),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.indigo[900]),
                  ),
                ),
              ),
            ),
          ],
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
                Text('  Generated Barcode', style: TextStyle(fontSize: 15)),
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
                  child: barcodeData == ""
                    ? Center(child: Text('Enter text to generate Code...', style: TextStyle(color: Colors.black38)))
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: BarcodeWidget(barcode: Barcode.upcA(), data: barcodeData),
                    )
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                child: Text("Share Barcode", style: TextStyle(color: Colors.indigo[900])),
                onPressed: () async {
                  buildBarcode(true, Barcode.upcA(), barcodeData);
                },
              ),
              Text("|", style: TextStyle(fontSize: 25, color: Colors.black26)),
              TextButton(
                child: Text("Save to Downloads", style: TextStyle(color: Colors.indigo[900])),
                onPressed: () async {
                  buildBarcode(false, Barcode.upcA(), barcodeData);
                },
              ),
            ],
          ),
          Divider(height: 2, color: Colors.black26),
          TextButton(
            onPressed: () {
              setState(() {
                barcodeData = ""; textController.text = "";
              });
            },
            child: Text("Discard", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Future<void> initDownloadsDirectoryState() async {
    Directory downloadsDirectory;
    try {
      tempDir = await getTemporaryDirectory();
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } on PlatformException {
      print('Could not get the downloads directory');
    }
    if (!mounted) return;
    setState(() {
      _downloadsDirectory = downloadsDirectory;
    });
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
      _download(a.buffer.asUint8List());
    } catch (e) {
      print("not saved to gallery");
      throw e;
    }
  }

  Future<void> _download(imgBytes) async {
    final localPath = path.join(_downloadsDirectory.path, "image.jpg");
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(imgBytes);
    print("saved to gallery");
  }

  Future<void> _downloadCache(imgBytes) async {
    final localPath = path.join(tempDir.path, "$barcodeData-barcode.jpg");
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(imgBytes);
    print('Downloaded!');
    Share.shareFiles(['${tempDir.path}/$barcodeData-qr-code.jpg'], text: 'QR Code for $barcodeData');
  }

  bool share = false;

  void buildBarcode(
    bool share,
    Barcode code,
    String data, {
    String filename,
    double width,
    double height,
  }) async {
    print("hi");
    final svg = code.toSvg(
      data,
      width: width ?? 200,
      height: height ?? 80,
    );

    if(share) {
      File('${tempDir.path}/$barcodeData-barcode.svg').writeAsStringSync(await svg);
      Share.shareFiles(['${tempDir.path}/$barcodeData-barcode.svg'], text: 'Barcode for $barcodeData');
    } else {
      File('${_downloadsDirectory.path}/$barcodeData-barcode.svg').writeAsStringSync(await svg);
    }
    print("saved");
  }

}
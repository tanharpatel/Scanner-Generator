import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:scanner_generator/Functions/launchURL.dart';
import 'package:scanner_generator/Functions/showToast.dart';
import 'package:share/share.dart';

class ScanImage extends StatefulWidget {
  static final String id = "ScanImage";
  @override
  _ScanImageState createState() => _ScanImageState();
}

class _ScanImageState extends State<ScanImage> {
  String codeResult, _path;
  bool _loadingFile = false, notValid = false;
  Barcode codeToGenerate;

  void _openFileExplorer() async {
    setState(() {
      _loadingFile = true;
    });
    try{
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if(result != null) {
        _path = result.files.single.path;
      }
    } on PlatformException catch(e) {
      print(e);
    }
    if(!mounted) return;
    setState(() {
      _loadingFile = false;
    });

    var bytes = File(_path).readAsBytesSync();
    //TODO: do code to scan the obtained image stored as bytes
    print("bytes");
    // _getQrByGallery();
    decode(_path);
    print(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Scan Image")
        ),
        body: Center(
          child: Column(
            children: [
              RaisedButton(
                child: Text("Get Image"),
                onPressed: () async {
                  _openFileExplorer();
                },
              ),
              Builder(
                builder: (BuildContext context) => _loadingFile
                  ? const CircularProgressIndicator()
                  : _path != null
                    ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.5,
                          child: Image.file(File(_path))
                        ),
                        Scrollbar(
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
                                  notValid == true
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
                                "Not valid image",
                                style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                                  color: Colors.red,
                                  fontSize: MediaQuery.of(context).size.height*0.03,
                                )),
                                textAlign: TextAlign.center,
                              ),
                          ),
                        ),
                      ],
                    )
                    : Container(),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Future decode(String file) async {
    try {
      String data = await QrCodeToolsPlugin.decodeFrom(file);
      setState(() {
        codeResult = data;
        notValid = false;
      });
    } catch (e) {
      setState(() {
        codeResult = "Image invalid";
        notValid = true;
      });
    }
  }
}
import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:scanner_generator/Functions/launchURL.dart';
import 'package:scanner_generator/Functions/fileExplorer.dart';
import 'package:scanner_generator/Functions/showToast.dart';
import 'package:share/share.dart';

class ScanImage extends StatefulWidget {
  static final String id = "ScanImage";
  @override
  _ScanImageState createState() => _ScanImageState();
}

class _ScanImageState extends State<ScanImage> {
  String codeResult;
  bool _loadingFile = false, notValid = false;
  Barcode codeToGenerate;

  @override
  void initState() {
    path = null;
    super.initState();
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
                  setState(() {
                    _loadingFile = true;
                  });
                  await openFileExplorer(['jpg', 'jpeg', 'png']);
                  setState(() {
                    _loadingFile = false;
                  });
                  decode(path);
                },
              ),
              Builder(
                builder: (BuildContext context) => _loadingFile
                  ? const CircularProgressIndicator()
                  : path != null
                    ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.5,
                          child: Image.file(File(path))
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
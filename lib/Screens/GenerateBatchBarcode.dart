import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

class GenerateBatchBarcode extends StatefulWidget {
  static final String id = "GenerateBatchBarcode";
  @override
  _GenerateBatchBarcodeState createState() => _GenerateBatchBarcodeState();
}

class _GenerateBatchBarcodeState extends State<GenerateBatchBarcode> {
  List<String> names = [];
  Directory _downloadsDirectory;
  String qrData = "", _path;
  bool _loadingFile = false;
  final qrdataFeed = TextEditingController();
  final pdf = pw.Document();

  @override
  void initState() {
    super.initState();
    initDownloadsDirectoryState();
  }

  Future<void> initDownloadsDirectoryState() async {
    Directory downloadsDirectory;
    try {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } on PlatformException {
      print('Could not get the downloads directory');
    }
    if (!mounted) return;
    setState(() {
      _downloadsDirectory = downloadsDirectory;
    });
  }

  void _openFileExplorer() async {
    names = [];
    setState(() {
      _loadingFile = true;
    });
    try{
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'csv'],
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

    //  for opening a file from specified location
    var bytes = File(_path).readAsBytesSync();
    // for opening file from assets folder
    // ByteData data = await rootBundle.load(_path);
    // var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      for (int row = 0; row < excel.tables[table].maxRows; row++) {
        excel.tables[table].row(row).forEach((cell) {
          var val = cell.value;
          names.add(val);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Batch Barcode"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text("Get Excel"),
              onPressed: () async {
                _openFileExplorer();
              },
            ),
            Builder(
              builder: (BuildContext context) => _loadingFile
                ? const CircularProgressIndicator()
                : _path != null
                  ? new Container(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: new Scrollbar(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: MediaQuery.of(context).size.width*0.7,
                          childAspectRatio: 1,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2),
                        itemCount: names.length,
                        itemBuilder: (BuildContext context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: BarcodeWidget(barcode: Barcode.upcA(), data: names[index]),
                              ),
                              IconButton(icon: Icon(Icons.share,), onPressed: (){print(names[index]);}),
                            ]
                          );
                        }
                      ),
                    )
                  )
                  : Container(),
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Download PDF"),
        icon: Icon(Icons.download_rounded),
        onPressed: () async {
          printPdf();
          await savePdf();
        },
      ),
    );
  }

  printPdf() async {
    // pdf.addPage(pw.MultiPage(build: (pw.Context context) => [
    //   pw.ListView.builder(
      //   itemBuilder: (context, index) {
      //     return pw.Column(
      //       children: [
      //         pw.BarcodeWidget(
      //             data: data[index],
      //             width: 60,
      //             height: 60,
      //             barcode: pw.Barcode.qrCode(),
      //             drawText: false,
      //           ),
      //           pw.Text(data[index].toString()),
      //       ]
      //     );
      //   },
      //   itemCount: data.length
      // ),
    // ]));
    
    // pdf.addPage(pw.MultiPage(
    //   build: (pw.Context context) => [
    //     pw.Row(
    //       mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
    //       mainAxisSize: pw.MainAxisSize.max,
    //       children: [
    //         pw.ListView.builder(
    //           itemBuilder: (context, index) {
    //             return pw.Column(
    //               children: [
    //                 pw.BarcodeWidget(
    //                   data: names[index],
    //                   width: 60,
    //                   height: 60,
    //                   barcode: pw.Barcode.qrCode(),
    //                   drawText: false,
    //                 ),
    //                 pw.Text(names[index].toString()),
    //               ]
    //             );
    //           },
    //           itemCount: names.length~/3
    //         ),
    //         pw.ListView.builder(
    //           itemBuilder: (context, index) {
    //             return pw.Column(
    //               children: [
    //                 pw.BarcodeWidget(
    //                   data: names[index],
    //                   width: 60,
    //                   height: 60,
    //                   barcode: pw.Barcode.qrCode(),
    //                   drawText: false,
    //                 ),
    //                 pw.Text(names[index].toString()),
    //               ]
    //             );
    //           },
    //           itemCount: names.length~/3
    //         ),
    //         pw.ListView.builder(
    //           itemBuilder: (context, index) {
    //             return pw.Column(
    //               children: [
    //                 pw.BarcodeWidget(
    //                   data: names[index],
    //                   width: 60,
    //                   height: 60,
    //                   barcode: pw.Barcode.qrCode(),
    //                   drawText: false,
    //                 ),
    //                 pw.Text(names[index].toString()),
    //               ]
    //             );
    //           },
    //           itemCount: names.length~/3
    //         ),
    //       ]
    //     )
    //   ]
    // ));

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.GridView(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            pw.Column(
              children: [
                pw.BarcodeWidget(
                  data: names[0],
                  width: 200,
                  height: 80,
                  barcode: pw.Barcode.upcA(),
                  drawText: false,
                ),
                pw.Text(names[0].toString()),
              ]
            ),
          ]
        );
      }
    ));
  }

  Future savePdf() async {
    if (await Permission.storage.request().isGranted) {
      File file = File("${_downloadsDirectory.path}/qrcode.pdf");
      file.writeAsBytesSync(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PDF saved under downloads folder as QRCode.pdf")));
    }
  }
}
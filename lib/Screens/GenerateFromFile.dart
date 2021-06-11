import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scanner_generator/Functions/fileExplorer.dart';

class GenerateFromFile extends StatefulWidget {
  static final String id = "GenerateFromFile";
  final String codeType, codeId;

  GenerateFromFile({@required this.codeId, @required this.codeType});
  @override
  _GenerateFromFileState createState() => _GenerateFromFileState();
}

class _GenerateFromFileState extends State<GenerateFromFile> {
  List<String> names = [];
  String codeData = "";
  bool _loadingFile = false;
  final pdf = pw.Document();
  Barcode codeToGenerate;

  @override
  void initState() {
    super.initState();
    path = null;
    if(widget.codeId == "qrCode") {
      codeToGenerate = Barcode.qrCode();
    } else if (widget.codeId == "upcA") {
      codeToGenerate = Barcode.upcA();
    }
    initDownloadsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Generate multiple ${widget.codeType}'s")
        ),
        body: Center(
          child: Column(
            children: [
              RaisedButton(
                child: Text("Get Excel"),
                onPressed: () async {
                  path = "";
                  names = [];
                  setState(() {
                    _loadingFile = true;
                  });
                  await openFileExplorer(['xlsx', 'csv']);
                  setState(() {
                    _loadingFile = false;
                  });
                  var bytes = File(path).readAsBytesSync();
                  var excel = Excel.decodeBytes(bytes);
                  for (var table in excel.tables.keys) {
                    for (int row = 0; row < excel.tables[table].maxRows; row++) {
                      excel.tables[table].row(row).forEach((cell) {
                        var val = cell.value;
                        names.add(val.toString());
                      });
                    }
                  }
                },
              ),
              Builder(
                builder: (BuildContext context) => _loadingFile
                  ? const CircularProgressIndicator()
                  : path != null
                    ? Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: Scrollbar(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: MediaQuery.of(context).size.width/2,
                            ),
                            itemCount: names.length,
                            itemBuilder: (BuildContext context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: BarcodeWidget(barcode: codeToGenerate, data: names[index]),
                                  ),
                                  Text((names[index]).toString()),
                                  IconButton(icon: Icon(Icons.share_rounded,), onPressed: (){print(names[index]);}),
                                ]
                              );
                            }
                          ),
                        )
                      ),
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
      ),
    );
  }

  printPdf() async {
    List<String> even = [];
    List<String> odd = [];
    
    if(names.length % 2 != 0) {
      names.add("");
    }

    for(int i = 0; i < names.length; i++) {
      if(i%2 == 0) {
        even.add(names[i]);
      } else {
        odd.add(names[i]);
      }
    }
    
    pdf.addPage(pw.MultiPage(
      // pageFormat: PdfPageFormat(500, 500),
      // pageFormat: PdfPageFormat.a4,
      pageTheme: pw.PageTheme(
        margin: pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4
      ),
      build: (pw.Context context) => [
      pw.ListView.builder(
        itemCount: (names.length)~/2,
        itemBuilder: (context, index) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(10),
            child: pw.Row(
            children: [
              pw.Column(
                children: [
                  pw.BarcodeWidget(
                    data: even[index],
                    width: 200,
                    height: 200,
                    barcode: codeToGenerate,
                    drawText: true,
                  ),
                  pw.Text((even[index]).toString())
                ]
              ),
              pw.Spacer(),
              pw.Column(
                children: [
                  pw.BarcodeWidget(
                    data: odd[index],
                    width: 200,
                    height: 200,
                    barcode: codeToGenerate,
                    drawText: true,
                  ),
                  pw.Text((odd[index]).toString()),
                ]
              ),
            ],
            )
          );
        },
      )
    ]));
  }

  Future savePdf() async {
    if (await Permission.storage.request().isGranted) {
      File("${downloadsDirectory.path}/${widget.codeType}.pdf").writeAsBytesSync(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PDF saved under downloads folder as ${widget.codeType}.pdf")));
    }
  }
}
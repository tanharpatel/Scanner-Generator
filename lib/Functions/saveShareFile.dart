import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanner_generator/Functions/fileExplorer.dart';
import 'package:share/share.dart';

saveSharefile(BuildContext context, bool isShare, String codeData, String codeType, String ext, bytes) async {
  if (await Permission.storage.request().isGranted) {
    if(isShare) {
      File('${tempDir.path}/$codeData-$codeType.$ext').writeAsBytesSync(bytes);
      Share.shareFiles(['${tempDir.path}/$codeData-$codeType.$ext'], text: '$codeType for $codeData');
    } else {
      File('${downloadsDirectory.path}/$codeData-$codeType.$ext').writeAsBytesSync(bytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$codeData-$codeType.$ext saved under downloads folder!")));
    }
  }
}
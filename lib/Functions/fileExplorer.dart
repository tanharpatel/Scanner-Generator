import 'dart:io';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';

Directory downloadsDirectory, tempDir;
String path;

Future<void> initDownloadsDirectory() async {
  try {
    tempDir = await getTemporaryDirectory();
    downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
  } on PlatformException {
    print('Could not get the downloads directory');
  }
}

openFileExplorer(List<String> allowedExt) async {  
  try{
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: allowedExt,
    );
    if(result != null) {
      path = result.files.single.path;
    }
  } on PlatformException catch(e) {
    print(e);
  }
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner_generator/Functions/showToast.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(BuildContext context, codeResult) async =>
  await canLaunch(codeResult)
    ? await launch(codeResult)
    : showToast(context,
        "Can't open... Not a URL",
        ToastGravity.CENTER,
        Theme.of(context).backgroundColor.withAlpha(150),
        Duration(seconds: 2)
      );
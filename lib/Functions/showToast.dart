import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

FToast fToast = FToast();

showToast(BuildContext context, String text, ToastGravity gravity, Color toastColor, Duration duration) {
  fToast.init(context);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: toastColor,
    ),
    child: Text(text, style: TextStyle(color: Colors.white)),
  );

  fToast.showToast(
    child: toast,
    gravity: gravity,
    toastDuration: duration,
  );
}
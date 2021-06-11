import 'package:flutter/material.dart';

Widget card(IconData icon, String label, BuildContext context, screenToOpen) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screenToOpen));
    },
    child: Container(
      width: MediaQuery.of(context).size.width*0.9,
      height: MediaQuery.of(context).size.height*0.1,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: MediaQuery.of(context).size.longestSide*0.05),
            Text(label, style: TextStyle(fontWeight: FontWeight.w900), textAlign: TextAlign.center,),
          ],
        ),
      ),
    ),
  );
}
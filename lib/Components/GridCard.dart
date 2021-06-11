import 'package:flutter/material.dart';

Widget gridCard(IconData icon, String label, BuildContext context, screenToOpen) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screenToOpen));
    },
    child: Container(
      width: MediaQuery.of(context).size.shortestSide*0.45,
      height: MediaQuery.of(context).size.longestSide*0.2,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: MediaQuery.of(context).size.longestSide*0.07),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          ],
        ),
      ),
    ),
  );
}
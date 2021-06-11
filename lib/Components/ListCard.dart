import 'package:flutter/material.dart';

Widget rightListCard(IconData icon, String label, BuildContext context, screenToOpen) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screenToOpen));
    },
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.12, right: MediaQuery.of(context).size.width*0.05),
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.12,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.1, right: 20),
                    child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 10, top: MediaQuery.of(context).size.height*0.012,
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.height*0.05,
            child: Icon(icon),
          )
        )
      ]
    ),
  );
}

Widget leftListCard(IconData icon, String label, BuildContext context, screenToOpen) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screenToOpen));
    },
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.12, left: MediaQuery.of(context).size.width*0.05),
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.12,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.height*0.1, left: 20),
                    child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 10, top: MediaQuery.of(context).size.height*0.012,
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.height*0.05,
            child: Icon(icon),
          )
        )
      ]
    ),
  );
}
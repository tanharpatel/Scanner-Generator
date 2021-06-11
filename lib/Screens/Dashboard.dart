import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scanner_generator/Components/gridDashboard.dart';
import 'package:scanner_generator/Components/listDashboard.dart';
import 'package:scanner_generator/Utils/ViewModifier.dart';
import 'package:scanner_generator/Screens/Settings.dart';

class Dashboard extends StatefulWidget {
  static final String id = "Dashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Theme.of(context).backgroundColor),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 25),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height*0.05,
                        child: Image.asset("assets/logo.png"),
                      ),
                      SizedBox(height: 10),
                      Text("UID Center", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.04, fontWeight: FontWeight.w600, color: Colors.white),),
                      Text("One stop for all unique identifiers", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02, fontWeight: FontWeight.w300, color: Colors.white),),
                      SizedBox(height: 15),
                      // card(FontAwesomeIcons.question, "Don't know type of Code? \n Click Me", context, UniversalScanner()),
                    ],
                  ),
                  Expanded(
                    child: Provider.of<ViewModifier>(context).currentView == ViewType.List
                      ? listDashboard(context)
                      : gridDashboard(context),
                  )
                ],
              ),
              Positioned(
                top: 10, right: 10,
                child: IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, Settings.id);
                  }
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
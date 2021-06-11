import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:scanner_generator/Screens/Dashboard.dart';
import 'package:scanner_generator/Screens/ScanImage.dart';
import 'package:scanner_generator/Screens/Settings.dart';
import 'package:scanner_generator/Screens/UniversalScanner.dart';
import 'package:scanner_generator/Utils/LanguageModifier.dart';
import 'package:scanner_generator/Utils/ThemeModifier.dart';
import 'package:scanner_generator/Utils/ViewModifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeModifier>(
      create: (context) => ThemeModifier(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewModifier>(
      create: (context) => ViewModifier(),
      child: ChangeNotifierProvider<LanguageModifier>(
        create: (context) => LanguageModifier(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: Provider.of<ThemeModifier>(context).currentTheme,
          theme: ThemeData(
            primaryColor: Color(0xff3700B3),
            primaryColorDark: Color(0xff3700B3),
            accentColor: Color(0xff3700B3),
            backgroundColor: Color(0xff3700B3),
            buttonTheme: ButtonThemeData(
              buttonColor: Color(0xff3700B3),
              textTheme: ButtonTextTheme.primary,
            ),
            textButtonTheme: TextButtonThemeData(style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Color(0xff3700B3)),
            )),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color(0xff3700B3),
              foregroundColor: Colors.white,
            ),
            tabBarTheme: TabBarTheme(
              labelColor: Color(0xff3700B3),
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
            ),
            indicatorColor: Color(0xff3700B3),
            textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
            iconTheme: IconThemeData(color: Colors.black),
            textSelectionTheme: TextSelectionThemeData(cursorColor: Color(0xff3700B3)),
            colorScheme: ColorScheme.light(),
          ),
          darkTheme: ThemeData(
            primaryColor: Colors.teal,
            primaryColorDark: Colors.teal,
            accentColor: Colors.teal,
            backgroundColor: Colors.teal,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.teal,
              textTheme: ButtonTextTheme.primary,
            ),
            textButtonTheme: TextButtonThemeData(style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.teal),
            )),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            tabBarTheme: TabBarTheme(
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
            ),
            indicatorColor: Colors.teal,
            textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
            textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.teal),
            canvasColor: Color(0xff303030),
            cardColor: Color(0xff424242),
            colorScheme: ColorScheme.dark(),
          ),
          home: Splash(),
          routes: {
            Dashboard.id: (context) => Dashboard(),
            UniversalScanner.id: (context) => UniversalScanner(),
            ScanImage.id: (context) => ScanImage(),
            Settings.id: (context) => Settings(),
          },
        ),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () { Navigator.pushNamed(context, Dashboard.id); });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.25,
                child: Image.asset("assets/logo.png"),
              ),
              SizedBox(height: 20),
              Text(
                "UID Center",
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).backgroundColor
                )
              ),
              SizedBox(height: 20),
              SpinKitFadingCircle(
                size: MediaQuery.of(context).size.height*0.1,
                color: Theme.of(context).backgroundColor
              ),
            ],
          ),
        ),
      )
    );
  }
}
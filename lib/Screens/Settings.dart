import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scanner_generator/Utils/LanguageModifier.dart';
import 'package:scanner_generator/Utils/ThemeModifier.dart';
import 'package:scanner_generator/Utils/ViewModifier.dart';

class Settings extends StatefulWidget {
  static final String id = "Settings";
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    ThemeMode _theme = Provider.of<ThemeModifier>(context).currentTheme;
    ViewType _view =  Provider.of<ViewModifier>(context).currentView;
    Language _lang =  Provider.of<LanguageModifier>(context).currentLang;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Theme.of(context).backgroundColor),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Settings")
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                Text(
                  " Theme",
                  style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                    fontSize: MediaQuery.of(context).size.height*0.025
                  )),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.brightness_high),
                        title: Text("Light Theme"),
                        trailing: _theme == ThemeMode.light ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_off),
                        onTap: () {
                          setState(() {
                            _theme = ThemeMode.light;
                            Provider.of<ThemeModifier>(context, listen: false).setTheme(ThemeType.Light);
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.brightness_low),
                        title: Text("Dark Theme"),
                        trailing: _theme == ThemeMode.dark ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_off),
                        onTap: () {
                          setState(() {
                            _theme = ThemeMode.dark;
                            Provider.of<ThemeModifier>(context, listen: false).setTheme(ThemeType.Dark);
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.brightness_auto),
                        title: Text("System"),
                        trailing: _theme == ThemeMode.system ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_off),
                        onTap: () {
                          setState(() {
                            _theme = ThemeMode.system;
                            Provider.of<ThemeModifier>(context, listen: false).setTheme(ThemeType.System);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.025),
                Text(
                  " View",
                  style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                    fontSize: MediaQuery.of(context).size.height*0.025
                  )),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.list),
                        title: Text("List View"),
                        trailing: _view == ViewType.List ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_off),
                        onTap: () {
                          setState(() {
                            _view = ViewType.List;
                            Provider.of<ViewModifier>(context, listen: false).setView(ViewType.List);
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.grid_view),
                        title: Text("Grid View"),
                        trailing: _view == ViewType.Grid ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_off),
                        onTap: () {
                          setState(() {
                            _view = ViewType.Grid;
                            Provider.of<ViewModifier>(context, listen: false).setView(ViewType.Grid);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.025),
                Text(
                  " App Language",
                  style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                    fontSize: MediaQuery.of(context).size.height*0.025
                  )),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(FontAwesomeIcons.language),
                        title: Text("English"),
                        trailing: _lang == Language.English ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_off),
                        onTap: () {
                          setState(() {
                            _lang = Language.English;
                            Provider.of<LanguageModifier>(context, listen: false).setLang(Language.English);
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.language),
                        title: Text("Hindi"),
                        trailing: _lang == Language.Hindi ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_off),
                        onTap: () {
                          setState(() {
                            _lang = Language.Hindi;
                            Provider.of<LanguageModifier>(context, listen: false).setLang(Language.Hindi);
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.language),
                        title: Text("Gujarati"),
                        trailing: _lang == Language.Gujarati ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_off),
                        onTap: () {
                          setState(() {
                            _lang = Language.Gujarati;
                            Provider.of<LanguageModifier>(context, listen: false).setLang(Language.Gujarati);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
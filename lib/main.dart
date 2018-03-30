import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterapp/friendly_chat.dart';
import 'package:flutterapp/register.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'dart:io';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.orangeAccent[400],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.orange,
  accentColor: Colors.orangeAccent[400],
);

void main() {
  runApp(new FlutterApp());
}

class FlutterApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "FlutterApp",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new AppScreen(),
      routes:
      <String, WidgetBuilder>{
        '/home': (BuildContext context) => new FlutterApp(),
        '/chat': (BuildContext context) => new FriendlyChat(),
        '/register': (BuildContext context) => new Register(),
      },
    );
  }
}

class AppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppScreenState();
  }
}

class AppScreenState extends State<AppScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Widget buttonSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButtonColumn(Icons.chat, "Chat", () {
            Navigator
                .pushNamed(context, '/chat');
          }),
          buildButtonColumn(Icons.info, "Register", () {
            Navigator.pushNamed(context, '/register');
          })
        ],
      ),
    );
    Widget home = new Scaffold(
      appBar: buildAppBar("Home"),
      body: buttonSection,
    );
    return home;
  }

  Column buildButtonColumn(IconData icon, String label, VoidCallback callback) {
    Color color = defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme
        .accentColor : kDefaultTheme.accentColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new IconButton(
            icon: new Icon(icon, color: color,), onPressed: callback),
        new Container(
          margin: const EdgeInsets.only(top: 2.0),
          child: new Text(
            label,
            style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        )
      ],
    );
  }

  buildAppBar(String title) {
    return new AppBar(
      title: new Container(
        margin: const EdgeInsets.symmetric(
            vertical: 1.0, horizontal: 1.0),
        child: new Row(
          children: <Widget>[
            /*new IconButton(
                icon: new Icon(Icons.arrow_back_ios), onPressed: () {
              Navigator.pop(context);
            }),*/
            new Text(title != null ? title : "Flutter App"),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterapp/friendly_chat.dart';
import 'package:flutterapp/list_screen.dart';
import 'package:flutterapp/register.dart';

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
        '/list': (BuildContext context) => new ListPage(),
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
  TabController controller;

  @override
  Widget build(BuildContext context) {
    Widget home = new Scaffold(
        appBar: buildAppBar('Playground'),
        bottomNavigationBar: new TabBar(
            controller: controller,
            tabs: <Tab>[
              new Tab(icon: new Icon(Icons.info, size: 30.0)),
              new Tab(icon: new Icon(Icons.list, size: 30.0)),
              new Tab(icon: new Icon(Icons.chat, size: 30.0)),
            ]),
        body: new TabBarView(controller: controller, children: <Widget>[
          new RegisterScreen(),
          new ListScreen(),
          new ChatScreen()
        ])
    );
    return home;
  }

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
            new Text(title != null ? title : 'Flutter App'),
          ],
        ),
      ),
    );
  }
}
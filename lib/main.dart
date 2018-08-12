import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
  String _result;

  @override
  Widget build(BuildContext context) {
    Widget home = new Scaffold(
      appBar: buildAppBar('Playground'),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new TextFormField(),
          new RaisedButton(
            onPressed: _performApiRequest,
            child: new Text('I\'m ready'),
          ),
          new Image.network(_result != null ? _result : ""),
        ],
      ),
    );
    return home;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  _performApiRequest() async {
    var url = "https://yesno.wtf/api";
    var httpClient = new HttpClient();
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var jsonString = await response.transform(utf8.decoder).join();
        var data = json.decode(jsonString);
        result = data['image'];
      } else {
        result =
        'Error:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed';
    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _result = result;
    });
  }
}
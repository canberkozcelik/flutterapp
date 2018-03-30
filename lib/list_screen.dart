import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/friendly_chat.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/register.dart';

class ListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: "Register",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ListScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new FlutterApp(),
        '/chat': (BuildContext context) => new FriendlyChat(),
        '/register': (BuildContext context) => new Register(),
      },);
  }
}

class ListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ListScreenState();
  }
}

class ListScreenState extends State<ListScreen> {
  var _ipAddress = 'Unknown';

  _getIPAddress() async {
    var url = 'https://httpbin.org/ip';
    var httpClient = new HttpClient();

    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var jsonString = await response.transform(utf8.decoder).join();
        var data = json.decode(jsonString);
        result = data['origin'];
      } else {
        result =
        'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP';
    }
    if (!mounted) return;

    setState(() {
      _ipAddress = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
//      appBar: buildAppBar("List"),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Your current IP address is:'),
            new Text('$_ipAddress.'),
            spacer,
            new RaisedButton(
              onPressed: _getIPAddress,
              child: new Text('Get IP address'),
            ),
          ],
        ),
      ),
    );
  }

  buildAppBar(String title) {
    return new AppBar(
      title: new Container(
        margin: const EdgeInsets.symmetric(
            vertical: 1.0, horizontal: 1.0),
        child: new Row(
          children: <Widget>[
            new IconButton(
                icon: new Icon(Icons.arrow_back_ios), onPressed: () {
              Navigator.popAndPushNamed(context, '/home');
            }),
            new Text(title != null ? title : "Flutter App"),
          ],
        ),
      ),
    );
  }
}
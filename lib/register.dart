/*
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/friendly_chat.dart';
import 'package:flutterapp/main.dart';

class Register extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: "Register",
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: new RegisterScreen(),
    routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => new FlutterApp(),
      '/chat': (BuildContext context) => new FriendlyChat(),
      '/register': (BuildContext context) => new Register(),
    },);
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RegisterScreenState();
  }
}

class UserData {
  String username = '',
      email = '',
      password = '',
      profilePhotoUrl = '',
      status = '',
      phone = '';
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final fontSize = 24.0;
  final edgeInsets = 16.0;
  UserData user = new UserData();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value)));
  }

  bool _autoValidate = false;
  bool _formWasEdited = false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = new GlobalKey<
      FormFieldState<String>>();

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Validate on every change
      showInSnackBar('Please fix errors in red before submitting.');
    } else {
      form.save();
      showInSnackBar('Registered!');
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    final RegExp phoneExp = new RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
    if (!phoneExp.hasMatch(value))
      return 'Please enter a valid TR phone number.';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please choose a password.';
    return null;
  }

  String _validateMail(String value) {
    _formWasEdited = true;
    final RegExp mailExp = new RegExp(
        r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
    if (!mailExp.hasMatch(value))
      return 'Please enter a valid mail adress.';
    return null;
  }

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate())
      return true;

    return await showDialog<bool>(
      context: context,
      child: new AlertDialog(
        title: const Text('This form has errors'),
        content: const Text('Really leave this form?'),
        actions: <Widget>[
          new FlatButton(
            child: const Text('YES'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          new FlatButton(
            child: const Text('NO'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
//        appBar: buildAppBar("Register"),
        body: new SafeArea(
            top: false,
            bottom: false,
            child: new Form(
                key: _formKey,
                autovalidate: _autoValidate,
                onWillPop: _warnUserAboutInvalidData,
                child: new ListView(
                  padding: new EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    new GestureDetector(
                      child: new Container(
                        width: 100.0,
                        height: 100.0,
                        padding: const EdgeInsets.only(top: 16.0),
                        child: new CircleAvatar(
                            child: user != null &&
                                user.profilePhotoUrl.isNotEmpty
                                ? new Image.network(user.profilePhotoUrl)
                                : new Icon(Icons.person, size: 50.0,)),
                      ),),
                    new TextFormField(
                      validator: _validateName,
                      onSaved: (String username) {
                        user.username = username;
                      },
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.info),
                        labelText: 'Full Name',
                      ),
                    ),
                    new TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String email) {
                        user.email = email;
                      },
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.mail),
                        hintText: 'test@loodos.com',
                        labelText: 'Email *',
                      ),
                      validator: _validateMail,
                    ),
                    new TextFormField(
                      key: _passwordFieldKey,
                      obscureText: true,
                      onSaved: (String pwd) {
                        user.password = pwd;
                      },
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.lock),
                        hintText: '*******',
                        labelText: 'Password *',
                      ),
                      validator: _validatePassword,
                    ),
                    new TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (String status) {
                        user.status = status;
                      },
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.work),
                        hintText: 'Backend Developer',
                        labelText: 'Position',
                      ),
                    ),
                    new TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: _validatePhoneNumber,
                      onSaved: (String status) {
                        user.phone = status;
                      },
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.phone),
                        labelText: 'Phone',
                      ),
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                    new Container(
                      padding: const EdgeInsets.all(32.0),
                      alignment: Alignment.center,
                      child: new RaisedButton(
                        child: const Text('Submit'),
                        onPressed: _handleSubmitted,
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: new Text('* indicates required field', style: Theme
                          .of(context)
                          .textTheme
                          .caption),
                    ),
                  ],
                )
            )
        )
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
}*/

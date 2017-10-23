import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'stop_button.dart';
import 'control_page.dart';

void main() {
  runApp(new GoApp(title: 'GoBabyGo'));
}

class GoApp extends StatelessWidget {
  GoApp({this.title}) {
    controlPage = new MainScreen(title: 'Controller', app: this);
  }

  MainScreen controlPage;
  final String title;

  void toggleStop()
  {
    controlPage.toggleStop(); 
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "GoBabyGo",
      home: controlPage,
    );
  }
}



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
    controlPage = new ControlPage(title: 'Controller', mainapp: this);
  }

  ControlPage controlPage;
  final String title;

  Timer timer;

  bool running = false;
  int countdown = 0;

  void toggleStop()
  {
    if(running) {
      running = false;
      countdown = 5;
      controlPage.updateState();
      _startTimer();
    }
    else if(countdown == 0) {
      running = true;
      controlPage.updateState();
    }
  }

  void _startTimer() {
    timer = new Timer(const Duration(seconds:1), _timerFinish);
  }

  void _timerFinish() {
    countdown--;
    if(countdown > 0) {
      _startTimer();
    }
    controlPage.updateState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "GoBabyGo",
      home: controlPage,
    );
  }
}



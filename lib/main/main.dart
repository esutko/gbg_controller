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

  //Variables for executing the delay before the user can restart the car.
  Timer timer;
  bool running = false;
  int countdown = 0;

  /*Called when the toggle button is pressed. If the car is running, disable it. If the car is not running and the countdown has ended, restart the car. */
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

  void test(String s) {
    controlPage.setText(s);
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "GoBabyGo",
      home: controlPage,
    );
  }
}

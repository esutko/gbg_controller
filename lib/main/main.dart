import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'stop_button.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(new GoApp(title: 'GoBabyGo'));
}

class GoApp extends StatelessWidget {
  GoApp({this.title});

  final String title;

  void test()
  {
    print('test2');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "GoBabyGo",
      home: new MainScreen(title: 'GoBabyGo Main Screen', app: this),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title, this.app}) : super(key: key);

  final String title;
  GoApp app;

  @override
  _MainScreenState createState() => new _MainScreenState(app);
}

class _MainScreenState extends State<MainScreen> {
  _MainScreenState(this.app);

  StopButton stopButton = new StopButton();

  Timer timer;
  bool _running = true;
  String _countdownText = "";
  int _countdown = 0;

  GoApp app;

  void _toggleRun() {
    /*If the car is running, turn it off and start the timers for turning it
      back on */
    if(_running) {
      setState(() {
        _running = false;
        _countdown = 5;
        _updateCountdownText("test");
      });
      _startTimer();  
    }
    // Turn the car back on if the delay countdown is not running
    else if(_countdown==0) {
      setState(() {
        _running = true;
      });
    }
  }

  void _startTimer() {
    timer = new Timer(const Duration(seconds:1), _timerFinish);
  }

  void _timerFinish() {
    _countdown--;
    if(_countdown > 0) {
      _startTimer();
    }
    setState(() {
      _updateCountdownText("You can start the car in " + $_countdown + " seconds");
    });
  }

  /*Set the text that displays how many seconds left in the countdown.
    If the countdown isn't going, hide the text.
  */
  void _updateCountdownText(String text) {
    setState(() {
      _countdownText = text;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(widget.title),),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              new Text('$_running',
              style: Theme.of(context).textTheme.display1),
              new Expanded(
                child: new FittedBox(
                  fit:BoxFit.fitWidth,
                  child: stopButton,
                ),
              ),
              new Text('$_countdownText',
              style: new TextStyle(
                fontSize: 14.0)),
            ],
          ),
        ),
    );
  }
}

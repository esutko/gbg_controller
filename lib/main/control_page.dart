import 'package:flutter/material.dart';
import 'main.dart';
import 'stop_button.dart';
import 'dart:async'; 

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title, this.app}) : super(key: key) {
    _state = new _MainScreenState(app);
  } 

  _MainScreenState _state;
  final String title;
  GoApp app;

  @override
  _MainScreenState createState() => _state;

  void toggleStop() {
    _state.toggleStop();
  }
}

class _MainScreenState extends State<MainScreen> {

  int _countdown = 0;
  StopButton stopButton;

  Timer timer;
  bool _running = true;
  String _countdownText = "";

  GoApp app;

  _MainScreenState(GoApp app) {
    stopButton = new StopButton(app);
  }
  
  void toggleStop() {
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
      _updateCountdownText("You can start the car in " + _countdown.toString() + " seconds");
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

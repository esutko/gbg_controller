import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(new GoApp(title: 'GoBabyGo'));
}

class GoApp extends StatelessWidget {
  GoApp({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "GoBabyGo",
      home: new MainScreen(title: 'GoBabyGo Main Screen'),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => new _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer timer;
  bool _running = true;
  String _countdownText = "";
  int _countdown = 0;

  void _toggleRun() {
    /*If the car is running, turn it off and start the timers for turning it
      back on */
    if(_running) {
      setState(() {
        _running = false;
        _countdown = 5;
        _updateCountdownText();
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
      _updateCountdownText();
    });
  }

  /*Set the text that displays how many seconds left in the countdown.
    If the countdown isn't going, hide the text.
  */
  void _updateCountdownText() {
    if(_countdown == 0) {
      _countdownText = "";
    } else {
      _countdownText = "You can restart in " + '$_countdown' + " seconds";
    }
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
                  child: new RaisedButton(onPressed: _toggleRun,
                    child: new Text('Toggle'),
                    color: const Color.fromARGB(255, 255, 0, 0)
                  ),
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

class KillButton extends StatefulWidget {
  @override
  _KillButtonState createState() => new _KillButtonState(); 
}

class _KillButtonState extends State<KillButton> {
      
}

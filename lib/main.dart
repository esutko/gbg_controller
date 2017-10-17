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
  bool _running = true;
  String _countdownText = "";
  int _countdown = 0;

  void _toggleRun() {
    /*If the car is running, turn it off and start the timers for turning it
      back on */
    if(_running) {
      for(_countdown = 5; _countdown > 0; _countdown--) {
        pause(const Duration(seconds: 1));
        setState(() {
          _updateCountdownText(_countdown);
        });
      }
    } else if(_countdown==0) {
      // Turn the car back on if the delay countdown is not running
      setState(() {
        _running = true;
      });
    }
  }

  /*Set the text that displays how many seconds left in the countdown.
    If the countdown isn't going, hide the text.
  */
  void _updateCountdownText(int seconds) {
    if(seconds == 0)
    {
      _countdownText = "";
    } else {
      _countdownText = "You can restart in " + '$seconds' + " seconds";
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(widget.title),),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              new Text('$_running',
              style: Theme.of(context).textTheme.display1),
              new RaisedButton(onPressed: _toggleRun,
              child: new Text('Toggle')),
              new Text('$_countdownText',
              style: new TextStyle(
                fontSize: 14.0)),
            ],
          ),
        ),
    );
  }
}

import 'package:flutter/material.dart';
import 'main.dart';
import 'stop_button.dart';
import 'dart:async'; 

class ControlPage extends StatefulWidget {
  ControlPage({Key key, this.title, GoApp mainapp}) : super(key: key) {
    app = mainapp;
    _state = new _ControlPageState(mainapp);
  } 

  _ControlPageState _state;
  final String title;
  GoApp app;

  void updateState() {
    _state.updateState();
  }

  @override
  _ControlPageState createState() => _state;

  void toggleStop() {
    _state.toggleStop();
  }
}

class _ControlPageState extends State<ControlPage> {

  StopButton stopButton;
  Timer timer;

  String _countdownText = "";
  bool _running;
  int _countdown = 0;

  _ControlPageState(GoApp app) {
    stopButton = new StopButton(app);
  }
   
  void updateState() {
    setState(() {
      _running = widget.app.running;
      _countdown = widget.app.countdown;
      _countdownText = _getCountdownText();
    });
  }

  String _getCountdownText() {
    if(widget.app.countdown == 0) {
      return "";
    } else {
      return ("You can restart the car in " + widget.app.countdown.toString() + " seconds");
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
              new Text(_running.toString(),
              style: Theme.of(context).textTheme.display1),
              new Expanded(
                child: new FittedBox(
                  fit:BoxFit.fitWidth,
                  child: stopButton,
                ),
              ),
              new Text(_countdownText.toString(),
              style: new TextStyle(
                fontSize: 14.0)),
            ],
          ),
        ),
    );
  }
}


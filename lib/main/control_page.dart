import 'package:flutter/material.dart';
import 'main.dart';
import 'stop_button.dart';
import 'page_select.dart';
import 'dart:async'; 
import 'package:flutter/services.dart';

class ControlPage extends StatefulWidget {
  ControlPage({Key key, GoApp mainapp}) : super(key: key) {
    app = mainapp;
    _state = new _ControlPageState(mainapp);
  } 

  _ControlPageState _state;
  GoApp app;

  void conn() {
    _state.bluetoothConnection();
  }

  void updateState() {
    _state.updateState();
  }

  void setText(String s)
  {
    _state.setText(s);
  }
  @override
  _ControlPageState createState() => _state;
}

class _ControlPageState extends State<ControlPage> {

  StopButton stopButton;

  /*The variables that the page uses to display it's content.
    These are updated to match the ones in GoApp. These exist
    because when first initializing the widgets, this class
    cannot access GoApp, and so must have its own set of
    variables then are then updated to match GoApp's.
  */  
  String _countdownText = "";
  bool _running;
  int _countdown = 0;

  _ControlPageState(GoApp app) {
    stopButton = new StopButton(app);
  }

  /*Updates this class' content variables to match the ones from
    Go App.
  */
  void updateState() {
    setState(() {
      _running = widget.app.running;
      _countdown = widget.app.countdown;
      _countdownText = _getCountdownText();
    });
  }

  /*Returns the string the page should display that tells the
    user how long until the car can be restarted. When the
    countdown is not running, it returns an empty string so
    that the user will not see any text.
  */
  String _getCountdownText() {
    if(widget.app.countdown == 0) {
      return "";
    } else {
      return ("You can restart the car in " + widget.app.countdown.toString() + " seconds");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          new Text(_running.toString(),
          style: Theme.of(context).textTheme.display1),
          new Padding(padding: new EdgeInsets.all(20.0),
            child: new RaisedButton(child: new Text("Scan"),
              onPressed: widget.app.scanBt),),
          new Padding(padding: new EdgeInsets.all(20.0),
            child: new RaisedButton(child: new Text("Connect"), 
              onPressed: widget.app.connect),),
          new Padding(padding: new EdgeInsets.all(20.0),
            child: stopButton),
          new Padding(padding: new EdgeInsets.only(bottom: 40.0),
              child: new Text(_countdownText.toString(),
                style: new TextStyle(
                  fontSize: 14.0))),
        ],
      ),
    );
  }
}


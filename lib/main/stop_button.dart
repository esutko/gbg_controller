import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'main.dart';
import 'dart:async';

class StopButton extends StatefulWidget {
  StopButton(GoApp app) {
    this.app = app;
    _state = new _StopButtonState();
  }

  _StopButtonState _state;
  GoApp app;

  @override
  _StopButtonState createState() => _state; 
}

class _StopButtonState extends State<StopButton> {
  void _pressed() {
    //DeviceIdentifier id = new DeviceIdentifier("30:AE:A4:38:7B:6A");
    widget.app.toggle();
  }

  Widget build(BuildContext context) {
    return new MaterialButton(
        child: new Text('Toggle',
          style: new TextStyle(fontSize: 30.0)),
        color: const Color.fromARGB(255, 255, 0, 0),
        onPressed: _pressed,
        minWidth: 230.0,
        height: 100.0,
        elevation: 4.0,
        highlightElevation: 4.0,
    );
  }
}

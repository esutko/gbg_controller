import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'main.dart';

class StopButton extends StatefulWidget {
  StopButton(GoApp app) {
    this.app = app;
    _state = new _StopButtonState(app);
  }

  _StopButtonState _state;
  GoApp app;

  @override
  _StopButtonState createState() => _state; 

  void setCountdownText(String text) {
    _state.setText(text);
  }
}

class _StopButtonState extends State<StopButton> {
  _StopButtonState(this.app);

  GoApp app;
  String _buttonText = "Toggle";

  void setText(String text) {
    setState(() {
      _buttonText = text;  
    });
  }

  void _pressed() {
    print('test1');
    app.toggleStop();
    //var connection = flutterBlue.connect(device).listen((s) {});
    //deviceConnection.cancel();
  }

  Widget build(BuildContext context) {
    return new RaisedButton(
      child: new Text(_buttonText),
      color: const Color.fromARGB(255, 255, 0, 0),
      onPressed: _pressed,
    );
  }
}

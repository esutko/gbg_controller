import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class StopButton extends StatefulWidget {

  _StopButtonState _state = new _StopButtonState();

  @override
  _StopButtonState createState() => _state; 

  void setCountdownText(String text) {
    _state.setText(text);
  }
}

class _StopButtonState extends State<StopButton> {

  String _buttonText = "Toggle";

  void setText(String text) {
    setState(() {
      _buttonText = text;  
    });
  }

  void _pressed() {
    print('test1');
    var device = new BluetoothDevice("");
    var connection = flutterBlue.connect(device).listen((s) {});
    deviceConnection.cancel();
  }

  Widget build(BuildContext context) {
    return new RaisedButton(
      child: new Text(_buttonText),
      color: const Color.fromARGB(255, 255, 0, 0),
      onPressed: _pressed,
    );
  }
}

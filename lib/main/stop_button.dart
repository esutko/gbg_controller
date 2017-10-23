import 'package:flutter/material.dart';

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
    var connection = flutterBlue.connect(device).listen((s) {});
  }

/// Disconnect from device
deviceConnection.cancel();
    return new RaisedButton(
      child: new Text(_buttonText),
      color: const Color.fromARGB(255, 255, 0, 0),
      onPressed: _pressed,
    );
  }
}

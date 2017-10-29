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
  var scanSubscription;
  var connection;
  Timer timer;
  void _pressed() {
    //widget.app.toggleStop();
    //DeviceIdentifier id = new DeviceIdentifier("30:AE:A4:38:7B:6A");
    DeviceIdentifier id = new DeviceIdentifier("E0:AC:CB:5D:B7:E4");
    var device = new BluetoothDevice(id: id);
    //device.discoverServices();
    //print(device.services);
    FlutterBlue flutterBlue = FlutterBlue.instance;
    //var deviceConnection = flutterBlue.connect(device).listen(print);

    print("About to scan");
    scanSubscription = flutterBlue.scan().listen((scanResult) {
      print("Test: ");
      print(scanResult.device.id.id);
    });
    //start();
    /// Disconnect from device
    //deviceConnection.cancel();
    //var connection = flutterBlue.connect(device); 
    connection = flutterBlue.connect(device).listen((s) {
      print('Hi'); 
      //widget.app.test(s.toString());
    });
    start();
    //connection.cancel();
    //0868adf55d41b39630cf8c11d98ad7e6fa46e0f5
    
  }

  void start()
  {
    timer = new Timer(const Duration(seconds:30), finish);
  }

  void finish()
  {
    connection.cancel();
    scanSubscription.cancel();
  }

  Widget build(BuildContext context) {
    return new RaisedButton(
      child: new Text('Toggle'),
      color: const Color.fromARGB(255, 255, 0, 0),
      onPressed: _pressed,
    );
  }
}

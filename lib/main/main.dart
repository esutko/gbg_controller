import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'stop_button.dart';
import 'control_page.dart';
import 'page_select.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(new GoApp(title: 'GoBabyGo'));
}

class GoApp extends StatelessWidget {
  GoApp({this.title}) {
    pageSelect = new PageSelect(title: 'GBG', mainapp: this);
    init();
  }

  static const platform = const MethodChannel('gbg.bluetooth');

  PageSelect pageSelect;

  final String title;

  //Variables for executing the delay before the user can restart the car.
  Timer timer;
  Timer bluetoothTimer;
  FlutterBlue flutterBlue;
  var connection;
  var scanSubscription;
  bool running = false;
  int countdown = 0;

  /*Called when the toggle button is pressed. If the car is running, disable it. If the car is not running and the countdown has ended, restart the car. */
  void toggleStop()
  {
    if(running) {
      running = false;
      countdown = 5;
      pageSelect.controlPage.updateState();
      _startTimer();
    }
    else if(countdown == 0) {
      running = true;
      pageSelect.controlPage.updateState();
    }
  }
  
  void init() {
    flutterBlue = FlutterBlue.instance;
  }

  void scanBt() {
    callAndroid("scan");
  }

  void closeBt() {
    callAndroid("close");
  }
  
  void connect() {
    callAndroid("connect");
  }

  void toggle() {
    callAndroid("toggle");
  }

  Future<Null> callAndroid(String method) async {
    try {
      var result = await platform.invokeMethod(method);
      print(result);
    } on PlatformException catch (e) {
      print("Error while connecting to android code");
      print(e.toString());
    }
  }

  //Connect using flutter_blue, not currently being used
  void flutterConnect() {
    DeviceIdentifier id = new DeviceIdentifier("B8:27:EB:9B:89:4E");
    var device = new BluetoothDevice(id: id);

    print("About to scan");
    scanSubscription = flutterBlue.scan().listen((scanResult) {
      print(scanResult.device.id.toString());
    });

    /*print("Connecting");
    connection = flutterBlue.connect(device).listen((result) {
      print("Connection result:");
      print(result);
    });*/
  }

  //Cancels flutter_blue connections
  void cancelBluetooth() {
    scanSubscription.cancel();
    //connection.cancel();
  }

  void _startTimer() {
    timer = new Timer(const Duration(seconds:1), _timerFinish);
  }

  void _timerFinish() {
    countdown--;
    if(countdown > 0) {
      _startTimer();
    }
    pageSelect.controlPage.updateState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "GoBabyGo",
      home: pageSelect, 
      routes: <String, WidgetBuilder> {
        '/bluetooth': (BuildContext context) => pageSelect.bluetoothPage,
        '/control': (BuildContext context) => pageSelect.controlPage,
      },
    );
  }
}

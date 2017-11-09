import 'package:flutter/material.dart';
import 'main.dart';
import 'page_select.dart';

class BluetoothPage extends StatefulWidget {

  _BluetoothPageState _state;
  GoApp app;

  List<Widget> deviceList = new List();

  BluetoothPage({Key key, GoApp mainapp}) : super(key: key) {
    _state = new _BluetoothPageState();
    app = mainapp;
    deviceList.add(new Text("Device 1"));
    deviceList.add(new Text("Device 2"));
  }

  void addAddressToList(String address) {
    setState(() {
      deviceList.add(new Text(address));
    });
  }

  void addAddressesToList(List<String> addresses) {
    setState(() {
      for(var i = 0; i < addresses.length; i++) {
        deviceList.add(new Text(addresses[i]));
      }
    });
  }

  @override
  _BluetoothPageState createState() => _state;
}

class _BluetoothPageState extends State<BluetoothPage> {

  @override
  Widget build(BuildContext) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          new Container(
            //border: const Border.all(width: 2.0, color: Colors.black),
            child: new ListView(
              shrinkWrap: true,
              children: widget.deviceList,
            ),
          ),
        ],
      ),
    );
  }
}

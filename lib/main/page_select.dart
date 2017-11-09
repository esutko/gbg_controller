import 'package:flutter/material.dart';
import 'main.dart';
import 'control_page.dart';
import 'bluetooth_page.dart';

class PageSelect extends StatefulWidget {
  _PageSelectState _state;

  StatefulWidget currentPage;
  ControlPage controlPage;
  BluetoothPage bluetoothPage;

  bool vis = false;

  final String title;
  GoApp app;

  PageSelect({Key key, this.title, GoApp mainapp}) : super(key: key) {
    _state = new _PageSelectState();
    app = mainapp;
    controlPage = new ControlPage(mainapp: mainapp);
    bluetoothPage = new BluetoothPage(mainapp: mainapp);
    currentPage = controlPage;
  }

  void setPage(StatefulWidget w) {
    _state.setState(() {
      currentPage = w;
    });
  }

  void toggle()
  {
    _state.setState(() {
      vis = !vis;
      if(vis) {
        currentPage = new BluetoothPage(mainapp: app);
      } else {
        currentPage = new ControlPage(mainapp: app);
      }
    });
    //Navigator.of(context).pushNamed('/bluetooth');
  }

  @override
  _PageSelectState createState() => _state;
}

class _PageSelectState extends State<PageSelect> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(widget.title),),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget> [ 
              new Padding(padding: new EdgeInsets.only(top: 30.0)),
              new ListTile(
                leading: new Icon(Icons.change_history),
                title: new Text("Bluetooth Connect"),
                onTap: () {
                  widget.setPage(new BluetoothPage(mainapp: widget.app));
                  //Navigator.popAndPushNamed(context, '/bluetooth');
                  Navigator.pop(context);
                  //Navigator.of(context).pushNamed('/bluetooth');
                },
              ),
              new ListTile(
                leading: new Icon(Icons.change_history),
                title: new Text("Controller Page"),
                onTap:() {
                  widget.setPage(new ControlPage(mainapp: widget.app));
                  Navigator.pop(context);
                  //Navigator.popAndPushNamed(context, '/control');
                }
              ),
            ],
          ),
        ),
        body: widget.currentPage,
      );
  }
}

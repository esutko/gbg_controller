abstract class Bluetooh() {
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
}

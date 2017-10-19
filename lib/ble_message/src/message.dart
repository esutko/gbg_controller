library ble_message;
import 'identifcation.dart';
import 'payload.dart';
import 'crypto.dart';
import 'bluetooth.dart';

class Message extends Object with Bluetooth {
	var id = new Identifcation();
	var _payload;

	get payload(str) => _payload;

	Message([Payload payload]) {
		_payload = payload;
	}

	String toString() {
		return "${id.hash()}${payload.cipher( id.toString() )}";
	}
}
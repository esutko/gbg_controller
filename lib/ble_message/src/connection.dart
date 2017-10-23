library ble_message;
import 'identifcation.dart';
import 'payload.dart';
import 'crypto.dart';
import 'bluetooth.dart';

class Connection extends Object with Bluetooth {
	var _id = new Identifcation();
	var _payload = new Payload();

	get payload => _payload;
	get id => _id;
	void flush() {
		_payload = New Payload();
	}

	String toString() {
		return "${_id.hash()}${payload.cipher(_id.toString())}";
	}
}

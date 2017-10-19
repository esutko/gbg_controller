library ble_message;
import 'identifcation.dart';
import 'payload.dart';
import 'crypto.dart';
import 'dart:math';
import 'dart:io';

class Message extends Object with Bluetooth {
	var id = new Identifcation();
	var payload;

	set content(str) => payload.content = str;

	Message([String content]) {
		payload = new Payload(content);
	}

	String toString() {
		return "${id.hash()}${payload.cipher( id.toString() )}";
	}
}
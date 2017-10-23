library ble_message;
import 'dart:io';
import 'json.dart';
import 'dart:convert';
import 'package:binary/binary.dart';
import 'package:crypt/crypt.dart';


class Identifcation extends Object with JSON {
	//initialize default variables
	static final Identifcation _singleton = new Identifcation._internal();
	String _first_name = "";
	String _middle = "";
	String _last_name = "";
	String _dob = "";
	String _salt = "";

	//create accsessor functions
	set first_name(String str) =>  _first_name = str.toLowerCase();
	set middle(String str) => _middle = str.toLowerCase();
	set last_name(String str) => _last_name = str.toLowerCase();
	set salt(String str) => _salt = str;

	void dob(int month, int day, int year) {
		_dob = "$month/$day/$year";
	}

	//a constructor that returns the current instance of Identifcation
	factory Identifcation() {
		return _singleton;
	}

	//returns a formated string that will be used as a key to generate the cipher text
	String toString() {
		return "${_first_name}${_middle}${_last_name}(${_dob})(${_salt})(${new DateTime.now().toString().split(".")[0]})";
	}

	//returns a unix crypt style password hash in ASCII
	String hash() {
		String id = toString();
		String cipher_id = new Crypt.sha256(id).toString();
		String cipher_ascii = ASCII.encode(cipher_id);
		String cipher_bits = "";
		for (int ascii in cipher_ascii) {
			cipher_bits += uint8.toBinaryPadded(ascii);
		}
		return cipher_bits;
	}

	Identifcation._internal();
}

import 'dart:convert';
import 'dart:io';
import 'package:crypt/crypt.dart';


class Identifcation {
	//initialize default variables
	static final Identifcation _singleton = new Identifcation._internal();
	String _first_name = "";
	String _middle = "";
	String _last_name = "";
	String _dob = "";
	String _secret = "";

	//create accsessor functions
	String get first_name => _first_name;
	String get middle => _middle;
	String get last_name => _last_name;
	String get dob => _dob;
	String get secret => _secret;
	set first_name(String str) { _first_name = str.toLowerCase(); }
	set middle(String str) { _middle = str.toLowerCase(); }
	set last_name(String str) { _last_name = str.toLowerCase(); }
	set dob(String str) { _dob = str;}
	set secret(String str) { _secret = str; }

	//a constructor that returns the current instance of Identifcation
	factory Identifcation() {
		return _singleton;
	}

	//returns a formated string that will be used as a key to generate the cipher text
	String toString() {
		return "${_first_name}${_middle}${_last_name}(${_dob})(${_secret})(${new DateTime.now().toString().split(".")[0]})";
	}

	//returns the sha256 hash of the formated string
	String hash() {
		String id = toString();
		var hash = new Crypt.sha256(id);
		return hash.toString().split('\$5\$').last;
	}

	Identifcation._internal();
}
library ble_message;
import 'crypto.dart';

class Payload extends Object with JSON {
	Map _content = {speed:0, turn:0, kill:true};
	var _cipher = xor;

	set speed(int i) => _content[speed] = i;
	set turn(int i) => _content[turn] = i;
	set kill(bool b) => _content[kill] = b;

	Payload(var cipher, [String content]) {
		_cipher = cipher
	}

	//returns the content XOR ciphered with the key
	String cipher(String key) {
		return xor(_content, key);
	}
}

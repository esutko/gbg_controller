library ble_message;
import 'crypto.dart';

class Payload extends Object with JSON {
	String _content = "";

	set content(str) => _content = str;

	Payload(var cipher, [String content]) {
		if (content != null) {
			_content = content;
		}
	}

	//returns the content XOR ciphered with the key
	String cipher(String key) {
		return xor(_content, key);
	}
}

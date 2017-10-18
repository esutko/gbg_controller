import 'dart:convert';
import 'package:binary/binary.dart';


class Payload {
	String content = "";

	Payload(String new_content) {
		content = new_content;
	}

	//returns the content XOR ciphered with the key
	String xor(String key) {
		List key_ascii = ASCII.encode(key);
		List key_bits = [];
		List content_ascii = ASCII.encode(content);
		List content_bits = [];
		List cipher_bits = [];

		for (int ascii in key_ascii) {
			key_bits.add(uint8.toBinaryPadded(ascii));
		}

		for (int ascii in content_ascii) {
			content_bits.add(uint8.toBinaryPadded(ascii));
		}
		
		for (int idx = 0; idx < content_bits.length; ++idx) {
			var content_byte = content_bits[idx];
			var key_byte = key_bits[idx % key_bits.length];
			String cipher_byte = "";

			for (int bit = 0; bit < content_byte.length; ++bit) {
				if (key_byte[bit] == content_byte[bit]) {
					cipher_byte += "0";
				} else {
					cipher_byte += "1";
				}
			}
			cipher_bits.add(cipher_byte);
		}

		String cipher_text = cipher_bits.join();
		return cipher_text;
	}
}

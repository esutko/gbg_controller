import 'dart:convert';
import 'package:binary/binary.dart';
import 'crypto.dart';

String sha256(String text) {

}

String aes(String text, String key) {
	
}

String xor(String text, String key) {
	List key_ascii = ASCII.encode(key);
	List key_bits = [];
	List text_ascii = ASCII.encode(text);
	List text_bits = [];
	List cipher_bits = [];

	for (int ascii in key_ascii) {
		key_bits.add(uint8.toBinaryPadded(ascii));
	}

	for (int ascii in text_ascii) {
		text_bits.add(uint8.toBinaryPadded(ascii));
	}
	
	for (int idx = 0; idx < text_bits.length; ++idx) {
		var text_byte = text_bits[idx];
		var key_byte = key_bits[idx % key_bits.length];
		String cipher_byte = "";

		for (int bit = 0; bit < text_byte.length; ++bit) {
			if (key_byte[bit] == text_byte[bit]) {
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
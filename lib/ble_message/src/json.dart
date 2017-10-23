library ble_message;


abstract class JSON {
	Map json_decode(String json_string) {
		Map json_map = new Map();
		List json_list = json_string.replaceAll("{", "").replaceAll("}", "").trim().split("\n");
		for (String line in json_list) {
			json_map[line.split(":")[0].replaceAll('"', '')] = line.split(":").last;
		}
		return json_map;
	}

	String json_encode(Map json_map) {
		String json_string = "{\n";
		for (String key in json_map.keys) {
			json_string += "\t\"${key}\":${json_map[key]}\n";
		}
		return json_string + "}";
	}
}

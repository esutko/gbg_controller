class Message {
	var id = Identifcation();
	var payload = new Payload("");

	Message() {

	}

	String toString() {
		return "$id${payload.xor(id.toString)}"
	}
}
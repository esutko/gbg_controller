class Identifcation {
	static final Singleton _singleton = new singleton._internal();
	
	factory Singleton {
		return _singleton
	}

  Singleton._internal();
}
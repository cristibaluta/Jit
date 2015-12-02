package jit;

interface Keychain {
	public function setUserAndPassword (user: String, password: String) : Void;
	public function getPasswordForUser (user: String) : String;
}

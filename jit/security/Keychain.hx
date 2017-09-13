package jit.security;

class Keychain implements KeychainInterface {
	
	var keychain: KeychainInterface;
	
	public function new() {
		switch (Sys.systemName()) {
			case "Mac": keychain = new OSXKeychain();
			default: keychain = new WinKeychain();
		}
	}
	
	public function setUserAndPassword (user: String, password: String) : Void {
		keychain.setUserAndPassword(user, password);
	}
	
	public function getPasswordForUser (user: String) : String {
		return keychain.getPasswordForUser(user);
	}
}

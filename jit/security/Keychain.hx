package jit.security;

class Keychain implements KeychainInterface {
	
	var keychain: KeychainInterface;
	var project: String;
	
	public function new (project: String) {
		self.project = project;
		switch (Sys.systemName()) {
			case "Mac": keychain = new OSXKeychain();
			default: keychain = new WinKeychain();
		}
	}
	
	public function setUserAndPassword (user: String, password: String) : Void {
		keychain.setUserAndPassword(project + user, password);
	}
	
	public function getPasswordForUser (user: String) : String {
		return keychain.getPasswordForUser(project + user);
	}
}

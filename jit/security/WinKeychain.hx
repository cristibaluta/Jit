package jit.security;

class WinKeychain implements KeychainInterface {
	
	public function new() {}
	
	// security add-generic-password -a user -s jit.com.ralcr -p pass
	public function setUserAndPassword (user: String, password: String) : Void {
		
		Sys.command("security", ["add-generic-password", "-a", user, 
					"-s", "jit.com.ralcr", "-p", password, "-U", "-D", "jira password"]);
	}
	
	// security find-generic-password -wa cbaluta
	public function getPasswordForUser (user: String) : String {
		
		var process = new sys.io.Process("security", ["find-generic-password", "-wa", user]);
			process.exitCode();
		var pass = process.stdout.readAll().toString();
		// Ensure there are no spaces or new lines
		var r = ~/([^\n\s]+)/g;
		if (r.match ( pass )) {
			return r.matched(0);
		} else {
			return pass;
		}
	}
}

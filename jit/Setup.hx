package jit;
import haxe.io.Eof;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;

class Setup {
	
	var config: Config;
	
	public function new() {
		config = new Config();
	}
	
	public function run () {
		
		Sys.println( "Enter the jira url. Current url is " + config.getJiraUrl() );
		var jiraUrl = "";
		var looping = true;
		while (looping) {
			var char = Sys.getChar(true);
			if (char == 13) {
				looping = false;
			} else if (char != null) {
				jiraUrl = jiraUrl + String.fromCharCode(char);
			}
		}
		if (jiraUrl != "") {
			setJiraUrl( jiraUrl );
		}
		
		// Ask for username
		Sys.println( "Enter your jira username: " );
		var user = "";
		var looping = true;
		while (looping) {
			var char = Sys.getChar(true);
			if (char == 13) {
				looping = false;
			} else if (char != null) {
				user = user + String.fromCharCode(char);
			}
		}
		if (user != "") {
			setJiraUser( user );
		}
		
		Sys.println( "Enter your jira password: " );
		var pass = "";
		var looping = true;
		while (looping) {
			var char = Sys.getChar(true);
			if (char == 13) {
				looping = false;
			} else if (char != null) {
				pass = pass + String.fromCharCode(char);
			}
		}
		if (user == "") {
			
		}
		if (pass != "") {
			setJiraPasswordForUser( user, pass );
		}
		
		Sys.println( "Great, we are done!" );
	}
	
	public function setJiraUrl (url: String) {
		trace(url);
		config.setJiraUrl ( url );
	}
	
	public function setJiraUser (user: String) {
		config.setJiraUser ( user );
	}
	
	function setJiraPasswordForUser (user: String, pass: String) {
		var keychain = new OSXKeychain();
		keychain.setUserAndPassword (user, pass);
	}
}

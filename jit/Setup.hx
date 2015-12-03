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
		var jiraUrl = Sys.stdout();
/*		var url = jiraUrl.readAll().toString();
		setJiraUrl( url );*/
		
		Sys.println( "Enter your jira username: " );
		var jiraUser = Sys.stdin();
		var user = jiraUser.readAll().toString();
		setJiraUser( user );
		
		Sys.println( "Enter your jira password: " );
		var jiraPass = Sys.stdin();
		var pass = jiraPass.readAll().toString();
		setJiraPasswordForUser( user, pass );
		
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

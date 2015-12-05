package jit.command;
import haxe.io.Eof;
import sys.io.*;
import jit.security.*;

class Setup {
	
	var config: Config;
	
	public function new() {
		config = new Config();
	}
	
	public function run () {
		
		Sys.println( "Current url to Jira is: \033[1m"+config.getJiraUrl()+"\033[0m" );
		var jiraUrl = param("Jira url");
		if (jiraUrl != "") {
			setJiraUrl( jiraUrl );
		}
		
		// Ask for username
		var user = param("Jira username");
		if (user != "") {
			setJiraUser( user );
		}
		
		var pass = param("Jira password");
		if (user == "") {
			user = config.getJiraUser();
		}
		if (user != "" && user != null && pass != "") {
			setJiraPasswordForUser( user, pass );
		}
		
		Sys.println( "Great, we are done with Jira!" );
	}
	
	public function setJiraUrl (url: String) {
		config.setJiraUrl ( url );
	}
	
	public function setJiraUser (user: String) {
		config.setJiraUser ( user );
	}
	
	function setJiraPasswordForUser (user: String, pass: String) {
		var keychain = new OSXKeychain();
		keychain.setUserAndPassword (user, pass);
	}
	
	function param (name, ?passwd) {
		Sys.print(name + " : ");
		if (passwd) {
			var s = new StringBuf();
			do switch Sys.getChar(false) {
				case 10, 13: break;
				case c: s.addChar(c);
			}
			while (true);
			Sys.print("");
			return s.toString();
		}
		return Sys.stdin().readLine();
	}
}

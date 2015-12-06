package jit;
import haxe.io.Eof;
import sys.io.*;

/**
Config file is of form:
	JiraUrl
	JiraUser
*/
class Config {
	
	private var content: Array<String>;
	
	public function new() {
		var path = configFilePath();
		if (!sys.FileSystem.exists(path)) {
			var fout = File.write(path, false);
				fout.close();
		}
		content = File.getContent( path ).split("\n");
	}

	public function isValid() : Bool {
		return getJiraUrl() != null && getJiraUser() != null;
	}
	
	public function getJiraUrl() : String {
		return content[0];
	}
	
	public function setJiraUrl (url: String) {
		content[0] = url;
		save();
	}
	
	public function getJiraUser() : String {
		return content[1];
	}
	
	public function setJiraUser (user: String) {
		content[1] = user;
		save();
	}
	
	function save() {
		var fout = File.write( configFilePath(), false );
			fout.writeString( content.join("\n") );
			fout.close();
	}
	
	function configFilePath() : String {
		var homeDir = Sys.getEnv("HOME");
		var configFile = homeDir + "/.jitconfig";
		return configFile;
	}
}

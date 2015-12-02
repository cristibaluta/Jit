package jit;
import haxe.io.Eof;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;

class Config {
	
	private var content: Array<String>;
	
	public function new() {
		content = File.getContent( configPath() ).split("\n");
		trace(content);
	}
	
	public function getJiraUrl () : String {
		return content[0];
	}
	
	public function setJiraUrl (url: String) {
		content[0] = url;
		save();
	}
	
	public function getJiraUser(): String {
		return content[1];
	}
	
	public function setJiraUser (user: String) {
		content[1] = user;
		save();
	}
	
	function save() {
		// open file for writing
		var fout = File.write( configPath(), false );
			fout.writeString( content.join("\n") );
			fout.close();
	}
	
	function configPath(): String {
		var homeDir = Sys.getEnv("HOME");
		var configFile = homeDir + "/.jitconfig";
		return configFile;
	}
}

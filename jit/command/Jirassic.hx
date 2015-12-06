package jit.command;

class Jirassic {
	
	public function new () {
		
	}

	// osascript -e "tell application \"Jirassic\" to set tasks to \"abcdefghij\""
	public function logCommit (issueId: String, comments: Array<String>) {
		Sys.println("-----> Log commit to Jirassic");
		Sys.command("osascript", ["-e", "tell application \"Jirassic\" to set tasks to \"" 
			+ issueId + " " + comments.join(" ") +"\""]);
	}
}
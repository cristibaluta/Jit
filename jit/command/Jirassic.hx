package jit.command;

class Jirassic {
	
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}

	// osascript -e "tell application \"Jirassic\" to set tasks to \"abcdefghij\""
	public function logCommit (issueId: String, comments: Array<String>) {
		Sys.println("-----> Log commit to Jirassic");
		Sys.command("osascript", ["-e", "tell application \"Safari\" to set tasks to \"" 
			+ issueId + " " + comments.join(" ") +"\""]);
	}
	
	public function logLunch (duration: String) {
		Sys.println("-----> Log lunch to jirassic");
		// var response = Sys.command("osascript", ["-e", "tell application \"Safari\" to activate"]);
	}
}
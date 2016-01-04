package jit.command;

class Jirassic {
	
	public function new () {
		
	}

	// osascript -e "tell application \"Jirassic\" to set tasks to \"abcdefghij\""
	public function logCommit (issueId: String, comments: Array<String>) {
		var comment = issueId + "::" + (issueId != null ? (issueId + " ") : "") + comments.join(" ");
		Sys.command("osascript", ["-e", "tell application \"Jirassic\" to set tasks to \"" + comment +"\""]);
	}
}

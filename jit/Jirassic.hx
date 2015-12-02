package jit;

class Jirassic {
	
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}

	public function logCommit (issueId: String, comments: Array<String>) {
		Sys.println("-----> Log commit to Jirassic");
		// var response = Sys.command("osascript", ["-e", "tell application \"Safari\" to activate"]);
	}
	
	public function logLunch (duration: String) {
		Sys.println("-----> Log lunch to jirassic");
		// var response = Sys.command("osascript", ["-e", "tell application \"Safari\" to activate"]);
	}
}
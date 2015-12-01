package jit;

// Git class should take the arguments received through the commandline and extract the git command
class Git {

	// inline static var GIT_COMMANDS = ["branch", "checkout"];
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}

	public function run() {
		Sys.println("-----> Executing git commands");
/*		var response = Sys.command("git", ["branch"]);*/
		
		
		trace(getLocalBranches());
	}
	
	function getLocalBranches() : Array<String> {
		var process = new sys.io.Process("git", ["branch"]);
			process.exitCode();
		var result = process.stdout.readAll().toString();
		return result.split("\n");
	}
}

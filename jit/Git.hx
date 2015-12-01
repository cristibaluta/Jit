package jit;

// Git class should take the arguments received through the commandline and extract the git command
class Git {

	// inline static var GIT_COMMANDS = ["branch", "checkout"];
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}
	
	public function run() {
/*		var response = Sys.command("git", ["branch"]);*/
/*		trace(getLocalBranches());*/
	}

	public function createBranchNamed (branchName: String) {
		Sys.command("git", ["branch", branchName]);
	}
	
	public function searchInLocalBranches (issueId: String) : String {
		var branches = getLocalBranches();
		for (branch in branches) {
			if (branch.indexOf(issueId) != -1) {
				return branch;
			}
		}
		return null;
	}
	
	function getLocalBranches() : Array<String> {
		var process = new sys.io.Process("git", ["branch"]);
			process.exitCode();
		var result = process.stdout.readAll().toString();
		var branches = new Array<String>();
		for (branch in result.split("\n")) {
			if (branch.length > 0) {
				branches.push( StringTools.trim( branch ) );
			}
		}
		return branches;
	}
}

package jit.command;

class Git {
	
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}
	
	public function createBranchNamed (branchName: String) {
		Sys.command("git", ["branch", branchName]);
	}

	public function checkoutBranchNamed (branchName: String) {
		Sys.command("git", ["checkout", branchName]);
	}
	
	public function commit (comments: Array<String>) {
		Sys.command("git", ["add", "."]);
		Sys.command("git", ["commit", "-m", comments.join(" ")]);
	}
	
	public function searchInLocalBranches (issueId: String) : String {
		var branches = getLocalBranches();
		for (branch in branches) {
			if (branch.toLowerCase().indexOf(issueId.toLowerCase()) != -1) {
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

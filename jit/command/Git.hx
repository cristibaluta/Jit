package jit.command;

class Git {
	
	public function new () {
		
	}
	
	public function createBranchNamed (branchName: String) {
		Sys.command("git", ["branch", branchName]);
	}

	public function checkoutBranchNamed (branchName: String) {
		Sys.command("git", ["checkout", branchName]);
	}
	
	public function pull () {
		Sys.command("git", ["pull"]);
	}
	
	public function commit (comments: Array<String>) {
		Sys.command("git", ["commit", "-m", comments.join(" ")]);
	}
	
	public function commitAllAndPush (comments: Array<String>) {
		Sys.command("git", ["add", "."]);
		commit(comments);
		Sys.command("git", ["push"]);
	}
	
	public function searchInLocalBranches (issueId: String) : String {
		for (branch in getLocalBranches()) {
			if (branch.toLowerCase().indexOf(issueId.toLowerCase()) != -1) {
				return branch;
			}
		}
		return null;
	}
	
	public function currentBranchName() : String {
		var current = searchInLocalBranches("*");
		current = StringTools.trim(current.split("*")[1]);
		return current;
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

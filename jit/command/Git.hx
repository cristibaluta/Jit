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
	
	public function commit (comments: Array<String>) : String {
		Sys.command("git", ["commit", "-m", comments.join(" ")]);
		return "";
	}
	
	public function commitAllAndPush (comments: Array<String>) : String {
		Sys.command("git", ["add", "."]);
		commit( comments );
		var process = new sys.io.Process("git", ["branch"]);
			process.exitCode(true);
		var result = process.stdout.readAll().toString();
		trace(result);
		return result;
	}
	
	public function setUpstream (branchName: String) {
		// git push --set-upstream origin IOS-2256_T_C_App_Update_Increment_internal_T_C_version
		Sys.command("git", ["push", "--set-upstream", "origin", branchName]);
		// Sys.command("git", ["branch", "--set-upstream-to", "origin/" + branchName]);
	}
	
	public function searchInLocalBranches (searchTerm: String, issueId: String) : String {
		var branches = getLocalBranches();
		var matches = branches.filter( function(branchName: String) {
			var indexOfSearchTerm = branchName.toLowerCase().indexOf( searchTerm.toLowerCase() );
			var indexOfIssueId = branchName.toLowerCase().indexOf( issueId.toLowerCase() );
			return indexOfSearchTerm != -1 || indexOfIssueId != -1; 
		});
		// trace(matches);
		if (matches.length == 1) {
			return matches[0];
		}
		var bestMatch: String = null;
		var bestIndex: Int = 10000;
		for (match in matches) {
			if (match.toLowerCase() == searchTerm.toLowerCase()) {
				return match;
			} else {
				// var index = match.toLowerCase().indexOf( searchTerm.toLowerCase() );
				var indexOfSearchTerm = match.toLowerCase().indexOf( searchTerm.toLowerCase() );
				var indexOfIssueId = match.toLowerCase().indexOf( issueId.toLowerCase() );
				if (indexOfSearchTerm < bestIndex) {
					bestMatch = match;
					bestIndex = indexOfSearchTerm;
				}
				if (indexOfIssueId < bestIndex) {
					bestMatch = match;
					bestIndex = indexOfIssueId;
				}
			}
		}
		return bestMatch;
	}
	
	public function currentBranchName() : String {
		var current = searchInLocalBranches("*", "*");
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

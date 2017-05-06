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
		commit( comments );
		Sys.command("git", ["push"]);
	}
	
	public function setUpstream (branchName: String) {
		// git push --set-upstream origin IOS-2256_T_C_App_Update_Increment_internal_T_C_version
		// Sys.command("git", ["push", "--set-upstream", "origin", branchName]);
		Sys.command("git", ["push", "--set-upstream", "origin", branchName]);
	}
	
	public function branchIsUpstream (branchName: String) : Bool {
		var branches = getLocalBranches(true);
		for (branch in branches) {
			if (branch.indexOf(branchName) > 0) {
				return branch.indexOf(" [origin/" + branchName + "]") > 0;
			}
		}
		return false;
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
		var process = new sys.io.Process("git", ["symbolic-ref", "HEAD"]);
			process.exitCode();
		var result = process.stdout.readAll().toString();// refs/heads/branch_name
		return StringTools.trim(result.substr(11));
	}
	
	function getLocalBranches (includesTracking: Bool = false) : Array<String> {
		var args = ["branch"];
		if (includesTracking) {
			args.push("-vv");
		}
		var process = new sys.io.Process("git", args);
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
	
	public function getParentBranch () : String {
		// git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
		var args = ["-c", "git show-branch | grep '*' | grep -v \"$(git rev-parse --abbrev-ref HEAD)\" | head -n1 | sed 's/.*\\[\\(.*\\)\\].*/\\1/' | sed 's/[\\^~].*//'"];
		
		var process = new sys.io.Process("bash", args);
			process.exitCode();
		var result = process.stdout.readAll().toString();
		
		return StringTools.trim( result );
	}
	
	public function getCommits(fromBranch: String, toBranch: String) : Array<String> {
		// git log --no-color --reverse --format=%s parent_branch..current_ranch
		// git log --oneline current_branch ^parent_branch
		var process = new sys.io.Process("git", ["log", "--no-color", "--oneline", fromBranch, "^" + toBranch]);
			process.exitCode();
		var result = process.stdout.readAll().toString();
		var commits = new Array<String>();
		for (commit in result.split("\n")) {
			if (commit.length > 0) {
				commits.push( StringTools.trim( commit.substr(7) ) );// A commit message begins with the commit number, we need to remove it.
			}
		}
		return commits;
	}
	
	// urls order: fetch, push
	function getRemotes() : Array<String> {
		var process = new sys.io.Process("git", ["remote", "-v"]);
			process.exitCode();
		var result = process.stdout.readAll().toString();
		var remotes = new Array<String>();
		for (url in result.split("\n")) {
			if (url.length > 0) {
				remotes.push( StringTools.trim( url ) );
			}
		}
		return remotes;
	}
	
	public function getPushUrl() : String {
		var remotes = getRemotes();
		for (remote in remotes) {
			if (StringTools.endsWith(remote, "(push)")) {
				var intermediateUrl = StringTools.replace(remote, "(push)", "");
				intermediateUrl = StringTools.rtrim(intermediateUrl);
				var comps = intermediateUrl.split("\t");// split by tabs
				if (comps.length == 1) {
					comps = intermediateUrl.split(" ");// split by spaces
				}
				var url = comps.pop();
				
				return url;
			}
		}
		return null;
	}
}

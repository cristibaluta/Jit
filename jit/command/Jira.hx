package jit.command;
import jit.validator.*;

class Jira {
	
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}

	public function getFormattedIssueForGit (completion: String->Void) {
		
		var issueKey = new JiraIssueKeyValidator().validateIssueKey(args[0]);
		var requestUser = new JiraRequest();
		requestUser.getIssue (issueKey, function (response: Dynamic) {
			completion (response.key + "_" + issueSummaryToGitBranch(response.fields.summary));
		});
	}
	
	public function displayIssueDetails() {
		
		var issueKey = new JiraIssueKeyValidator().validateIssueKey(args[0]);
		var requestUser = new JiraRequest();
		requestUser.getIssue (issueKey, function (response: Dynamic) {
			Sys.println( response.key );
			Sys.println( response.fields.summary );
			Sys.println( response.key + "_" + issueSummaryToGitBranch(response.fields.summary));
		});
	}
	
	public function openIssue (issueKey: String) {
		
		issueKey = new JiraIssueKeyValidator().validateIssueKey(issueKey);
		var requestUser = new JiraRequest();
		requestUser.getIssue (issueKey, function (response: Dynamic) {
			// Open the url
			var config = new Config();
			var baseUrl = config.getJiraUrl();
			var issueUrl = baseUrl + "/jira/browse/" + response.key;
			Sys.command("osascript", ["-e", "tell application \"Safari\" to activate"]);
			Sys.command("osascript", ["-e", "tell application \"Safari\" to open location \"" + issueUrl + "\""]);
		});
	}
	
	function issueSummaryToGitBranch (string: String) : String {
		
		string = (~/\[(\w+)\]/g).replace(string, "");
		string = (~/[^a-zA-Z\d-]+/g).replace(string, "_");
		string = (~/_-_/g).replace(string, "_");
		string = (~/__/g).replace(string, "_");
		
	    return string;
	}
	
}

package jit;
import jit.validator.*;

class Jira {
	
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}

	public function run() {
		
		var issueKey = new JiraIssueKeyValidator().validateIssueKey(args[0]);
		trace(args[0] + " validated to "+issueKey);
		var requestUser = new JiraRequest();
		requestUser.getIssue (issueKey, function (response: Dynamic) {
/*			Sys.println(response);*/
			trace(response.key);
			trace(response.fields.summary);
			trace(response.key + "_" + issueSummaryToGitBranch(response.fields.summary));
		});
	}
	
	public function openIssue (issueKey: String) {
		issueKey = new JiraIssueKeyValidator().validateIssueKey(issueKey);
		var requestUser = new JiraRequest();
		requestUser.getIssue (issueKey, function (response: Dynamic) {
			trace(response.self);
			var credentials = haxe.Resource.getString("credentials").split("\n");
			var baseUrl = credentials[0];
			var issueUrl = baseUrl + "/jira/browse/";// + response.key;
			Sys.command("osascript", ["-e", "tell application \"Safari\" to activate"]);
			Sys.command("osascript", ["-e", "tell application \"Safari\" to open location \"" + issueUrl + "\""]);
		});
	}
	
	function issueSummaryToGitBranch(string: String): String {
		
		string = (~/\[(\w+)\]/g).replace(string, "");
		string = (~/[^a-zA-Z\d-]+/g).replace(string, "_");
		string = (~/_-_/g).replace(string, "_");
		string = (~/__/g).replace(string, "_");
		
	    return string;
	}
	
}

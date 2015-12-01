package jit;
/*import jit.validator;*/

class Jira {
	
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}

	public function run() {
		
		var issueKey = new jit.validator.JiraIssueKeyValidator().validateIssueKey(args[0]);
		trace(args[0] + " validated to "+issueKey);
		var requestUser = new JiraRequest();
		requestUser.getIssue (issueKey, function (response: Dynamic) {
/*			Sys.println(response);*/
			trace(response.key);
			trace(response.fields.summary);
			trace(response.key + "_" + issueSummaryToGitBranch(response.fields.summary));
		});
	}
	
	function issueSummaryToGitBranch(string: String): String {
		
		string = (~/\[(\w+)\]/g).replace(string, "");
		string = (~/[^a-zA-Z\d-]+/g).replace(string, "_");
		string = (~/_-_/g).replace(string, "_");
		
	    return string;
	}
	
}

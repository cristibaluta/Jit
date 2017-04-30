package jit.command;
import jit.validator.*;
import jit.parser.Branch;

class Jira {
	
	var args: Array<String>;
	var config: Config;

	public function new (args: Array<String>) {
		this.args = args;
		this.config = new Config();
	}

	public function getFormattedIssueForGit (completion: String->Void) {
		
		var issueKey = new JiraIssueKeyValidator().validateIssueKey( args[0]);
		var request = new JiraRequest();
		request.getIssue (issueKey, function (response: Dynamic) {
			if (response != null) {
				completion (response.key + // config.getBranchSeparator() +
							new Branch( config.getBranchSeparator() ).issueTitleToBranchName(response.fields.summary));
			} else {
				completion (null);
			}
		});
	}
	
	public function displayIssueDetails() {
		
		var issueKey = new JiraIssueKeyValidator().validateIssueKey( args[0]);
		var request = new JiraRequest();
		request.getIssue (issueKey, function (response: Dynamic) {
			if (response == null) {
				Sys.println( "Server error" );
			} else {
				Sys.println( "Issue id: " + Style.bold(response.key) );
				Sys.println( "Issue title: " + Style.bold(response.fields.summary) );
				Sys.println( "Branch name: " + Style.bold(response.key + 
							// config.getBranchSeparator() + 
					new Branch( config.getBranchSeparator() ).issueTitleToBranchName(response.fields.summary)));
			}
		});
	}
	
	public function openIssue (issueKey: String) {
		
		issueKey = new JiraIssueKeyValidator().validateIssueKey(issueKey);
		var request = new JiraRequest();
		request.getIssue (issueKey, function (response: Dynamic) {
			if (response == null) {
				Sys.println( "Server error" );
			} else {
				// Open the url
				var config = new Config();
				var baseUrl = config.getJiraUrl();
				var issueUrl = baseUrl + "/browse/" + response.key;
				Sys.command("open", [issueUrl]);
			}
		});
	}
	
	public function listMyProfile() {
		
		var request = new JiraRequest();
		request.getUserProfile (config.getJiraUser(), function (response: Dynamic) {
			if (response == null) {
				Sys.println( "Error getting the user details, credentials might be wrong." );
			} else {
				Sys.println("Username : " + config.getJiraUser());
				Sys.println("Name : " + response.displayName);
				Sys.println("Email : " + response.emailAddress);
				Sys.println("");
			}
		});
	}
	
	public function listMyTasks() {
		
		var request = new JiraRequest();
		request.getUserProfile (config.getJiraUser(), function (response: Dynamic) {
			if (response == null) {
				Sys.println( "Server error" );
			} else {
				Sys.command(response);
			}
		});
	}
}

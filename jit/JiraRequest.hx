package jit;
import jit.validator.*;

class JiraRequest {
	
	var config: Config;
	
	public function new () {
		config = new Config();
	}
	
	public function getIssue (key: String, completion: Dynamic->Void) {
		
		var baseUrl = new JiraUrlValidator().validateUrl(config.getJiraUrl());
		
		// curl -D- -u user:pass -X GET -H "Content-Type: application/json" https://mycompany.com/jira/rest/api/2/user?username=cbaluta
		
		// curl -D- -X GET -H "Authorization: Basic userpassbase64" -H "Content-Type: application/json" https://mycompany.com/jira/rest/api/2/user?username=cbaluta
		
/*		var process = new sys.io.Process("curl", ["-D-", "-u", user+":"+pass, "-X", "GET", "-H",
		"\"Content-Type: application/json\"",
		baseUrl + "rest/api/2/issue/" + key + "?fields=key,summary"]);*/
		
		var args = ["-D-", "-X", "GET",
		"-H", "Authorization: Basic " + encriptedCredentials(),
		"-H", "Content-Type: application/json",
		baseUrl + "rest/api/2/issue/" + key + "?fields=key,summary"];
		
		handleResponse (handleRequest(args), completion);
	}
	
	public function getUserProfile (user: String, completion: Dynamic->Void) {
		
		var baseUrl = new JiraUrlValidator().validateUrl(config.getJiraUrl());
		
		// curl -D- -u fred:fred -X GET -H "Content-Type: application/json" http://kelpie9:8081/rest/api/2/user?username=fred
		
		var args = ["-D-", "-X", "GET",
		"-H", "Authorization: Basic " + encriptedCredentials(),
		"-H", "Content-Type: application/json",
		baseUrl + "rest/api/2/user?username=" + user];
		
		handleResponse (handleRequest(args), completion);
	}
	
	public function getUserTasks (user: String, completion: Dynamic->Void) {
		
		var baseUrl = new JiraUrlValidator().validateUrl(config.getJiraUrl());
		
		// curl -D- -u fred:fred -X GET -H "Content-Type: application/json" http://kelpie9:8081/rest/api/2/search?jql=assignee=fred
		
		var args = ["-D-", "-X", "GET",
		"-H", "Authorization: Basic " + encriptedCredentials(),
		"-H", "Content-Type: application/json",
		baseUrl + "rest/api/2/search?jql=assignee=" + user];
		
		handleResponse (handleRequest(args), completion);
	}
	
	public function pullRequest (stashUrl: String, detailsDict: Dynamic, completion: Dynamic->Void) {
		
		// curl -u user:pass -H "Content-Type: application/json" -X POST -d '{"title": "branch name without underscores","description": "list of commits","state": "OPEN","open": true,"closed": false,"fromRef": {"id": "test25","repository": {"slug": "ios","name": null,"project": {"key": "BUI"}}},"toRef": {"id": "terms_and_conditions","repository": {"slug": "ios","name": null,"project": {"key": "BUI"}}},"locked": false,"reviewers": [{"user": {"name": "cbaluta"}}]}' "https://bitbucket.x.com/rest/api/1.0/projects/PROJ/repos/ios/pull-requests"
		
		var json = haxe.Json.stringify(detailsDict);
		
		var args = ["-D-", "-X", "POST",
		"-H", "Authorization: Basic " + encriptedCredentials(),
		"-H", "Content-Type: application/json",
		"-d", json, stashUrl];
		
		handleResponse (handleRequest(args), completion);
	}
	
	// Helpers
	
	function handleRequest (args: Array<String>): String {
		
		if (Jit.verbose) {
			Sys.println("Making request with: " + args.join(" "));
		}
		var process = new sys.io.Process("curl", args);
		process.exitCode();
		
		return process.stdout.readAll().toString();
	}
	
	function handleResponse (response: String, completion: Dynamic->Void) {
		
		if (Jit.verbose) {
			Sys.println("Response: " + response);
		}
		
		if (isValidResponse(response) || isValidPullRequest(response)) {
			var json: Dynamic = null;
			try {
				json = extractJson(response);
			} catch (e: Dynamic) {
				trace("Error parsing json");
				trace(response);
			}
			completion(json);
		} else {
			completion(null);
		}
	}
	
	function isValidResponse (response: String): Bool {
		return response.indexOf("200 OK") != -1;
	}
	
	function isValidPullRequest (response: String): Bool {
		return response.indexOf("201 Created") != -1;
	}
	
	function extractJson (response: String): Dynamic {
		// Json begins after an empty line and starts with {"
		var components = response.split("\n{\"");
		return haxe.Json.parse("{\"" + components.pop());
	}
	
	function encriptedCredentials(): String {
		var user = config.getJiraUser();
		var pass = config.getJiraPassword();
		var userPassword64 = haxe.crypto.Base64.encode( haxe.io.Bytes.ofString (user + ":" + pass) );
		return userPassword64;
	}
}

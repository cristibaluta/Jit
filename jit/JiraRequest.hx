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
		
		var process = new sys.io.Process("curl", ["-D-", "-X", "GET",
		"-H", "Authorization: Basic " + encriptedCredentials(),
		"-H", "Content-Type: application/json",
		baseUrl + "rest/api/2/issue/" + key + "?fields=key,summary"]);
		
		process.exitCode();
		var result = process.stdout.readAll().toString();
		handleResponse (result, completion);
	}
	
	public function getUserProfile (user: String, completion: Dynamic->Void) {
		
		var baseUrl = new JiraUrlValidator().validateUrl(config.getJiraUrl());
		
		// curl -D- -u fred:fred -X GET -H "Content-Type: application/json" http://kelpie9:8081/rest/api/2/user?username=fred
		
		var process = new sys.io.Process("curl", ["-D-", "-X", "GET",
		"-H", "Authorization: Basic " + encriptedCredentials(),
		"-H", "Content-Type: application/json",
		baseUrl + "rest/api/2/user?username=" + user]);
		
		process.exitCode();
		var result = process.stdout.readAll().toString();
		handleResponse (result, completion);
	}
	
	public function getUserTasks (user: String, completion: Dynamic->Void) {
		
		var baseUrl = new JiraUrlValidator().validateUrl(config.getJiraUrl());
		
		// curl -D- -u fred:fred -X GET -H "Content-Type: application/json" http://kelpie9:8081/rest/api/2/search?jql=assignee=fred
		
		var process = new sys.io.Process("curl", ["-D-", "-X", "GET",
		"-H", "Authorization: Basic " + encriptedCredentials(),
		"-H", "Content-Type: application/json",
		baseUrl + "rest/api/2/search?jql=assignee=" + user]);
		
		process.exitCode();
		var result = process.stdout.readAll().toString();
		trace(result);
		handleResponse (result, completion);
	}
	
	
	function handleResponse (response: String, completion: Dynamic->Void): Void {
		if (isValidResponse(response)) {
			var json: Dynamic = null;
			try {
				json = jsonResponse(response);
			} catch (e: Dynamic) {
				trace("Error parsing json");
				trace(response);
			}
			completion(json);
		} else {
			trace("The response doesn't contain 200 OK header");
			trace(response);
			completion(null);
		}
	}
	
	function isValidResponse (response: String): Bool {
		return response.indexOf("200 OK") != -1;
	}
	
	function jsonResponse (response: String): Dynamic {
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

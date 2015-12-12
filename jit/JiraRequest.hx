package jit;
import jit.security.*;
import jit.validator.*;

class JiraRequest {
	
	public function new () {
		
	}
	
	public function getIssue (key: String, completion: Dynamic->Void) {
		
		var config = new Config();
		var baseUrl = new JiraUrlValidator().validateUrl(config.getJiraUrl());
		
		//curl -D- -u user:pass -X GET -H "Content-Type: application/json" https://mycompany.com/jira/rest/api/2/user?username=cbaluta
		
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
/*		trace(result);*/
		if (isValidResponse(result)) {
			try {
				var json = jsonResponse(result);
				completion(json);
			} catch (e: Dynamic) {
				trace(result);
				completion(null);
			}
		} else {
			trace(result);
			completion(null);
		}
	}
	
	function isValidResponse (response: String): Bool {
		return response.indexOf("200 OK") != -1;
	}
	
	function jsonResponse (response: String): Dynamic {
		var components = response.split("Transfer-Encoding: chunked");
		return haxe.Json.parse(components.pop());
	}
	
	function encriptedCredentials(): String {
		var config = new Config();
		var user = config.getJiraUser();
		var pass = new Keychain().getPasswordForUser(user);
		var userPassword64 = haxe.crypto.Base64.encode( haxe.io.Bytes.ofString (user + ":" + pass) );
		return userPassword64;
	}
}

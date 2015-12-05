package jit;
import jit.security.*;

class JiraRequest {
	
	public function new () {
		
	}
	
	public function getIssue (key: String, completion: Dynamic->Void) {
		
		var config = new Config();
		var baseUrl = config.getJiraUrl();
		var user = config.getJiraUser();
		var pass = new OSXKeychain().getPasswordForUser(user);
		
		//curl -D- -u cbaluta:Cr1st1_Tulc3a -X GET -H "Content-Type: application/json" https://dev.mobility-media.de/jira/rest/api/2/user?username=cbaluta
		
		var process = new sys.io.Process("curl", ["-D-", "-u", user+":"+pass, "-X", "GET", "-H", 
		"\"Content-Type: application/json\"", 
		baseUrl + "/jira/rest/api/2/issue/" + key + "?fields=key,summary"]);
		process.exitCode();
		var result = process.stdout.readAll().toString();
		/*trace(result);*/
		if (isValidResponse(result)) {
			try {
				var json = jsonResponse(result);
				completion(json);
			} catch (e:Dynamic) {
				trace(result);
				completion(null);
			}
		} else {
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
}

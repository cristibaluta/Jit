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
		trace(result);
		if (isValidResponse(result)) {
			try {
				var json = jsonResponse(result);
				trace(json);
				completion(json);
			} catch (e:Dynamic) {
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
	
	/*public function getIssue_ (key: String, completion: Dynamic->Void) {

		var config = new Config();
		var baseUrl = config.getJiraUrl();
		var userPassword64 = encriptedCredentials();

		var r = new haxe.Http( baseUrl + "/jira/rest/api/2/issue/" + key );
		r.setHeader("Authorization", "Basic " + userPassword64);
		r.setHeader("Content-Type", "application/json");
		r.addParameter ("fields", "key,summary");
		r.onData = function (data: String) {
			var json = haxe.Json.parse(data);
			completion(json);
		}
		r.onError = function (data: String) {
			trace(r);
		}
		r.onStatus = function(status) {

		}
		r.request();
	}

	function encriptedCredentials(): String {
		var config = new Config();
		var user = config.getJiraUser();
		var pass = new OSXKeychain().getPasswordForUser(user);
		var userPassword64 = haxe.crypto.Base64.encode( haxe.io.Bytes.ofString (user + ":" + pass) );
		return userPassword64;
	}*/
}

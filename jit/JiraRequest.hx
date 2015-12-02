package jit;

class JiraRequest {
	
	public function new () {
		
	}
	
	public function getIssue (key: String, completion: Dynamic->Void) {
		
		var credentials = haxe.Resource.getString("credentials").split("\n");
		var baseUrl = credentials[0];
		var userPassword64 = encriptedCredentials();
		
		var r = new haxe.Http( baseUrl + "/jira/rest/api/2/issue/" + key );
		r.setHeader("Authorization", "Basic " + userPassword64);
		r.setHeader("Content-Type", "application/json");
		r.addParameter ("fields", "key,summary");
		r.onData = function (data: String) { 
			var json = haxe.Json.parse(data);
/*			trace(json);*/
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
		var credentials = haxe.Resource.getString("credentials").split("\n");
		var baseUrl = credentials[0];
		var user = credentials[1];
		var pass = new OSXKeychain().getPasswordForUser(user);
		var userPassword64 = haxe.crypto.Base64.encode( haxe.io.Bytes.ofString (user + ":" + pass) );
		return userPassword64;
	}
}

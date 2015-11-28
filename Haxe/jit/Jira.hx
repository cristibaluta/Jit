package jit;

class Jira {
	
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}

	public function run() {

		Sys.println("-----> Executing jira requests");
		Sys.println("Request begin");
		var credentials = haxe.Resource.getString("credentials").split("\n");
		var baseUrl = credentials[0];
		var user = credentials[1];
		var pass = credentials[2];
		var userPassword64 = haxe.crypto.Base64.encode( haxe.io.Bytes.ofString (user + ":" + pass) );
		
		var r = new haxe.Http( baseUrl + "/jira/rest/api/2/user" );
		r.setHeader("Authorization", "Basic " + userPassword64);
		r.setHeader("Content-Type", "application/json");
		r.addParameter ("username", "cbaluta");
		r.onData = function (data:String) { Sys.println(data); }
		r.onError = function (data:String) { Sys.println(data); Sys.println(r); }
		r.onStatus = function(status) { Sys.println(status); }
		r.request();
		Sys.println("Request finished");
	}
}

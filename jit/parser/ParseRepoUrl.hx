package jit.parser;

class ParseRepoUrl {

	var url: String;
	
	public function new (url: String) {
		this.url = url;
	}
	
	public function projectKey(): String {
		
		var comps = this.url.split("/");
		comps.pop();
		
		return comps.pop();
	}
	
	public function slug(): String {
		
		var comps = this.url.split("/");
		
		return comps.pop().split(".").shift();
	}
	
	public function pullRequestApiUrl(): String {

		// from https://cbaluta@bitbucket.example.com/scm/my_proj/ios.git
		// to https://bitbucket.example.com/rest/api/1.0/projects/my_proj/repos/ios/pull-requests
		
		return baseUrl() + "/rest/api/1.0/projects/" + projectKey() + "/repos/" + slug() + "/pull-requests";
	}
	
	public function pullRequestsUrl(): String {
		return baseUrl() + "/projects/" + projectKey() + "/repos/" + slug() + "/pull-requests";
	}
	
	function baseUrl(): String {
		
		var comps = this.url.split("://");
		var http = comps.shift();
		comps = comps.pop().split("/scm");
		var domain = comps.shift();
		domain = domain.split("@").pop();
		
		return http + "://" + domain;
	}
	
	public function user(): String {
		
		var comps = this.url.split("://");
		
		return comps.pop().split("@").shift();
	}
}

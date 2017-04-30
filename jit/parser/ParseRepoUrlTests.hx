package jit.parser;

class ParseRepoUrlTests extends haxe.unit.TestCase {
	
	public function testProjectKey() {
		assertEquals(new ParseRepoUrl("https://cbaluta@bitbucket.example.com/scm/bui/ios.git").projectKey(), "bui");
	}
	
	public function testSlug() {
		assertEquals(new ParseRepoUrl("https://cbaluta@bitbucket.example.com/scm/bui/ios.git").slug(), "ios");
	}
	
	public function testUser() {
		assertEquals(new ParseRepoUrl("https://cbaluta@bitbucket.example.com/scm/bui/ios.git").user(), "cbaluta");
	}
	
	public function testRequestApiUrl() {
		assertEquals(new ParseRepoUrl("https://cbaluta@bitbucket.example.com/scm/bui/ios.git").pullRequestApiUrl(), 
		"https://bitbucket.example.com/rest/api/1.0/projects/bui/repos/ios/pull-requests");
	}
	
	public function testRequestsUrl() {
		assertEquals(new ParseRepoUrl("https://cbaluta@bitbucket.example.com/scm/bui/ios.git").pullRequestsUrl(), 
		"https://bitbucket.example.com/projects/bui/repos/ios/pull-requests");
	}
}

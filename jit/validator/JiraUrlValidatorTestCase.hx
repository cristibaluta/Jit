package jit.validator;

class JiraUrlValidatorTestCase extends haxe.unit.TestCase {
	
	public function testMissingSlash() {
		assertEquals(new JiraUrlValidator().validateUrl("http://xyz.com/jira"), "http://xyz.com/jira/");
	}
	
	public function testExistingSlash() {
		assertEquals(new JiraUrlValidator().validateUrl("http://xyz.com/jira/"), "http://xyz.com/jira/");
	}
	
	public function testExtraSpaces() {
		assertEquals(new JiraUrlValidator().validateUrl(" http://xyz.com/jira  "), "http://xyz.com/jira/");
	}
}

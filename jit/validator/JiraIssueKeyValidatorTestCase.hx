package jit.validator;

class JiraIssueKeyValidatorTestCase extends haxe.unit.TestCase {
	
	public function testMissingDash() {
		assertEquals(new JiraIssueKeyValidator().validateIssueKey("AA56"), "AA-56");
	}
	
	public function testIssueWithDash() {
		assertEquals(new JiraIssueKeyValidator().validateIssueKey("AA-56"), "AA-56");
	}
	
	public function testIssueOnlyWithCharacters() {
		assertEquals(new JiraIssueKeyValidator().validateIssueKey("AAbb"), "AAbb");
	}
}
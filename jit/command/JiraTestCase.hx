package jit.command;

class JiraTestCase extends haxe.unit.TestCase {
	
	public function testExtractingIssueIdFromBranchName() {
		assertEquals(Jira.issueIdFromBranchName("AA-55_Blah_blah"), "AA-55");
	}
	
	public function testNoIssueId() {
		assertEquals(Jira.issueIdFromBranchName("master"), null);
		assertEquals(Jira.issueIdFromBranchName("develop"), null);
	}
}

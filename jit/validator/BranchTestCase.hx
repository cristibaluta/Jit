package jit.validator;

class BranchTestCase extends haxe.unit.TestCase {
	
	public function testCreateBranchName() {
		assertEquals(new Branch("_").issueTitleToBranchName("AA-55 [abc][abc def] Blah blah"), "AA-55_Blah_blah");
		assertEquals(new Branch("_").issueTitleToBranchName("AA-55  [abc][abc def]  Blah  blah"), "AA-55_Blah_blah");
		assertEquals(new Branch("_").issueTitleToBranchName("AA-55  [abc][abc def] - Blah  blah"), "AA-55_Blah_blah");
		assertEquals(new Branch("-").issueTitleToBranchName("AA-55 [abc][abc def] Blah blah"), "AA-55-Blah-blah");
	}
	
	public function testExtractingIssueIdFromBranchName() {
		assertEquals(Branch.issueIdFromBranchName("AA-55_Blah_blah"), "AA-55");
	}
	
	public function testNoIssueId() {
		assertEquals(Branch.issueIdFromBranchName("master"), null);
		assertEquals(Branch.issueIdFromBranchName("develop"), null);
	}
}

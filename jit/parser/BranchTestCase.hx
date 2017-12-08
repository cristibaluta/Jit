package jit.parser;

class BranchTestCase extends haxe.unit.TestCase {
	
	public function testCreateBranchName() {
		assertEquals(new Branch("_").issueTitleToBranchName("AA-55 [abc][abc def] Blah blah"), "AA-55_Blah_blah");
		assertEquals(new Branch("_").issueTitleToBranchName("AA-55  [abc][abc def]  Blah  blah"), "AA-55_Blah_blah");
		assertEquals(new Branch("_").issueTitleToBranchName("AA-55  [abc][abc def] - Blah  blah"), "AA-55_Blah_blah");
		assertEquals(new Branch("-").issueTitleToBranchName("AA-55 [abc][abc def] Blah blah"), "AA-55-Blah-blah");
		assertEquals(new Branch("-").issueTitleToBranchName("AA-55 [abc] Blah blah"), "AA-55-Blah-blah");
	}
	
	public function testCreateTitle() {
		assertEquals(new Branch("_").branchNameToTitle("AA-2313_some_branch_name"), "AA-2313 some branch name");
		assertEquals(new Branch("-").branchNameToTitle("AA-2313-some-branch-name"), "AA-2313 some branch name");
	}
	
	public function testExtractingIssueIdFromBranchName() {
		assertEquals(Branch.issueIdFromBranchName("AA-55_Blah_blah"), "AA-55");
		assertEquals(Branch.issueIdFromBranchName("AA-55-Blah-blah"), "AA-55");
	}
	
	public function testNoIssueId() {
		assertEquals(Branch.issueIdFromBranchName("master"), null);
		assertEquals(Branch.issueIdFromBranchName("develop"), null);
	}
}

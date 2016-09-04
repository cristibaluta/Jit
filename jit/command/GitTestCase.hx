package jit.command;

class GitMock extends Git {
	override function getLocalBranches() : Array<String> {
		return ["IOS-5_first_abc", "IOS-5_abc", "IOS-5_last_abc", "IOS-5_develop_abc", "develop"];
	}
}

class GitTestCase extends haxe.unit.TestCase {
	
	public function testMatchingNamesPriority() {
		var git = new GitMock();
		assertEquals(git.searchInLocalBranches("develop"), "develop");
		assertEquals(git.searchInLocalBranches("Develop"), "develop");
	}
	
	public function testMatchesWithLowerIndexPriority() {
		var git = new GitMock();
		assertEquals(git.searchInLocalBranches("abc"), "IOS-5_abc");
	}
}

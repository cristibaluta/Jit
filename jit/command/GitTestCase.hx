package jit.command;

class GitMock extends Git {
	override function getLocalBranches() : Array<String> {
		return ["IOS-5_first_abc", "IOS-5_abc", "* IOS-5_last_abc", "IOS-5_develop_abc", "develop", "release_MY18"];
	}
}

class GitTestCase extends haxe.unit.TestCase {
	
	public function testMatchingNamesPriority() {
		var git = new GitMock();
		assertEquals(git.searchInLocalBranches("develop", "develop"), "develop");
		assertEquals(git.searchInLocalBranches("Develop", "Develop"), "develop");
		assertEquals(git.searchInLocalBranches("release_MY18", "release_MY18"), "release_MY18");
	}
	
	public function testMatchesWithLowerIndexPriority() {
		var git = new GitMock();
		assertEquals(git.searchInLocalBranches("abc", "abc"), "IOS-5_abc");
		assertEquals(git.searchInLocalBranches("my18", "my-18"), "release_MY18");
	}
}

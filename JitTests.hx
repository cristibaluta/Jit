class JitTests {
	static function main() {
		var r = new haxe.unit.TestRunner();
		    r.add(new jit.validator.JiraIssueKeyValidatorTestCase());
			r.add(new jit.validator.JiraUrlValidatorTestCase());
			r.add(new jit.validator.StashUrlValidatorTests());
			r.add(new jit.command.GitTestCase());
			r.add(new jit.parser.ParseRepoUrlTests());
			r.add(new jit.parser.BranchTestCase());
		    r.run();
	}
}
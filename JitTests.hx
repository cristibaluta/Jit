class JitTests {
	static function main() {
		var r = new haxe.unit.TestRunner();
		    r.add(new jit.validator.JiraIssueKeyValidatorTestCase());
			r.add(new jit.validator.JiraUrlValidatorTestCase());
			r.add(new jit.validator.BranchTestCase());
			r.add(new jit.command.GitTestCase());
		    r.run();
	}
}
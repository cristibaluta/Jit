package jit;


class Jit {
	
	static public function main() : Void {
		
		var args = Sys.args();
		Sys.println(args);
		
		var jira = new Jira(args);
			jira.run();

		var git = new Git(args);
			git.run();

		var jirassic = new Jirassic(args);
			jirassic.run();
	}

	static public function printUsage() :Void {
		neko.Lib.println("Usage: haxelib run jit <task id>");
	}
}

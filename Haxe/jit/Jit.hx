package jit;


class Jit {
	
	static public function main() {
		
		var args = Sys.args();
		
		// Analize the arguments
		if (args.length == 0) {
			printUsage();
		}
		else if (args.length == 1) {
			
			var jira = new Jira(args);
				jira.run();
		}
	    else {
			
	   		var jira = new Jira([args[args.length-1]]);
	   			jira.run();
	   	}
		
/*		var git = new Git(args);
			git.run();

		var jirassic = new Jirassic(args);
			jirassic.run();*/
	}

	static public function printUsage() {
		Sys.println("Usage: 
		jit <issue key> - returns the issue title from server
		jit branch <issue key> - will create a branch with the name of the issue
		jit checkout <issue key>");
	}
}

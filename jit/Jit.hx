package jit;


class Jit {
	
	static public function main() {
		
		var args = Sys.args();
		var commands = ["open", "branch", "checkout", "commit", "setup"];
		
		// Analize the arguments
		if (args.length == 0) {
			printUsage();
		}
		else if (args.length == 1) {
			var jira = new Jira(args);
				jira.displayIssueDetails();
		}
		else {
			
			var jira = new Jira(args);
			
			switch (args[0]) {
				case "open":
					jira.openIssue( args[1] );
					
				case "branch":
					jira.openIssue( args[1] );
					var git = new Git(args);
						git.run();
/*					break;*/
			}

				/*var jirassic = new Jirassic(args);
					jirassic.run();*/
		}
	}

	static public function printUsage() {
		Sys.println( haxe.Resource.getString("usage") );
		Sys.println( "You are connected to" );
		Sys.println( haxe.Resource.getString("credentials") );
	}
}

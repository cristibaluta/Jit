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
			switch (args[0]) {
				case "open":
					var jira = new Jira(args);
					jira.openIssue( args[1] );
					
				case "branch":
					var jira = new Jira([args[1]]);
					jira.getFormattedIssueForGit( function (branchName: String) {
						var git = new Git(args);
							git.createBranchNamed( branchName );
						Sys.println( "New branch created: " + branchName );
					} );
					
				case "checkout":
				case "co":
				
				case "commit":
				
				case "setup":
				
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

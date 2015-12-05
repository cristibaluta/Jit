package jit;
import jit.validator.*;
import jit.command.*;

class Jit {
	
	static public function main() {
		
		var args = Sys.args();
		
		if (args.length == 0) {
			printUsage();
		} else {
			var command = args[0];
			switch (command) {
				case "open":
					if (hasConfig()) {
						var jira = new Jira(args);
						jira.openIssue( args[1] );
					}
					
				case "branch":
					if (hasConfig()) {
						var jira = new Jira([args[1]]);
						jira.getFormattedIssueForGit( function (branchName: String) {
							if (branchName != null) {
								var git = new Git(args);
									git.createBranchNamed( branchName );
								Sys.println( "New branch created: " + branchName );
							} else {
								Sys.println( "Server error" );
							}
						});
					}
					
				case "checkout","co":
					var issueKey = new JiraIssueKeyValidator().validateIssueKey(args[1]);
					var git = new Git(args);
					var gitBranchName = git.searchInLocalBranches( issueKey );
					if (gitBranchName != null) {
						git.checkoutBranchNamed( gitBranchName );
					} else {
						Sys.println( "Can't find a local branch containing: " + args[1] );
					}
					
				case "commit","ci","magic":
					var firstArg = args.shift();// Remove the first arg which can be -log or <issue id>
					switch (firstArg) {
						case "-log","-l":
							args.shift();
							var git = new Git(args);
							command == "magic"
							? git.commitAllAndPush(args)
							: git.commit(args);
							var jirassic = new Jirassic(args);
							jirassic.logCommit("", args);
						default:
							var git = new Git(args);
							command == "magic"
							? git.commitAllAndPush(args)
							: git.commit(args);
					}
					
				case "setup":
					var setup = new Setup();
						setup.run();
					
				case "install":
					var installer = new Installer();
						installer.run();
						
				default:
					if (hasConfig()) {
						var jira = new Jira(args);
						jira.displayIssueDetails();
					}
			}
		}
	}

	static function hasConfig() : Bool {
		var config = new Config();
		if (!config.isValid()) {
			Sys.println( "Jira credentials are missing, please run \033[1mjit setup\033[0m first" );
			return false;
		}
		return true;
	}

	static public function printUsage() {
		Sys.println( haxe.Resource.getString("usage") );
		var config = new Config();
		if (config.isValid()) {
			Sys.println( "You are connected to \033[1m"+config.getJiraUrl()+"\033[0m with user \033[1m"+config.getJiraUser()+"\033[0m\n" );
		} else {
			Sys.println( "You are not connected to Jira yet\n" );
		}
	}
}

package jit;
import jit.validator.*;
import jit.command.*;

#if cpp
import cpp.link.StaticStd;
import cpp.link.StaticRegexp;
#end

class Jit {
	
	static public function main() {
		
		var args = Sys.args();
		
		if (args.length == 0) {
			printUsage();
		} else {
			var command = args.shift();
			switch (command) {
				case "open":
					if (hasConfig()) {
						var jira = new Jira(args);
						jira.openIssue( args[0] );
					}
					
				case "current":
					var git = new Git();
					var branchName = git.currentBranchName();
					Sys.println( "Current branch: \033[1m" + branchName + "\033[0m" );
					
				case "branch":
					if (hasConfig()) {
						var jira = new Jira([args[0]]);
						jira.getFormattedIssueForGit( function (branchName: String) {
							if (branchName != null) {
								var git = new Git();
									git.createBranchNamed( branchName );
								Sys.println( "New branch created: \033[1m" + branchName + "\033[0m" );
							} else {
								Sys.println( "Server error" );
							}
						});
					}
					
				case "checkout","co":
					var issueKey = new JiraIssueKeyValidator().validateIssueKey(args[0]);
					var git = new Git();
					var gitBranchName = git.searchInLocalBranches( issueKey );
					if (gitBranchName != null) {
						git.checkoutBranchNamed( gitBranchName );
					} else {
						Sys.println( "Can't find a local branch containing: " + args[0] );
					}
					
				case "commit","ci","magic":
					var firstArg = args[0];// Remove the first arg which can be -log or <issue id>
					switch (firstArg) {
						case "-log","-l":
							args.shift();
							var git = new Git();
							command == "magic"
							? git.commitAllAndPush(args)
							: git.commit(args);
							var jirassic = new Jirassic();
							jirassic.logCommit("", args);
						default:
							var git = new Git();
							command == "magic"
							? git.commitAllAndPush(args)
							: git.commit(args);
					}
					
				case "log","jirassic":
					var jirassic = new Jirassic();
					jirassic.logCommit("", args);
					
				case "setup":
					var setup = new Setup();
						setup.run();
					
				case "install":
					var installer = new Installer();
						installer.run();
						
				default:
					// If first arg is no command means it's an <issue id>
					if (hasConfig()) {
						var jira = new Jira([command]);
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

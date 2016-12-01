package jit;
import jit.validator.*;
import jit.command.*;

#if cpp
import cpp.link.StaticStd;
import cpp.link.StaticRegexp;
#end

@:build(Versioning.make())

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
					
				case "me":
					if (hasConfig()) {
						var jira = new Jira(args);
						if (args[0] == "tasks") {
							jira.listMyTasks();
						} else {
							jira.listMyProfile();
						}
					}
					
				case "current","cu":
					var git = new Git();
					var branchName = git.currentBranchName();
					Sys.println( "Current branch: " + toBold(branchName) );
					
				case "branch":
					if (hasConfig()) {
						var jira = new Jira([args[0]]);
						jira.getFormattedIssueForGit( function (branchName: String) {
							if (branchName != null) {
								var git = new Git();
									git.createBranchNamed( branchName );
								Sys.println( "New branch created: " + toBold(branchName) );
								Sys.println("Don't forget to run \033[1mjit co\033[0m to checkout this branch");
							} else {
								Sys.println( "Server error" );
							}
						});
					}
					Sys.println("");
					
				case "checkout","co":
					var arg = args[0];
					checkout(arg);
					Sys.println("");
					
				case "pull":
					var git = new Git();
					if (args[0] != null) {
						var issueKey = new JiraIssueKeyValidator().validateIssueKey(args[0]);
						var gitBranchName = git.searchInLocalBranches( issueKey );
						if (gitBranchName != null) {
							git.checkoutBranchNamed( gitBranchName );
						}
					}
					git.pull();
					Sys.println("");
					
				case "commit","ci","magic":
					// Ask if commit to develop is ok
					var git = new Git();
					var branchName = git.currentBranchName();
					if (branchName == "develop" || branchName == "master") {
						Sys.println( "\033[1m\033[31mAre you sure you want to commit on " + branchName + "?\033[0m y/\033[31mn\033[0m" );
						do switch Sys.getChar(false) {
							case 110: return;//n
							case 121: break;//y
						}
						while (true);
					}
					
					var firstArg = args[0];// First arg can be -log
					if (firstArg == "-log" || firstArg == "-l") {
						args.shift();
					}
					var git = new Git();
					var issueId = Branch.issueIdFromBranchName( git.currentBranchName() );
					command == "magic"
					? git.commitAllAndPush( issueId == null ? args : [issueId].concat(args))
					: git.commit(args);
					
					if (firstArg == "-log" || firstArg == "-l" || command == "magic") {
						var jirassic = new Jirassic();
						jirassic.logCommit(issueId, git.currentBranchName(), args);
					}
					Sys.println("");
					
				case "history","hi":
					var config = new Config();
					var history = config.getHistory();
					if (history.length > 0) {
						if (args[0] != null) {
							// Checkout branch at specified index
							var index = args[0] == "prev" ? 2 : Std.parseInt(args[0]);
							if (index < 1) {
								index = 1;
							} else if (index > history.length) {
								index = history.length;
							}
							var gitBranchName = history[index-1];
							checkout( gitBranchName );
						} else {
							Sys.println("Latest branches accessed:\n");
							var i = 1;
							for (h in history) {
								Sys.println(" " + toBold(i + ".") + " " + h);
								i++;
							}
						}
					} else {
						Sys.println("No branches in history.");
					}
					Sys.println("");
					
				case "log","jirassic":
					var git = new Git();
					var jirassic = new Jirassic();
					jirassic.logCommit("", git.currentBranchName(), args);
					
				case "setup":
					var setup = new Setup();
						setup.run();
					
				case "install":
					var installer = new Installer();
						installer.run();
					
				case "selfinstall":
					var installer = new SelfInstaller();
						installer.run();
					
				case "version":
					var json = "{'version':'" + Jit.VERSION + "'}";
					var config = new Config();
					if (config.isValid()) {
						var url = config.getJiraUrl();
						var user = config.getJiraUser();
						json = "{'version':'" + Jit.VERSION + "', 'url':'" + url + "', 'user':'" + user + "'}";
					}
					Sys.print(json);
					
				default:
					// If first arg is no command means it's an <issue id>
					if (hasConfig()) {
						var jira = new Jira([command]);
						jira.displayIssueDetails();
					}
			}
		}
	}
	
	static function checkout (arg: String) {
		
		if (arg == "prev") {
			var config = new Config();
			var history = config.getHistory();
			if (history.length >= 2) {
				arg = history[1];
			}
		}
		var issueKey = new JiraIssueKeyValidator().validateIssueKey(arg);
		var git = new Git();
		var gitBranchName = git.searchInLocalBranches( issueKey );
		if (gitBranchName != null) {
			git.checkoutBranchNamed( gitBranchName );
			var config = new Config();
			config.addToHistory(gitBranchName);
		} else {
			Sys.println( "Can't find a local branch containing: " + arg );
		}
	}

	static function hasConfig() : Bool {
		var config = new Config();
		if (!config.isValid()) {
			Sys.println( "Jira credentials are missing, please run " + toBold("jit setup") + " first" );
			return false;
		}
		return true;
	}

	static function printUsage() {
		var usageText = haxe.Resource.getString("usage");
		usageText = StringTools.replace(usageText, "::version::", Jit.VERSION);
		usageText = StringTools.replace(usageText, "::year::", Jit.VERSION_YEAR);
		Sys.println( usageText );
		var config = new Config();
		if (config.isValid()) {
			Sys.println( "You are connected to " + toBold(config.getJiraUrl()) + " with user " + toBold(config.getJiraUser()) + "\n" );
		} else {
			Sys.println( "You are not connected to Jira yet\n" );
		}
	}
	
	static function toBold (str: String): String {
		return "\033[1m" + str + "\033[0m";
	}
}

package jit;
import jit.validator.*;
import jit.parser.*;
import jit.command.*;

#if cpp
import cpp.link.StaticStd;
import cpp.link.StaticRegexp;
#end

@:build(Versioning.make())

class Jit {
	
	static public var verbose = false;
	static public function main() {
		
		var args = Sys.args();
		verbose = args.remove("-v");
		
		if (args.length == 0) {
			printHelp();
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
					Sys.println("Current branch: " + Style.bold(branchName));
					
				case "branch":
					if (hasConfig()) {
						var jira = new Jira([args[0]]);
						jira.getFormattedIssueForGit(createBranch);
					} else {
						// If jira is not setup, create a branch name from the input arguments
						var config = new Config();
						var separator = config.getBranchSeparator();
						var branch = new Branch(separator);
						var branchName = branch.issueTitleToBranchName(args.join(" "));
						createBranch(branchName);
					}
					Sys.println("");
					
				case "checkout","co":
					var arg = args[0];
					var success = checkout(arg);
					if (!success && hasConfig()) {
						Sys.println( "Requesting branch name from Jira..." );
						// The local branch was not found, get the name from Jira and try checkout again but from remote
						var jira = new Jira([args[0]]);
						jira.getFormattedIssueForGit( function (branchName: String) {
							if (branchName != null) {
								Sys.println( "Branch name should be " + Style.bold(branchName) );
								var question = new Question( Style.bold( Style.red("Try checkout from remote? ")) );
								if (question.getAnswer() == true) {
									checkout(branchName);
								}
							} else {
								Sys.println("Server error, can't find the branch name on Jira");
							}
						});
					}
					Sys.println("");
					
				case "pull":
					var git = new Git();
					if (args[0] != null) {
						var issueKey = new JiraIssueKeyValidator().validateIssueKey(args[0]);
						var gitBranchName = git.searchInLocalBranches( args[0], issueKey );
						if (gitBranchName != null) {
							git.checkoutBranchNamed(gitBranchName);
						}
					}
					git.pull();
					Sys.println("");
					
				case "commit","ci","magic":
					// Ask if commit to develop is ok
					var git = new Git();
					var branchName = git.currentBranchName();
					if (branchName == "develop" || branchName == "master" || branchName == "main") {
						var question = new Question( Style.bold( Style.red("Are you sure you want to commit to " + branchName + "?")) );
						if (question.getAnswer() == false) {
							return;
						}
					}
					
					var firstArg = args[0];// First arg can be -log
					if (firstArg == "-log" || firstArg == "-l") {
						args.shift();
					}
					var git = new Git();
					var issueId = Branch.issueIdFromBranchName( git.currentBranchName() );
					if (command == "magic") {
						git.commitAllAndPush( issueId == null ? args : [issueId].concat(args));
						if (!git.branchIsUpstream(branchName)) {
							var question = new Question( Style.bold( Style.red("Do you want to also set this branch to upstream? ")) );
							if (question.getAnswer() == true) {
								git.setUpstream(branchName);
							}
						}
					} else {
						git.commit(args);
					}
					
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
								Sys.println(" " + Style.bold(i + ".") + " " + h);
								i++;
							}
						}
					} else {
						Sys.println("No branches in history.");
					}
					Sys.println("");
					
				case "pull-request","pr":
					if (hasConfig()) {
						var stash = new Stash([]);
						stash.createPullRequest();
						Sys.println("");
					}
					
				case "setup":
					var setup = new Setup();
					if (args[0] != null) {
						setup.runWithJson(args[0]);
					} else {
						setup.run();
					}
					
				case "selfupdate":
					var installer = new SelfInstaller();
						installer.run();
					
				case "info":
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
		
		new CheckVersion().run();
	}
	
	static function createBranch (branchName: String) {
		if (branchName != null) {
			var question = new Question( Style.bold( Style.red("Create branch named: " + branchName + "? ")) );
			if (question.getAnswer() == true) {
				var git = new Git();
					git.createBranchNamed( branchName );
				Sys.println( "New branch created: " + Style.bold(branchName) );

				var question = new Question( Style.bold( Style.red("Checkout this branch? ")) );
				if (question.getAnswer() == true) {
					checkout(branchName);
				}
			}
		} else {
			Sys.println("Cannot create a branch name from this input");
		}
	}

	static function checkout (arg: String) : Bool {
		
		if (arg == "prev") {
			var config = new Config();
			var history = config.getHistory();
			if (history.length >= 2) {
				arg = history[1];
			}
		}
		var issueKey = new JiraIssueKeyValidator().validateIssueKey(arg);
		var git = new Git();
		var gitBranchName = git.searchInLocalBranches(arg, issueKey);
		if (gitBranchName != null) {
			git.checkoutBranchNamed( gitBranchName );
			var config = new Config();
			config.addToHistory(gitBranchName);
			return true;
		} else {
			Sys.println("Can't find a local branch containing: " + arg);
			return false;
		}
	}

	static function hasConfig() : Bool {
		var config = new Config();
		if (!config.isValid()) {
			Sys.println("Jira credentials are missing, please run " + Style.bold("jit setup") + " first");
			return false;
		}
		return true;
	}

	static function printHelp() {
		var usageText = haxe.Resource.getString("usage");
		usageText = StringTools.replace(usageText, "::version::", Jit.VERSION);
		usageText = StringTools.replace(usageText, "::year::", Jit.VERSION_YEAR);
		Sys.println(usageText);
		var config = new Config();
		if (config.isValid()) {
			Sys.println("You are connected to " + Style.bold(config.getJiraUrl()) + " with user " + Style.bold(config.getJiraUser()) + "\n");
		} else {
			Sys.println("You are not connected to Jira yet\n");
		}
	}
}

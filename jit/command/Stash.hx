package jit.command;
import jit.validator.StashUrlValidator;
import jit.parser.Branch;
import jit.parser.ParseRepoUrl;

class Stash {
	
	var args: Array<String>;
	var config: Config;

	public function new (args: Array<String>) {
		this.args = args;
		this.config = new Config();
	}

	public function createPullRequest() {
		
		var git = new Git();
		var currentBranch = git.currentBranchName();
		var destinationBranch = git.getParentBranch();
		var commits = git.getCommits(currentBranch, destinationBranch);
		var description = commits.join("\n");
		
		var pushUrl = git.getPushUrl();
		var pushUrlValidator = new StashUrlValidator();
		var isValid = pushUrlValidator.isValidUrl(pushUrl);
		if (!isValid) {
			Sys.println( "Repository does not seem to be hosted in Stash; Remote url: " + pushUrl);
			Sys.println("");
			return;
		}
		
		Sys.println("");
		Sys.println(Style.red("Create a pull request"));
		Sys.println( "Of current branch: " + Style.bold(currentBranch));
		Sys.println( "To destination branch: " + Style.bold(destinationBranch));
		
		var pushUrlParser = new ParseRepoUrl(pushUrl);
		var requestUrl = pushUrlParser.pullRequestApiUrl();
		var projectKey = pushUrlParser.projectKey();
		var slug = pushUrlParser.slug();
		
		var reviewers = config.getReviewers();
		if (reviewers.length > 0) {
			Sys.println( "With reviewers: " + Style.bold(reviewers.join(",")));
		}
		Sys.println( "Commits: ");
		Sys.println( description );
		Sys.println("");
		Sys.println( "Url: " + Style.bold(pushUrlParser.pullRequestsUrl()));

		Sys.println("");
		var question = new Question( Style.bold("Do you want to make any change?") );
		if (question.getAnswer()) {
			Sys.println( "Leave blank where you want to keep the existing value");
			var input = new UserInput("Destination branch").getText();
			if (input != "") {
				destinationBranch = input;
			}
			input = new UserInput("Enter reviewers usernames separated by comma").getText();
			if (input != "") {
				config.setReviewers( input.split(",") );
			}
		}
		var question = new Question( Style.bold("Confirm pull request?") );
		if (!question.getAnswer()) {
			return;
		}
		
		var reviewers = [];
		for (username in config.getReviewers()) {
			reviewers.push( {"user": {"name": StringTools.trim(username)}} );
		}
		
		var branch = new Branch(config.getBranchSeparator());
		var title = branch.branchNameToTitle(currentBranch);
		
		var dict = {"title": title,
					"description": description,
					"state": "OPEN",
					"open": true,
					"closed": false,
					"fromRef": {"id": currentBranch, "repository": {"slug": slug, "name": null, "project": {"key": projectKey}}},
					"toRef": {"id": destinationBranch, "repository": {"slug": slug, "name": null, "project": {"key": projectKey}}},
					"locked": false,
					"reviewers": reviewers
		};
		
		var request = new JiraRequest();
		request.pullRequest (requestUrl, dict, function (response: Dynamic) {
			
			if (response != null) {
				var links: Dynamic = response.links;
				var self: Array<Dynamic> = links.self;
				var prUrl = self[0].href;
				var question = new Question( Style.bold("Pull request created successfuly, open in browser? ") + prUrl );
				if (question.getAnswer()) {
					Sys.command("open", [prUrl]);
				}
			} else {
				Sys.println( "Unknown error creating pull request" );
			}
		});
	}
	
}

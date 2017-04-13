package jit.command;

class Setup {
	
	var config: Config;
	
	public function new() {
		config = new Config();
	}
	
	public function runWithJson (content: String) {
		var values = Config.parse( content );
		var user = values.get("jira_user");
		if (user != null) {
			setJiraUser( user );
		}
		var url = values.get("jira_url");
		if (url != null) {
			setJiraUrl( url );
		}
		var password = values.get("jira_password");
		if (password != null) {
			setJiraPassword( password );
		}
	}
	
	public function run () {
		
		Sys.println( "Leave blanks when you want to keep the previous value");
		Sys.println( "Current url to Jira is: \033[1m"+config.getJiraUrl()+"\033[0m" );
		
		// Url
		var jiraUrl = param("1) Full path to Jira web app (usually it contains \033[1mjira\033[0m at the beginning or at the end)");
		if (jiraUrl != "") {
			setJiraUrl( jiraUrl );
		}
		
		// Bitbucket
		var bitbucketUrl = param("2) Full path to Bitbucket (only the root, the project is read from branches)");
		if (bitbucketUrl != "") {
			setBitbucketUrl( bitbucketUrl );
		}
		
		// Ask for username
		var user = param("3) Jira username");
		if (user != "") {
			setJiraUser( user );
		}
		
		var pass = param("4) Jira password", true);
		if (user == "") {
			user = config.getJiraUser();
		}
		if (user != "" && user != null && pass != "") {
			setJiraPassword( pass );
		}
		
		// Bitbucket
		var reviewers = param("5) Set reviewers (a list of usernames separated by comma)");
		if (reviewers != "") {
			setReviewers( reviewers );
		}
		
		// Separator
		var separator = param("\n5) Separator between branch words (- or _)");
		if (user != "") {
			if (separator != "-" && separator != "_") {
				separator = "_";
			}
			setBranchSeparator ( separator );
		}
		
		Sys.println( "\nGreat, we are done with Jira!\nCheck if the connection is working with \033[1mjit me\033[0m" );
	}
	
	function setJiraUrl (url: String) {
		config.setJiraUrl ( url );
	}
	
	function setBitbucketUrl (url: String) {
		config.setBitbucketUrl ( url );
	}
	
	function setJiraUser (user: String) {
		config.setJiraUser ( user );
	}
	
	function setJiraPassword (pass: String) {
		config.setJiraPassword ( pass );
	}
	
	function setReviewers (reviewers: String) {
		var arr = reviewers.split(",");
		config.setReviewers ( arr );
	}
	
	function setBranchSeparator (separator: String) {
		config.setBranchSeparator ( separator );
	}
	
	function param (name, ?passwd) {
		Sys.print(name + " : ");
		if (passwd) {
			var s = new StringBuf();
			do switch Sys.getChar(false) {
				case 10, 13: break;
				case c: s.addChar(c);
			}
			while (true);
			Sys.print("");
			return s.toString();
		}
		return Sys.stdin().readLine();
	}
}

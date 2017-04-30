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

		Sys.println("");
		Sys.println("You will be setting: 1) jira url, 2) username, 3) password, 4) branch separator");
		Sys.println( "Leave blanks when you want to keep the previous value");
		Sys.println("");
		
		// Url
		var str = "1) Full path to Jira web app";
		var currentUrl = config.getJiraUrl();
		if (currentUrl != null) {
			str = str + " (current: " + currentUrl + ")";
		} else {
			str = str + " (usually it contains \033[1mjira\033[0m at the beginning or at the end)";
		}
		var jiraUrl = new UserInput(str).getText();
		if (jiraUrl != "") {
			setJiraUrl( jiraUrl );
		}
		
		// Ask for username
		str = "2) Jira username";
		var currentUser = config.getJiraUser();
		if (currentUser != null) {
			str = str + " (current: " + currentUser + ")";
		}
		var user = new UserInput(str).getText();
		if (user != "") {
			setJiraUser( user );
		}
		
		var pass = new UserInput("3) Jira password").getPassword();
		if (user == "") {
			user = config.getJiraUser();
		}
		if (user != "" && user != null && pass != "") {
			setJiraPassword( pass );
		}
		
		// Separator
		str = "\n4) Separator between branch words";
		var currentSeparator = config.getBranchSeparator();
		if (currentSeparator != null) {
			str = str + " (current: " + currentSeparator + ")";
		} else {
			str = str + " (- or _)";
		}
		var separator = new UserInput(str).getText();
		if (user != "") {
			if (separator != "-" && separator != "_") {
				Sys.println( "Allowed separators are - or _. _ used" );
				separator = "_";
			}
			setBranchSeparator ( separator );
		}
		
		Sys.println( "\nSetup complete!\nCheck if the Jira connection is working with \033[1mjit me\033[0m" );
		Sys.println("");
	}
	
	function setJiraUrl (url: String) {
		config.setJiraUrl ( url );
	}
	
	function setJiraUser (user: String) {
		config.setJiraUser ( user );
	}
	
	function setJiraPassword (pass: String) {
		config.setJiraPassword ( pass );
	}
	
	function setBranchSeparator (separator: String) {
		config.setBranchSeparator ( separator );
	}
}

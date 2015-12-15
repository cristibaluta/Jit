package jit.command;

class Setup {
	
	var config: Config;
	
	public function new() {
		config = new Config();
	}
	
	public function run () {
		
		Sys.println( "Leave blank if you want to keep the previous value");
		Sys.println( "Current url to Jira is: \033[1m"+config.getJiraUrl()+"\033[0m" );
		
		var jiraUrl = param("1) Full path to Jira web app (usually it contains \033[1mjira\033[0m at the beginning or at the end)");
		if (jiraUrl != "") {
			setJiraUrl( jiraUrl );
		}
		
		// Ask for username
		var user = param("2) Jira username");
		if (user != "") {
			setJiraUser( user );
		}
		
		var pass = param("3) Jira password", true);
		if (user == "") {
			user = config.getJiraUser();
		}
		if (user != "" && user != null && pass != "") {
			setJiraPassword( pass );
		}
		
		var separator = param("\n4) Separator between branch words (- or _)");
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
	
	function setJiraUser (user: String) {
		config.setJiraUser ( user );
	}
	
	function setJiraPassword (pass: String) {
		config.setJiraPassword ( pass );
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

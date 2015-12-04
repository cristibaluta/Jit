package jit.validator;

class JiraIssueKeyValidator {

	public function new () {
		
	}
	
	public function validateIssueKey (issueKey: String): String {
		
		if (issueKey.split("-").length > 1) {
			return issueKey;
		}
		else {
			var r = ~/[0-9]+/g;
			if (r.match ( issueKey )) {
				var issueNumber = r.matched(0);
				var components = r.split ( issueKey );
				return components[0] + "-" + issueNumber;
			} else {
				return issueKey;
			}
		}
	}
}

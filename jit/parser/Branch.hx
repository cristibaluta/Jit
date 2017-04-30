package jit.parser;

class Branch {

	var separator: String;
	
	public function new (separator: String) {
		this.separator = separator;
	}
	
	public function issueTitleToBranchName (string: String) : String {
		
		string = StringTools.trim(string);
		string = (~/\[[\w ]+\]/g).replace(string, "");// Finds words between []
		string = (~/[^a-zA-Z\d-]+/g).replace(string, separator); // Finds everything except letters and numbers
		string = (~/_-_/g).replace(string, separator);
		string = (~/(_)\1+/g).replace(string, separator);
		string = (~/(-)\1+/g).replace(string, separator);
		
	    return string;
	}
	
	public function branchNameToTitle (string: String) : String {
		
		string = StringTools.replace(string, separator, " ");
		if (string.indexOf("-") == -1) {
			var comps = string.split(" ");
			if (comps.length > 2) {
				var id = comps.shift() + "-" + comps.shift();
				string = id + " " + comps.join(" ");
			}
		}
		
		return string;
	}
	
	static public function issueIdFromBranchName (branchName: String) : String {
		
		var r = ~/[A-a]+-\d+/g;
		if (r.match ( branchName )) {
			var issueId = r.matched(0);
			return issueId;
		} else {
			return null;
		}
	}
}

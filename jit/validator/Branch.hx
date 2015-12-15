package jit.validator;

class Branch {

	var separator: String;
	
	public function new (separator: String) {
		this.separator = separator;
	}
	
	public function issueTitleToBranchName (string: String) : String {
		
		string = StringTools.trim(string);
		string = (~/\[[\w ]+\]/g).replace(string, "");// Finds words between []
		string = (~/[^a-zA-Z\d-]+/g).replace(string, separator);// Finds everything except letters and numbers
		string = (~/_-_/g).replace(string, separator);
		string = (~/(_)\1+/g).replace(string, separator);
		string = (~/(-)\1+/g).replace(string, separator);
		
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

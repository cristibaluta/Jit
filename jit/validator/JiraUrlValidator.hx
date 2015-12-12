package jit.validator;

class JiraUrlValidator {

	public function new () {
		
	}
	
	public function validateUrl (url: String): String {
		
		url = StringTools.trim(url);
		if (StringTools.endsWith(url, "/")) {
			return url;
		} else {
			return url + "/";
		}
	}
}

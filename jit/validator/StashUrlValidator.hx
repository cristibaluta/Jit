package jit.validator;

class StashUrlValidator {

	public function new () {
		
	}
	
	public function isValidUrl (url: String): Bool {
		
		// Match the end of the url of form /scm/bui/ios.git
		// Scm is specific to stash
		return (~/\/(scm)\/([\w\-\.]*)\/([\w\-\.]*).git/g).match(url);
		
	}
}

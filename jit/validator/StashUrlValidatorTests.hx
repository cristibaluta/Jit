package jit.validator;

class StashUrlValidatorTests extends haxe.unit.TestCase {
	
	public function testValidUrl() {
		assertTrue(new StashUrlValidator().isValidUrl("https://cbaluta@bitbucket.mobility-media.de/scm/bui/ios.git"));
	}
	
	public function testWrongUrl() {
		assertFalse(new StashUrlValidator().isValidUrl("https://github.com/ralcr/Jit.git"));
	}
}

package jit;

class CheckVersion {
	
	var config: Config;
	
	public function new () {
		config = new Config();
	}
	
	public function run() {
		
		var lastCheck = config.getLastVersionCheckDate();
		var now = DateTools.format(Date.now(), "%y.%m.%d");
		
		if (lastCheck != now) {
			config.setLastVersionCheckDate(now);
			var remoteVersion = remoteVersion();
			if (Jit.VERSION != remoteVersion) {
				Sys.println( "-----------------------------------------------");
				Sys.println( "Jit "+toBold(remoteVersion)+" is available and you have "+toBold(Jit.VERSION)+", please run " + toBold(toRed("sudo jit selfinstall")) + " to update" );
				Sys.println( "-----------------------------------------------");
			}
		}
	}
	
	function remoteVersion() : String {
		
		// curl -s -H 'Cache-Control: no-cache' -X GET "https://raw.githubusercontent.com/ralcr/Jit/master/build/version.txt"
		
		var process = new sys.io.Process("curl", ["-s", "-H", "Cache-Control: no-cache", "-X", "GET", "https://raw.githubusercontent.com/ralcr/Jit/master/build/version.txt"]);
		
		process.exitCode();
		var result = process.stdout.readAll().toString();
		
		return result;
	}
	
	static function toBold (str: String): String {
		return "\033[1m" + str + "\033[0m";
	}
	
	static function toRed (str: String): String {
		return "\033[31m" + str + "\033[0m";
	}
}

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
				Sys.println( "------------------------------------------------------------------------------------");
				Sys.println( "Jit " + Style.bold(remoteVersion) + " is available and you have " + Style.bold(Jit.VERSION) + ", please run " + Style.bold(Style.red("sudo jit selfupdate")) + " to update" );
				Sys.println( "------------------------------------------------------------------------------------");
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
}

package jit.command;

class Installer {
	
	public function new() {
		
	}
	
	public function run() {
		
		sys.FileSystem.rename( Sys.executablePath(), binPath() + "/jit");
		
		Sys.println( "Installed to: \033[1m"+binPath()+"\033[0m" );
		Sys.println( "Great, you can now call \033[1mjit\033[0m from anywhere" );
	}
	
	public function isInstalled(): Bool {
		return sys.FileSystem.exists(binPath() + "/jit");
	}
	
	function binPath(): String {
		var paths = Sys.getEnv("PATH").split(":");
		for (path in paths) {
			if (path.indexOf("local") != -1) {// On osx El Capitan executables should stay in local/bin
				return path;
			}
		}
		return paths[0];
	}
}

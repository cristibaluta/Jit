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
		return Sys.getEnv("PATH").split(":")[0];
	}
}

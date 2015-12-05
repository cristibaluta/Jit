package jit.command;

class Installer {
	
	public function new() {
		
	}
	
	public function run () {
		
		sys.FileSystem.rename( Sys.executablePath(), binPath() + "/jit");
		
		Sys.println( "Installed to: " + binPath() );
		Sys.println( "Great, you can now type only \"jit\"" );
	}
	
	public function isInstalled(): Bool {
		return sys.FileSystem.exists(binPath() + "/jit");
	}
	
	function binPath(): String {
		return Sys.getEnv("PATH").split(":")[0];
	}
}

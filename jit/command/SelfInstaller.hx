package jit.command;

class SelfInstaller {
	
	public function new() {
		
	}
	
	private var binaryUrl = "https://raw.githubusercontent.com/cristibaluta/Jit/master/build/jit";
	
	public function run() {
		
		var installationPath = Sys.programPath();
		Sys.command("curl", ["-o", installationPath, binaryUrl]);
		Sys.command("chmod", ["+x", installationPath]);
		
		Sys.println( "Installed to: \033[1m" + installationPath + "\033[0m" );
		Sys.println( "Congrats, you now have the latest and greatest Jit" );
	}
}

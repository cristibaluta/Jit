package jit.command;

class SelfInstaller extends Installer {
	
	override public function run() {
		
		var installationPath = binPath() + "/jit";
		// installationPath = "~/Documents/jitt";
		Sys.command("curl", ["-o", installationPath, "https://raw.githubusercontent.com/ralcr/Jit/master/build/jit"]);
		Sys.command("chmod", ["+x", installationPath]);
		
		Sys.println( "Installed to: \033[1m"+installationPath+"\033[0m" );
		Sys.println( "Great, you now have the latest and greatest Jit version" );
	}
}

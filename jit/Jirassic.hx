package jit;

class Jirassic {
	
	var args: Array<String>;

	public function new (args: Array<String>) {
		this.args = args;
	}

	public function run() {
		Sys.println("-----> Executing Jirassic commands");
		// var response = Sys.command("osascript", ["-e", "tell application \"Safari\" to activate"]);
	}
}
package gits;


class Run {
	
	static public function printUsage():Void {
		neko.Lib.println("Usage: haxelib run gits <task id>");
	}

	static public function main() : Void {
		
		var args = neko.Sys.args();
		
		var last:String = (new neko.io.Path(args[args.length-1])).toString();
		var slash = last.substr(-1);
		if (slash=="/"|| slash=="\\") 
			last = last.substr(0,last.length-1);
		if (neko.FileSystem.exists(last) && neko.FileSystem.isDirectory(last)) {
			neko.Sys.setCwd(last);
		}
		
		if (args.length < 3) {
			printUsage();
			return;
		}
		
		var result:String;
		var input:String;
		try {
			input = neko.io.File.getContent(args[0]);
		} catch(e:Dynamic) {
			neko.Lib.println("Cannot read input file: "+args[0]);
			printUsage();
			return;
		}
		
		result = new JSScramble(input).output;
		
		var fout = neko.io.File.write(args[1], false);
			fout.writeString(result);
			fout.close();
	} 
}

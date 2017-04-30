package jit;

class UserInput {
	
	public function new (description: String) {
		Sys.print(description + " : ");
	}
	
	public function getText() : String {
		return Sys.stdin().readLine();
	}
	
	public function getPassword() : String {
		
		var s = new StringBuf();
		do switch Sys.getChar(false) {
			case 10, 13: break;
			case c: s.addChar(c);
		}
		while (true);
		Sys.print("");
		
		return s.toString();
	}
}
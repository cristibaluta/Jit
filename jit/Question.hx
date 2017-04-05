package jit;

class Question {
	
	public function new () {
		
	}
	
	// Respond to question with yes or no
	
	public function ask (question: String): Bool {
		Sys.println( question );
		do switch Sys.getChar(false) {
			case 110: return false;//n
			case 121: return true;//y
		}
		while (true);
	}
}
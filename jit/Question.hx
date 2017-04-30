package jit;

class Question {
	
	var question: String;
	
	public function new (question: String) {
		this.question = question;
	}
	
	// Respond to question with yes or no
	
	public function getAnswer (): Bool {
		
		Sys.println( question + " " + Style.bold(Style.red("Y")) + "/N" );
		
		do switch Sys.getChar(false) {
			case 110: return false;//n
			case 121: return true;//y
		}
		while (true);
	}
}

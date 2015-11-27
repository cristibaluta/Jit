package gits;

class Gits {
	
	static var _EOF:String = null;
	inline static var LETTERS:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
	inline static var DIGITS:String = '0123456789';
	inline static var ALNUM:String = LETTERS + DIGITS + "_";//'_$\\';
	
	inline static var END_OF_WORD = ' ()[]{}.,;:="\'/<>-+*&^%!?|\n\r';
	inline static var RESERVED_CHARS = '$';// Do not replace them or the word after
	inline static var NEEDS_SPACE_BEFORE = ' in instanceof ';
	inline static var RESERVED_WORDS = " main var function new prototype null undefined this return true false if else continue throw for in do while switch case break default call apply try catch createElement size width scrollWidth scrollHeight height left top right bottom appendChild removeChild contains childNodes firstChild hasChildNodes insertBefore parent draggable src visibility toLowerCase toUpperCase charAt charCodeAt indexOf substr substring bind split join splice push remove index length Date now getTime String Boolean Int Float Number isNaN isFinite NaN instanceof typeof length splice split scope method getMonth getDate getHours getMinutes getSeconds getFullYear hxClasses _ hasOwnProperty arguments console onresize onload onerror onmouseup onmousedown onmouseover onmouseout onmousemove onclick ondblclick ondragstart addEventListener removeEventListener MouseScroll attachEvent detachEvent wheelDelta detail focus visible toString innerHTML ";
	inline static var FOLLOWED_BY_PROPERTIES = " style document documentElement window body navigator Math Date String Number Object Array Function ";
	inline static var RESERVED_BY_USER = " MapView initWithTarget getX setX getY setY getWidth setWidth getHeight setHeight getAlpha setAlpha ";
	inline static var POS_INFOS = " fileName ";
	inline static var TRACES = " trace ";
	
	
	public static function isAlphanum(c:String):Bool {
		return (c != _EOF) && (ALNUM.indexOf(c) > -1 || c.charCodeAt(0) > 126);
	}
	
	
	
	var get_i:Int;
	var get_l:Int;
	
	private var curentChar:String;
	private var theLookahead:String;
	
	public var input(default,null):String;
	public var level(default,null):Int;
	public var output(default,null):String;
	public var oldSize(default,null):Int;
	public var newSize(default,null):Int;
	
	var currentWord :String;
	var skipNext :Bool;
	var words :Hash<String>;
	var letters :Array<String>;
	var indexes :Array<Int>;
	var nr :Int;
	
	
	public function new (p_input:String) {
		
		input = p_input;
		get_i = 0;
		get_l = input.length;
		
		theLookahead = _EOF;
		curentChar = '';
		currentWord = '';
		skipNext = false;
		words = new Hash<String>();
		letters = ALNUM.split("");
		indexes = [0,0];
		nr = 0;
		
		oldSize = input.length;
		var ret = generate();
		newSize = ret.length;
		
		trace(oldSize/1024+" Kb in");
		trace(newSize/1024+" Kb out");
		
		output = ret;
	}
	
	function generate():String {
		
		var r = new StringBuf();
		var word = "";
		var isString = false;
		var isPosInfos = false;
		var expectedStringEnd = "";
		var x = 0;
		
		while (curentChar != _EOF) {
			
			// Get the next char
			curentChar = get();
			
			if (curentChar == null) break;
			
			// If we are inside a string write it as it is, char by char
			if (isString) {
				r.add ( curentChar );
				if (expectedStringEnd == curentChar) {
					// End of string detected
					isString = false;
					word = "";
				}
			}
			
			// Begining of a string
			else if ( curentChar == "\"" || curentChar == "'") {
				// Do not scramble strings
				if ( ! isString ) {
					r.add ( curentChar );
					isString = true;
					expectedStringEnd = curentChar;
				}
			}
			
			// $ char
			else if ( RESERVED_CHARS.indexOf ( curentChar ) > -1) {
				skipNext = true;
				r.add ( curentChar );
			}
			
			// Building the word (all alphanumerics)
			else if ( END_OF_WORD.indexOf ( curentChar ) == -1) {
				word += curentChar;
			}
			
			// Word found, analyze it
			else if (word != "") {
				
				// Leave in peace the reserved words
				if ( RESERVED_WORDS.indexOf (" "+word+" ") > -1) {
					
					skipNext = false;
					if ( NEEDS_SPACE_BEFORE.indexOf (" "+word+" ") > -1 )
					r.add ( " " );
					r.add ( word );
					r.add ( curentChar );
				}
				else if (	FOLLOWED_BY_PROPERTIES.indexOf (" "+word+" ") > -1 || 
							RESERVED_BY_USER.indexOf (" "+word+" ") > -1)
				{
					// Only the dot char can skip the next word
					if (curentChar == ".")
						skipNext = true;
					r.add ( word );
					if (curentChar != " " /*&& curentChar != "\n"*/)
						r.add ( curentChar );
				}
				else {
					if (skipNext) {
						// Probably a property, so we need to leave it as it is
						skipNext = false;
						r.add ( word );
						//r.add ( curentChar );
					}
					else {
						// Scramble this word
						r.add ( scrambleWord ( word ) );
					}
					// Print the next char only if it's not a space or a new line
					if (curentChar != " " /*&& curentChar != "\n"*/)
						r.add ( curentChar );
					
				}
				word = "";
			}
			
			// Print current chars
			else if (curentChar != " ") {
				// End of the word delimiters, print them
				//trace("r.add "+curentChar);
				//if ( END_OF_WORD.indexOf (curentChar) > -1)
				skipNext = false;
				r.add ( curentChar );
			}
		}

		return r.toString();
	}
	
	// This function can came up with 1849(43*43) unique scrambled words
	// One letter words are used as they are
	function scrambleWord (word:String) :String {
		
		// Check if the word is in fact a number
		if (word.length == 1) {
			return word;
		}
		if (Std.parseInt(word) != null) {
			return word;
		}
		else if (words.exists(word)) {
			return words.get(word);
		} else {
			var scrambledWord = "" + letters[ indexes[0] ] + letters[ indexes[1] ];
			words.set (word, scrambledWord);
			
			nr ++;
			indexes[1] = indexes[1]+1;
			if (indexes[1] > letters.length-1) {
				indexes[1] = 0;
				indexes[0] = indexes[0] + 1;
			}
			
			return scrambledWord;
		}
		return "";
	}
	
	/* get -- return the next character. Watch out for lookahead. If the
			character is a control character, translate it to a space or
			linefeed.
	*/
	function get():String {
		var c = theLookahead;
		if (get_i == get_l) {
			return _EOF;
		}
		theLookahead = _EOF;
		if (c == _EOF) {
			c = input.charAt(get_i);
			++get_i;
		}
		if (c >= ' ' || c == '\n') {
			return c;
		}
		if (c == '\r') {
			return '\n';
		}
		return ' ';
	}
	
}

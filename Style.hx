class Style {
	
	public static function bold (str: String): String {
		return "\033[1m" + str + "\033[0m";
	}
	
	public static function red (str: String): String {
		return "\033[31m" + str + "\033[0m";
	}
}

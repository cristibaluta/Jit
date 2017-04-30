package jit;
import haxe.io.Eof;
import sys.io.*;
import jit.security.*;

/**
Config file is of form:
	jira_url=url
	jira_user=user
	branch_words_separator=_ or -
	history=branch1;branch2;branch3
*/
class Config {
	
	private var kJiraUrlKey = "jira_url";
	private var kJiraUserKey = "jira_user";
	private var kBranchWordsSeparatorKey = "branch_words_separator";
	private var kLastVersionCheckDateKey = "last_version_check_date";
	private var kHistoryKey = "history";
	private var kReviewersKey = "reviewers";
	private var kSeparator = ";";
	private var kHistoryMaxItems = 5;
	private var values = new Map<String, String>();
	
	public function new() {
		var path = configFilePath();
		if (!sys.FileSystem.exists(path)) {
			var fout = File.write(path, false);
				fout.close();
		}
		values = Config.parse( File.getContent( path));
	}
	
	public static function parse (content: String) : Map<String, String> {
		var values = new Map<String, String>();
		var lines = content.split("\n");
		for (line in lines) {
			var comps = line.split("=");
			if (comps[0] == null || comps[0] == "") {
				continue;
			}
			if (comps.length != 2) {
				continue;
			}
			values.set(comps[0], comps[1]);
		}
		return values;
	}

	public function isValid() : Bool {
		return getJiraUrl() != null && getJiraUser() != null;
	}
	
	// Jira url
	public function getJiraUrl() : String {
		return values.get(kJiraUrlKey);
	}
	public function setJiraUrl (url: String) {
		values.set(kJiraUrlKey, url);
		save();
	}
	
	// User
	public function getJiraUser() : String {
		return values.get(kJiraUserKey);
	}
	public function setJiraUser (user: String) {
		values.set(kJiraUserKey, user);
		save();
	}
	
	// Separator
	public function getBranchSeparator() : String {
		var separator = values.get(kBranchWordsSeparatorKey);
		if (separator == null) {
			separator = "_";
		}
		return separator;
	}
	public function setBranchSeparator (separator: String) {
		values.set(kBranchWordsSeparatorKey, separator);
		save();
	}
	
	// History
	public function getHistory() : Array<String> {
		var history = [];
		var historyString = values.get(kHistoryKey);
		if (historyString != null) {
			history = historyString.split(kSeparator);
		}
		return history;
	}
	public function addToHistory (branchName: String) {
		var history = getHistory();
		history.insert(0, branchName);
		history = history.slice(0, kHistoryMaxItems);
		values.set(kHistoryKey, history.join(kSeparator));
		save();
	}
	
	// Reviewers
	public function getReviewers() : Array<String> {
		var reviewers = [];
		var reviewersString = values.get(kReviewersKey);
		if (reviewersString != null) {
			reviewers = reviewersString.split(kSeparator);
		}
		return reviewers;
	}
	public function setReviewers (reviewers: Array<String>) {
		values.set(kReviewersKey, reviewers.join(kSeparator));
		save();
	}
	
	// Password
	public function getJiraPassword() : String {
		var keychain = new Keychain();
		return keychain.getPasswordForUser (getJiraUser());
	}
	public function setJiraPassword (pass: String) {
		var keychain = new Keychain();
		keychain.setUserAndPassword (getJiraUser(), pass);
	}
	
	// Version check
	public function getLastVersionCheckDate() : String {
		return values.get(kLastVersionCheckDateKey);
	}
	public function setLastVersionCheckDate (date: String) {
		values.set(kLastVersionCheckDateKey, date);
		save();
	}
	
	
	function save() {
		var content = [];
		for (key in values.keys()) {
			content.push(key + "=" + values.get(key));
		}
		var fout = File.write( configFilePath(), false );
			fout.writeString( content.join("\n") );
			fout.close();
	}
	
	function configFilePath() : String {
		var homeDir = Sys.getEnv("HOME");
		var configFile = homeDir + "/.jitconfig";
		return configFile;
	}
}

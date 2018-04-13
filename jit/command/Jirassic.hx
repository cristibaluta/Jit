package jit.command;

// enum TaskType {
// 	case Issue = 0
// 	case StartDay = 1
// 	case Scrum = 2
// 	case Lunch = 3
// 	case Meeting = 4
// 	case GitCommit = 5
// }

class Jirassic {
	
	public function new () {
		
	}

	// osascript -e "tell application \"Jirassic\" to set tasks to \"abcdefghij\""
	public function logCommit (taskNumber: String, branchName: String, comments: Array<String>) {
		var notes = comments.join(" ");
		var json = "{'taskType':'5', 'taskNumber':'" + taskNumber + "', 'branchName':'" + branchName + "', 'notes':'" + notes + "'}";
		Sys.command("osascript", ["-e", "tell application \"Jirassic\" to create task \"" + json +"\""]);
	}
	
	public function logIssue (branchName: String, comments: Array<String>) {
		var notes = comments.join(" ");
		var json = "{'taskType':'0', 'taskNumber':'null', 'branchName':'" + branchName + "', 'notes':'" + notes + "'}";
		Sys.command("osascript", ["-e", "tell application \"Jirassic\" to create task \"" + json +"\""]);
	}
}

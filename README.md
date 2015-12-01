# Jit
Git command line tool that connects to jira and creates branches by specifying issue id only. It doesn't even have to be exact, variations of uppercases and lowercases allowed, and - between characters and numbers can miss.

Jit connects to the jira server and gets the complete issue title then transforms it to a valid git branch name.
Ex:

jira issue id: AA-55
jira issue title: [AA] - Blah blah blah

Jit can create a branch named: AA-55_Blah_blah_blah

To switch branches you will type only: jit checkout aa55


To compile this little tool you need Haxe and the hxssl lib

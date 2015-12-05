# Jit
Git Mac (for now) command line tool that lets you create branches by specifying the jira task number only. 
It connects to Jira to find the task title then formats it properly as a valid branch name.

### Commands
Only the most basic commands are implemented that deals with branch names.
Ex you have an issue with this details:
  
  id: AA-55
  title: [AA] - Blah blah blah

To create a local branch named "AA-55_Blah_blah_blah" for this task you'd do:

	jit branch aa55	

To switch branches you will type: 

	jit checkout aa55 // Case insensitive and no need to put the dash, jit will separate the chars from numbers with a dash
	or
	jit checkout blah // Switches to the first branch containing "blah"
	or
	jit co aa55 // Checkout is too long? There's even the "co" shortcut

Commiting to repo:

	jit commit Some commit message here // As you can see, no need for "", jit knows that after commit follows a message
	jit ci Some commit message here // Shortcut available here also

For a complete list of commands and details run

	jit

### Installing

 1. Download the executable from build directory then run

	sudo ./jit install

 2. Download the sources and compile yourself. Sources are in Haxe and dependencies are hxcpp. After you compile you still need to do step 1 if you want to call the app from anywhere

### Other
Some of the commands need to connect to Jira, you need to run jit setup to configure it, but you'll be alerted when will be the case.

Some of the commands need a Mac because it uses AppleScript to tell osx to do stuffs

### ToDo
Doesn't deal with errors very well, need to take into account errors everywhere

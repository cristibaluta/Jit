# Jit
Git command line tool that lets you create branches by specifying the id only. It connects to Jira to find the task title then formats it properly as a valid branch name. It runs on Mac for now.
Ex you have an issue with this details:

id: AA-55
title: [AA] - Blah blah blah

To create a local branch named "AA-55_Blah_blah_blah" for this task you'd do:

	jit branch aa55	

To switch branches you will type: 

	jit checkout aa55 // 
	or
	jit checkout blah // first match from local branches
	or
	jit co aa55 // call it with the well known shortcut co

### Installing

 1. Download the executable from build directory then run

	sudo ./jit install

 2. Download the sources and compile yourself. Sources are Haxe and dependencies are hxcpp haxelib. After you compile you still need to do step 1 if you want to call the app from anywhere

### Setup
Some of the commands need to connect to Jira, you need to run jit setup to configure it, but you'll be asked when needed.

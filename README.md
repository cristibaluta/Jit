# Jit
Jira and Git brought together, create and switch branches by knowing only the task id.
Jit connects to Jira to find the task title then formats it properly as a valid branch name.

![Screenshot](https://s29.postimg.org/k30u3u3x3/jit.png)

## Commands
Given a jira task with this details:
  
  task id: AA-55
  
  task title: [AA] - Blah blah blah

To create a local branch named "AA-55_Blah_blah_blah" for this task you'd do:

	jit branch aa55	

To switch branches you will type: 

	jit checkout aa55 // Case insensitive and no need to put the dash, jit will separate the chars from numbers with a dash
	or
	jit checkout blah // Switches to the first branch containing "blah"
	or
	jit co aa55 // Checkout is too long? There's even the "co" shortcut

Commiting to repo:

	jit commit <Some commit message> // As you can see, no need for "", jit knows that after commit word follows the message
	jit ci <Some commit message> // The "ci" shortcut for commit
	jit magic <Some commit message> // Add files to stage, commits, then pushes to server

For a complete list of commands and details run

	jit

## Installing on macOS

Run this commands in Terminal

	sudo curl -o /usr/local/bin/jit https://raw.githubusercontent.com/ralcr/Jit/master/build/jit
	chmod +x /usr/local/bin/jit

Or download the executable from the build directory then run

	sudo ./jit install

If you already have jit, you can update it to the latest version by running

    sudo jit selfinstall

## Compile from sources
To compile you need the Haxe compiler (http://haxe.org) and the hxcpp haxelib. You must also create manually a 'cpp' folder where Haxe will compile the app.
 
	haxelib install hxcpp // Install the hxcpp dependency
	haxe compile.hxml // Compile the application
	cd build
	sudo ./jit install // Install the app to usr/local/bin
	jit // Check installation

Win and linux versions in theory can work, in practice didn't tested. They also must implement different logic for the password storage. Get in touch if you'd like to contribute with this.

## Setup Jira
To setup your jira credentials run and follow instructions

    jit setup

## Changes
###17.02.11
- Fixed checkout local branches with simple words
###17.04.06
- Check for updates once a day, so you don't miss the latest and greatest improvements
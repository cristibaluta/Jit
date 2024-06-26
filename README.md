# Jit
Jira and Git brought together, create and switch branches by knowing only the task id.
Jit connects to Jira to find the task title then formats it properly as a valid branch name.

## Commands
Given a jira task with this details:
  
  task id: AA-55
  
  task title: [AA] - Blah blah blah

To create a local branch named "AA-55_Blah_blah_blah" for this task you'd do one of the following:

	jit branch aa55 // Makes a request to jira server to aquire the title
	jit branch "AA-55 \n[AA] - Blah blah blah" // Parses the input. It can ignore the new lines if the text is added in quotes

To switch branches you will type: 

	jit checkout aa55 // Case insensitive and no need to put the dash, jit will separate the chars from numbers with a dash
	jit checkout blah // Switches to the first branch containing "blah"
	jit co aa55 // Checkout is too long? There's even the "co" shortcut
	jit co 55 // Switches to the first branch containing "55"

Commiting to repo:

	jit commit <commit message> // No need to wrap the message in "", jit knows that after commit word follows the message
	jit ci <commit message> // The "ci" shortcut for commit
	jit magic <commit message> // Add files to stage, commits, pushes to server, logs time to Jirassic

### jit magic
This is a magical command that will:
- Add the changed files to stage
- Commit
- Push
- Log time to Jirassic


Create pull requests in stash:

	jit pr

For a complete list of commands and details run

	jit

## Installing on macOS

Run this commands in Terminal to download the executable and to give it permissions

	sudo curl -o /usr/local/bin/jit https://raw.githubusercontent.com/cristibaluta/Jit/master/build/jit
	sudo chmod +x /usr/local/bin/jit

If you already have jit, you can update it to the latest version by running

    sudo jit selfupdate

## Compile from sources
To compile you need the Haxe compiler (http://haxe.org) and the hxcpp haxelib. You must also create manually a 'cpp' folder where Haxe will compile the app.

	haxelib install hxcpp // Install the hxcpp dependency
	haxelib install hx3compat // Install lib with api from haxe3 that was removed in api4 (for unit testing)
	haxe compile.hxml // Compile the application. Run with sudo if you are missing some writing permissions

Win and linux versions in theory should work, in practice didn't tested. They also must implement different logic for the password storage. Get in touch if you'd like to contribute with this.

## Setup Jira
To setup your jira credentials run and follow instructions

    jit setup

## Changelogs

###24.06.10
- Update to Haxe4
- Create branches from task titles

###17.02.11
- Fixed checkout local branches with simple words

###17.04.06
- Check for updates once a day, so you don't miss the latest and greatest improvements

###17.04.11
- After each push ask to set the branch to upstream if not already set

###17.04.30
- Added command to create pull requests on stash

###17.05.06
- Added confirmation to proceed with the pull request and posibility to change parent branch if not detected correctly

microsoftvisualstudiocode-insiders|\
visualstudiocode-insiders)
    # Team Demogorgon Label
    name="Visual Studio Code - Insiders"
    type="zip"
    expectedTeamID="UBF8T346G9"
    appName="Visual Studio Code - Insiders.app"
    codeBinPath="/Applications/${appName}/Contents/Resources/app/bin/code"
    if [[ -e "$codeBinPath" ]]
    then
    	appCustomVersion(){ $codeBinPath --version | sed -n -e 2p }
    	currentBuildCommit=$(appCustomVersion)
    	currentVersionReadable=$($codeBinPath --version | sed -n -e 1p)
    	feedURL="https://update.code.visualstudio.com/api/update/darwin-universal/insider/${currentBuildCommit}"
    	exec 3>&1 ## make a temp file descriptor for curl http status output
   		{
        	IFS=$'\n' read -r -d '' feedJSON; 
        	IFS=$'\n' read -r -d '' feedHttpStatus;
    	} < <((printf '\0%s\0' "$(curl -fsL -w "%{http_code}" -o >(cat >&3) "${feedURL}")" 1>&3) 3>&1) ## assigns two vars from one command by creating and parsing a single string from multiple outputs
    	exec 3>&- #$ close the temp file descriptor
    	if [[ -z "$feedJSON" && "$feedHttpStatus" == "204" ]]
    	then
        	appNewVersion="$currentBuildCommit"
        	downloadURL="null"
    	elif [[ -z "$feedJSON" && "$feedHttpStatus" == 4* ]]
    	then
        	printlog "Unable to determine new version.  Cannot update." ERROR
    	elif [[ -n "$feedJSON" && "$feedHttpStatus" == "200" ]]
    	then 
        	downloadURL=$(JSON="$feedJSON" osascript -l 'JavaScript' -e 'const env = $.NSProcessInfo.processInfo.environment.objectForKey("JSON").js' -e "JSON.parse(env).url")
        	appNewVersion=$(JSON="$feedJSON" osascript -l 'JavaScript' -e 'const env = $.NSProcessInfo.processInfo.environment.objectForKey("JSON").js' -e "JSON.parse(env).version")
	        appNewVersionReadable=$(JSON="$feedJSON" osascript -l 'JavaScript' -e 'const env = $.NSProcessInfo.processInfo.environment.objectForKey("JSON").js' -e "JSON.parse(env).productVersion")
    	    printlog "Success: Found ${appName} with readable version: ${currentVersionReadable}, and commit: ${currenetVersion}." INFO
        	printlog "Success: Discovered insider update feed json with a new build of version: ${appNewVersionReadable}." INFO
    	else     
        	printlog "Critical update information not found." ERROR
        	printlog "Current readable version: ${currentVersionReadable}, and current build commit: ${currentBuildCommit}."
        	printlog "Update feed json: ${feedJSON}."
    	fi
    else
    	printlog "This is a new install, and not an update.  Using generic download url." INFO
    	downloadURL="https://code.visualstudio.com/sha/download?build=insider&os=darwin-universal"
        curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36" )
	fi
    ;;

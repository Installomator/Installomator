levelscreenrecorder)
	name="Level Screen Recorder"
	type="dmg"
	if [[ "$(arch)" == "arm64" ]]; then platformKey="osx_arm64"; else platformKey="osx_64"; fi
	levelScreenRecorderJSON=$(curl -fsL "https://sr-releases.thelevel.ai/versions/sorted?page=0")
	i=0; appNewVersion=""
	while channelName=$(getJSONValue "$levelScreenRecorderJSON" "items[$i].channel.name" 2>/dev/null); do
		j=0
		while assetPlatform=$(getJSONValue "$levelScreenRecorderJSON" "items[$i].assets[$j].platform" 2>/dev/null); do
			if [[ "$channelName" == "stable" && "$assetPlatform" == "$platformKey" && "$(getJSONValue "$levelScreenRecorderJSON" "items[$i].assets[$j].filetype" 2>/dev/null)" == ".dmg" ]]; then
				appNewVersion=$(getJSONValue "$levelScreenRecorderJSON" "items[$i].name")
				break
			fi
			j=$((j + 1))
		done
		[[ -n "$appNewVersion" ]] && break
		i=$((i + 1))
	done
	[[ -n "$appNewVersion" ]] || cleanupAndExit 95 "could not determine latest Level Screen Recorder macOS version" ERROR
	downloadURL="https://sr-releases.thelevel.ai/download/flavor/default/${appNewVersion}/${platformKey}?filetype=.dmg"
	expectedTeamID="2HBZBC3S5M"
	;;

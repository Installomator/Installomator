levelscreenrecorder)
	name="Level Screen Recorder"
	type="dmg"
	if [[ "$(arch)" == "arm64" ]]; then platformKey="osx_arm64"; else platformKey="osx_64"; fi
	jsonTmp=$(mktemp); plistTmp=$(mktemp)
	curl -fsL "https://sr-releases.thelevel.ai/versions/sorted?page=0" | tr -d '\n' | sed -E 's/:[[:space:]]*null[[:space:]]*([],}])/:""\1/g' > "$jsonTmp" && plutil -convert xml1 -o "$plistTmp" "$jsonTmp"
	i=0; appNewVersion=""
	while channelName=$(/usr/libexec/PlistBuddy -c "Print items:${i}:channel:name" "$plistTmp" 2>/dev/null); do
		if [[ "$channelName" == "stable" ]]; then j=0; while assetPlatform=$(/usr/libexec/PlistBuddy -c "Print items:${i}:assets:${j}:platform" "$plistTmp" 2>/dev/null); do [[ "$assetPlatform" == "$platformKey" && "$(/usr/libexec/PlistBuddy -c "Print items:${i}:assets:${j}:filetype" "$plistTmp" 2>/dev/null)" == ".dmg" ]] && { appNewVersion=$(/usr/libexec/PlistBuddy -c "Print items:${i}:name" "$plistTmp" 2>/dev/null); break; }; j=$((j + 1)); done; fi
		[[ -n "$appNewVersion" ]] && break; i=$((i + 1))
	done
	rm -f "$jsonTmp" "$plistTmp"
	downloadURL="https://sr-releases.thelevel.ai/download/flavor/default/${appNewVersion}/${platformKey}?filetype=.dmg"
	expectedTeamID="2HBZBC3S5M"
	;;

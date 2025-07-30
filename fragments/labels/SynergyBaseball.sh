synergybaseball)
    name="Synergy Baseball"
    type="dmg"
    downloadURL="$( echo https://www.synergysportstech.com/baseballclient/MacOS/$(curl -s https://www.synergysportstech.com/baseballclient/MacOS/default.htm | grep dmg | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}') )"
    appNewVersion=$(curl -fs https://www.synergysportstech.com/baseballclient/MacOS/default.htm | grep Version: | grep -o -e "[0-9.]*")
	versionKey="CFBundleVersion"
    expectedTeamID="BATB6XS52B"
    ;;


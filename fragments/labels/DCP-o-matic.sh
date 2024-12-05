dcp-o-matic|dcpomatic|dcp-o-matic2|dcpomatic2)
    name="DCP-o-matic 2"
    type="dmg"
    appNewVersion=$(curl -fs https://dcpomatic.com/download | grep "Stable release: " | awk -F '</p>' '{print $1}' | grep -o -e "[0-9.]*")
    downloadURL="https://dcpomatic.com/dl.php?id=osx-10.10-main&version=$appNewVersion&paid=0"
	versionKey="CFBundleVersion"
    expectedTeamID="R82DXSR997"
    ;;

installomatormate)
	name="InstallomatorMate"
	type="zip"
	downloadURL="https://hennig.nu/repo/installomatormate/InstallomatorMate.zip"
    appNewVersion=$( curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs https://hennig.nu/repo/installomatormate/appcast.xml | sed -n 's/.*<sparkle:shortVersionString>\(.*\)<\/sparkle:shortVersionString>.*/\1/p' | head -1 )
	expectedTeamID="AGXG97HK25"
	;;

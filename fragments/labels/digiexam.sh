digiexam)
	name="Digiexam"
	type="dmg"
	downloadURL="https://www.digiexam.com/hubfs/client/Digiexam_Mac.dmg"
    appNewVersion=$( curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs https://support.digiexam.se/hc/en-us/articles/7119593625628-Client-updates | perl -ne 'print if /Version(?!.*Only(?!.*Mac))(?=.*Mac)?/' | head -1 | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p' )
	expectedTeamID="73T9H7VE4P"
	;;

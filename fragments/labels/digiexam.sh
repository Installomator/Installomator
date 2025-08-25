digiexam)
	name="Digiexam"
	type="dmg"
    downloadURL="https://www.digiexam.com/hubfs/client/Digiexam_Mac_universal.dmg"
    appNewVersion=$( curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs https://www.digiexam.com/release-notes | sed -ne '/<h2>Macbook<\/h2>/,$p' | grep -Eo 'Release \d{2,}.\d.\d{2,}' | head -1 | awk '{ print $NF }' )
	expectedTeamID="73T9H7VE4P"
	;;

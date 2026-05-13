daruma)
	name="Daruma"
	type="dmg"
	bundleID="app.kadomaru.daruma"
	downloadURL="https://delivery.kadomaru.app/daruma/Daruma.dmg"
	appNewVersion="$(curl -fs https://delivery.kadomaru.app/daruma/appcast.xml | xpath 'string(//item[1]/sparkle:shortVersionString')"
	expectedTeamID="TRLMQKJQ97"
	;;

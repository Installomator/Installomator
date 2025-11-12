whiterabbit)
	name="White Rabbit"
	type="dmg"
	bundleID="app.kadomaru.white-rabbit"
	downloadURL="https://delivery.kadomaru.app/white-rabbit/White%20Rabbit.dmg"
	appNewVersion="$(curl -fs https://delivery.kadomaru.app/white-rabbit/appcast.xml | xpath 'string(//item[1]/sparkle:shortVersionString')"
	expectedTeamID="TRLMQKJQ97"
	;;

busycal)
	# A powerful calendar app for macOS and iOS that offers customizable views, integrated task management, and seamless cloud sync
    name="BusyCal"
    type="dmg"
    downloadURL=$(curl -fs https://www.busymac.com/busycal/releasenotes.html | grep -o 'https://www.busymac.com/download/bcl-\S*\.dmg' | sort -V | tail -n 1)
    appNewVersion=$(curl -fs https://www.busymac.com/busycal/releasenotes.html | awk -F 'BusyCal ' '/BusyCal [0-9]+\.[0-9]+\.[0-9]+/{print $2}' | sort -V | tail -n 1)
    expectedTeamID="N4RA379GBW"
    ;;
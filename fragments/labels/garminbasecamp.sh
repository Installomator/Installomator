garminbasecamp)
    name="Garmin BaseCamp"
    type="pkgInDmg"
    downloadURL=$(curl -fs "https://www8.garmin.com/support/download_details.jsp?id=4449" | grep -Eo 'BaseCampforMac_[0-9]+\.dmg' | sort -V | tail -1 | sed 's#^#https://download.garmin.com/software/#')
    appNewVersion=$(curl -fs "https://www8.garmin.com/support/download_details.jsp?id=4449" | grep "BaseCamp for Mac software version" | head -n 2 | tail -n 1 | sed -E 's/.* ([0-9\.]*) .*/\1/g')
    expectedTeamID="72ES32VZUA"
    appName="BaseCamp.app"
    ;;

parallelsrasclient)
    name="Parallels Client"
    type="pkg"
    appNewVersion=$(curl -sf "https://download.parallels.com/ras/v18/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*Version \(.*\) -.*|\\1|" | sed 's/ /./g' | sed 's/[^0-9.]//g')
    downloadURL=$(appMajorVersion=`sed 's/\..*//' <<< $appNewVersion` && appHyphenVersion=`curl -sf "https://download.parallels.com/ras/v18/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*Version \(.*\) -.*|\\1|" | sed 's/ /-/g' | sed 's/[^0-9.-]//g'` && echo https://download.parallels.com/ras/v"$appMajorVersion"/"$appNewVersion"/RasClient-Mac-Notarized-"$appHyphenVersion".pkg)
    expectedTeamID="4C6364ACXT"
    ;;

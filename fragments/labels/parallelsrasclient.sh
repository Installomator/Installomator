parallelsrasclient)
    name="Parallels Client"
    type="pkg"
    appMajorVersion=$(curl -sf "https://download.parallels.com/website_links/ras/index.json" | head -2 | tail -1 | tr -dc "[:alnum:]")
	appFirstCommaVersion=$(curl -sf "https://download.parallels.com/ras/v"$appMajorVersion"/docs/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*Version \(.*\) (.*|\\1|" | cut -d. -f-2)
    # appSecondCommaVersion=$(curl -sf "https://download.parallels.com/ras/v"$appMajorVersion"/docs/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*Version \(.*\) (.*|\\1|")
    appRealVersion=$(curl -sf "https://download.parallels.com/ras/v"$appMajorVersion"/docs/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*(\(.*\)).*|\\1|")
    # appDownloadVersion=$(curl -sf "https://download.parallels.com/ras/v"$appMajorVersion"/docs/RAS%20Client%20for%20Mac%20Changelog.txt" | grep -m 1 "Parallels Client for Mac Version" | sed "s|.*Version \(.*\) -.*|\\1|" | sed 's/ /./g' | sed 's/[^0-9.]//g')
    appNewVersion=$appFirstCommaVersion.$appRealVersion
    # downloadURL=https://download.parallels.com/ras/v"$appMajorVersion"/"$appSecondCommaVersion"."$appRealVersion"/RasClient-Mac-Notarized-"$appSecondCommaVersion"-"$appRealVersion".pkg
    downloadURL=$(curl -fs https://download.parallels.com/website_links/ras/$appMajorVersion/builds-en_US.json | grep '"Mac Client":' | cut -d ":" -f2- | cut -d '"' -f2)
    expectedTeamID="4C6364ACXT"
    ;;

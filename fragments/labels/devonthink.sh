devonthink)
    name="DEVONthink"
    type="appInDmgInZip"
    devonPlist=$(curl -fsL "https://www.devontechnologies.com/Updates.plist?product=DEVONthink&version=4.0.0")
    appNewVersion=$(echo "$devonPlist" | plutil -extract "DEVONthink" raw -o - -)
    downloadURL="https://download.devontechnologies.com/download/devonthink/${appNewVersion}/DEVONthink.dmg.zip"
    expectedTeamID="679S2QUWR8"
    ;;

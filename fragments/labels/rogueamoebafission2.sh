rogueamoebafission2)
    name="Fission"
    type="zip"
    downloadURL="https://www.rogueamoeba.com/fission/download.php"
    appNewVersion="$(curl -fs "https://rogueamoeba.net/ping/versionCheck.cgi?format=sparkle&bundleid=com.rogueamoeba.Fission&system=1100&version=20000000" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="7266XEXAPM"
    ;;

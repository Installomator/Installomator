rogueamoebafission2)
    name="Fission"
    type="zip"
    raSysVer="$(sw_vers -productVersion | sed 's/\.//g')"
    raVerDetails="$(curl -fs "https://rogueamoeba.net/ping/versionCheck.cgi?format=sparkle&bundleid=com.rogueamoeba.Fission&system=${raSysVer}&version=20000000")"
    downloadURL="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@url)' 2>/dev/null)"
    appNewVersion="$(echo "${raVerDetails}" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="7266XEXAPM"
    ;;

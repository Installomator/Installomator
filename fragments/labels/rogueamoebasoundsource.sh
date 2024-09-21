rogueamoebasoundsource5)
    name="SoundSource"
    type="zip"
    downloadURL="https://rogueamoeba.com/soundsource/download.php"
    appNewVersion="$(curl -fs "https://rogueamoeba.net/ping/versionCheck.cgi?format=sparkle&bundleid=com.rogueamoeba.soundsource&platform=osx&version=5000000" | xpath 'string(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null)"
    expectedTeamID="7266XEXAPM"
    ;;

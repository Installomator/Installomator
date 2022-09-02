synologyassistant)
    name="SynologyAssistant"
    type="dmg"
    packageID="com.synology.DSAssistant"
    appNewVersion="$(curl -sf https://archive.synology.com/download/Utility/Assistant | grep -m 1 /download/Utility/Assistant/ | sed "s|.*>\(.*\)<.*|\\1|")"
    downloadURL="https://global.download.synology.com/download/Utility/Assistant/${appNewVersion}/Mac/synology-assistant-${appNewVersion}.dmg"
    expectedTeamID="X85BAK35Y4"
    ;;

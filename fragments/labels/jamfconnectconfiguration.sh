jamfconnectconfiguration)
    name="Jamf Connect Configuration"
    type="dmg"
    downloadURL="https://files.jamfconnect.com/JamfConnect.dmg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep "x-amz-meta-version" | grep -o "[0-9.].*[0-9.].*[0-9]")
    expectedTeamID="483DWKW443"
    ;;

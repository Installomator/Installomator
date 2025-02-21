jamfconnect)
    name="Jamf Connect"
    type="pkgInDmg"
    packageID="com.jamf.connect"
    downloadURL="https://files.jamfconnect.com/JamfConnect.dmg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep "x-amz-meta-version" | grep -o "[0-9.].*[0-9.].*[0-9]")
    expectedTeamID="483DWKW443"
    ;;

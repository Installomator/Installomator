jamfconnectlogin)
    name="Jamf Connect Login"
    type="pkgInDmg"
    pkgName="JamfConnectLogin.pkg"
    packageID="com.jamf.connect.login"
    downloadURL="https://files.jamfconnect.com/JamfConnect.dmg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep "x-amz-meta-version" | grep -o "[0-9.].*[0-9.].*[0-9]")
    expectedTeamID="483DWKW443"
    ;;

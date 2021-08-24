adobeconnect)
    # credit: Oh4sh0 https://github.com/Oh4sh0
    # Comment by Søren: I do not know this software.
    # Looks like it's an Adobe installer in an app, so it will probably not work
    name="AdobeConnectInstaller"
    type="dmg"
    downloadURL="http://www.adobe.com/go/ConnectSetupMac"
    appNewVersion=$(curl -fs https://helpx.adobe.com/adobe-connect/connect-downloads-updates.html | grep "Mac" | grep version | head -1 | sed -E 's/.*\(version ([0-9\.]*),.*/\1/g')
    expectedTeamID="JQ525L2MZD"
    ;;

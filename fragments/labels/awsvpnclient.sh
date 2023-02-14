awsvpnclient)
    name="AWS VPN Client"
    type="pkg"
    downloadURL="https://d20adtppz83p9s.cloudfront.net/OSX/latest/AWS_VPN_Client.pkg"
    expectedTeamID="94KV3E626L"
    appNewVersion=$(curl -is "https://beta2.communitypatch.com/jamf/v1/ba1efae22ae74a9eb4e915c31fef5dd2/patch/AWSVPNClient" | grep currentVersion | tr ',' '\n' | grep currentVersion | cut -d '"' -f 4)
    ;;

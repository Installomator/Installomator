awsvpnclient)
    name="AWS VPN Client"
    type="pkg"
    baseURL="https://d20adtppz83p9s.cloudfront.net/OSX"
    appNewVersion=$(curl -s "https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-user-guide.rss" | grep -o 'AWS provided client ([0-9]*\.[0-9]*\.[0-9]*) for macOS' | head -1 | grep -o '[0-9]*\.[0-9]*\.[0-9]*')
    downloadURL="${baseURL}/${appNewVersion}/AWS_VPN_Client.pkg"
    expectedTeamID="94KV3E626L"
    ;;

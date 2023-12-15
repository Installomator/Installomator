lcadvancedvpnclient)
    name="LANCOM Advanced VPN Client"
    type="pkgInDmg"
    appNewVersion=$(curl -fs https://www.ncp-e.com/de/service/download-vpn-client | grep -m 1 "NCP Secure Entry macOS Client" -A 6 | grep -i Version | sed  "s|.*Version \(.*\) Rev.*|\\1|")
    downloadURL=$(appShortVersion=`sed 's/[^0-9]//g' <<< $appNewVersion` && echo https://ftp.lancom.de/LANCOM-Releases/LC-VPN-Client/LC-Advanced-VPN-Client-macOS-"${appShortVersion}"-Rel-x86-64.dmg)
    expectedTeamID="LL3KBL2M3A"
    ;;

dymoconnectdesktop)
    name="DYMO Connect"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1 Safari/605.1.15" -s https://www.dymo.com/support\?cfid\=user-guide | grep -o "https://.*-Arm64.pkg" | head -1)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1 Safari/605.1.15" -s https://www.dymo.com/support\?cfid\=user-guide | grep -o "https://.*-X64.pkg" | head -1)
    fi
    archiveName="$(basename ${downloadURL})"
    appNewVersion="$(echo ${archiveName} | grep -o "[0-9].*\.[0-9]\+")"
    expectedTeamID="N3S6676K3E"
    ;;

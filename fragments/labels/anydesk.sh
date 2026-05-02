anydesk)
    name="AnyDesk"
    type="dmg"
    downloadURL="https://download.anydesk.com/anydesk.dmg"
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://download.anydesk.com/changelog.txt" | grep -m1 "(macOS)" | sed -E 's/.*- ([0-9.]+) \(macOS\).*/\1/')
    expectedTeamID="KHRWM533LU"
    ;;

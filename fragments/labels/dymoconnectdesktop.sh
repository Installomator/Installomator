dymoconnectdesktop)
    name="DYMO Connect"
    type="pkg"
    downloadURL=$(curl -fs -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" "https://www.dymo.com/compatibility-chart.html" | grep -oE 'https?://[^"]+\.pkg' | sort -rV | head -n 1| sort -rV | head -n 1)
    appNewVersion=$(curl -fs -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" "https://www.dymo.com/compatibility-chart.html" | grep -oE 'https?://[^"]+\.pkg' | awk -F/ '{print $NF}' | sed 's/DCDMac\([0-9\.]*\)\.pkg/\1.pkg/' | cut -d"." -f1-4 | sort -rV | head -n 1)
    expectedTeamID="N3S6676K3E"
    blockingProcesses="DYMO Connect"
    ;;

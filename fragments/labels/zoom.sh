zoom)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Zoom.us"
    type="pkg"
    downloadURL="https://zoom.us/client/latest/ZoomInstallerIT.pkg"
    appNewVersion=$(curl -fs -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15)" "https://zoom.us/download" | grep Version | head -n 1 | sed -E 's/.* ([0-9.]* \(.*\)).*/\1/') # credit: Søren Theilgaard (@theilgaard)
    expectedTeamID="BJ4HAAB9B3"
    blockingProcesses=( zoom.us )
    ;;

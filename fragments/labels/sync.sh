sync)
    name="Sync"
    type="dmg"
    downloadURL="https://www.sync.com/download/apple/Sync.dmg"
    appNewVersion="$(curl -fs "https://www.sync.com/blog/category/desktop/feed/" | xpath '(//channel/item/title)[1]' 2>/dev/null | sed -E 's/^.* ([0-9.]*) .*$/\1/g')"
    expectedTeamID="7QR39CMJ3W"
    blockingProcesses=( "Sync" "sync-worker.exe" )
    ;;

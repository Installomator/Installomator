reaper)
    name="REAPER"
    type="dmg"
    appNewVersion="$(curl "https://www.reaper.fm/download.php" | grep -a1 "DOWNLOAD REAPER" | sed -ne 's/[^0-9]*\(\([0-9]\.\)\{0,4\}[0-9][^.]\).*/\1/p')"
    downloadURL="https://www.reaper.fm/files/7.x/reaper$(echo $appNewVersion | tr -d '.')_universal.dmg"
    appCustomVersion(){ /usr/bin/defaults read "/Applications/REAPER.app/Contents/Info.plist" CFBundleShortVersionString | cut -d'.' -f1-2 }
    expectedTeamID="Y3T58622SG"
    ;;

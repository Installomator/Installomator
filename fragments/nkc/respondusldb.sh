respondusldb)
    # NKC Change
    name="Respondus Lockdown Browser"
    type="pkgInZip"
    appNewVersion=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" "https://download.respondus.com/lockdown/download7.php?id=971144602" | grep 'Version:' | awk '{print $2}' | cut -d '<' -f1)
    downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" "https://download.respondus.com/lockdown/download7.php?id=971144602" | grep -Eo "https?://\S+?\"" | grep downloads.respondus.com | head -1 | sed 's/.$//')
    expectedTeamID="8CA6NAN723"
    appName="LockDown Browser.app"
    appCustomVersion(){
        ldbmajor=$(defaults read "/Applications/LockDown Browser.app/Contents/Info.plist" CFBundleShortVersionString)
        ldbminor=$(defaults read "/Applications/LockDown Browser.app/Contents/Info.plist" LDBMinorBuild)
        echo "$ldbmajor.$ldbminor"
        }
    ;;

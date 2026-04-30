shotcut)
    name="shotcut"
    type="dmg"
    appNewVersion=$(curl -fsL https://www.shotcut.org/download/releasenotes | grep 'release-' | head -n 1 | cut -d '"' -f 2 | cut -d '-' -f 2)
    appCustomVersion() { echo "$(/usr/bin/defaults read "/Applications/shotcut.app/Contents/Info.plist" "CFBundleVersion" | sed -r 's/[.]//g')" }
    archiveName="shotcut-macos-${appNewVersion:0:2}.${appNewVersion:2:2}.${appNewVersion:4:2}.dmg"
    downloadURL=$(downloadURLFromGit mltframework shotcut)
    expectedTeamID="Y6RX44QG2G"
    ;;

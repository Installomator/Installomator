vlc)
    name="VLC"
    type="dmg"
    latestVersionURL="https://get.videolan.org/vlc/last/macosx/"
    archiveName=$(curl -sf "$latestVersionURL" | grep -ioE 'vlc-[0-9]+\.[0-9]+\.[0-9]+-universal\.dmg' | uniq)
    downloadURL="${latestVersionURL}${archiveName}"
    appNewVersion=$(awk -F'[-.]' '{print $2"."$3"."$4}' <<< "$archiveName")
    versionKey="CFBundleShortVersionString"
    expectedTeamID="75GAHG3SZQ"
    ;;


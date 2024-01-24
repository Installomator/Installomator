whatsapp)
    name="WhatsApp"
    appName="$name.app"
    type="dmg"
    downloadURL=$(curl -sfi "https://web.whatsapp.com/desktop/mac_native/release/" | awk 'BEGIN{IGNORECASE=1} /location:/ {gsub(/\r/,"",$2); print $2}')
    archiveName=$(grep -ioE "$name-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\.$type" <<< "$downloadURL")
    appNewVersion=$(awk -F'[-.]' '{print $3"."$4"."$5}' <<< "$archiveName")
    versionKey="CFBundleShortVersionString"
    blockingProcesses=( "$name" )
    expectedTeamID="57T9237FN3"
    ;;
skype)
    name="Skype"
    type="dmg"
    downloadURL=$(curl -sfi https://get.skype.com/go/getskype-skypeformac | awk 'BEGIN{IGNORECASE=1} /location:/ {gsub(/\r/,"",$2); print $2}')
    archiveName=$(basename "$downloadURL")
    appNewVersion=$(awk -F'[-.]' '{print $2"."$3"."$4"."$5}' <<< "$archiveName")
    versionKey="CFBundleVersion"
    blockingProcesses=( "Skype" , "Skype Helper" )
    expectedTeamID="AL798K98FX"
    ;;

axurerp10)
    name="Axure RP 10"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://d3uii9pxdigrx1.cloudfront.net/AxureRP-Setup-arm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://d3uii9pxdigrx1.cloudfront.net/AxureRP-Setup.dmg"
    fi
    appNewVersion=$( curl -sL https://www.axure.com/release-history | grep -Eo '[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}' -m 1 )
    expectedTeamID="HUMW6UU796"
    versionKey="CFBundleVersion"
    appName="Axure RP 10.app"
    blockingProcesses=( "Axure RP 10" )
    ;;

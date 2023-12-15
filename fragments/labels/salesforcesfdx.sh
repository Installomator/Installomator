salesforcecli)
    name="Salesforce CLI"
    type="pkg"
    packageID="com.salesforce.cli"
    if [[ $(arch) == "arm64" ]]; then
    downloadURL="https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-arm64.pkg"
    elif [[ $(arch) == "i386" ]]; then
    downloadURL="https://developer.salesforce.com/media/salesforce-cli/sf/channels/stable/sf-x64.pkg"
    fi
    appNewVersion=$( curl -fsL https://raw.githubusercontent.com/forcedotcom/cli/main/releasenotes/README.md | grep -iF  "[stable]"  | grep -i "[##]" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g'  )
    expectedTeamID="62J96EUJ9N"
    blockingProcesses=( NONE )
    ;;

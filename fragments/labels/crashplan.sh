crashplan)
    name="CrashPlan"
    type="pkgInDmg"
    pkgName="Install CrashPlan.pkg"
    downloadURL="https://download.crashplan.com/installs/agent/latest-mac.dmg"
    appNewVersion=$( curl https://download.crashplan.com/installs/agent/latest-mac.dmg  -s -L -I -o /dev/null -w '%{url_effective}' | cut -d "/" -f7 )
    expectedTeamID="UGHXR79U6M"
    blockingProcesses=( NONE )
    ;;

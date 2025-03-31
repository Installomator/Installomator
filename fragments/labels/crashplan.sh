crashplan)
    name="CrashPlan"
    type="pkgInDmg"
    downloadURL="https://download.crashplan.com/installs/agent/latest-mac.dmg"
    appNewVersion=$( curl -sfI https://download.crashplan.com/installs/agent/latest-mac.dmg | awk -F'/' '/Location: /{print $7}' )
    archiveName=$( curl -sfI https://download.crashplan.com/installs/agent/latest-mac.dmg | awk -F'/' '/Location: /{print $NF}' )
    expectedTeamID="UGHXR79U6M"
    pkgName="Install CrashPlan.pkg"
    packageID="com.crashplan.app.pkg"
    ;;

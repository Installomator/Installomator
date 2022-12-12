chronoagent)
    name="ChronoAgent"
    type="pkgInDmg"
    # packageID="com.econtechnologies.preference.chronoagent"
    # versionKey="CFBundleVersion"
    # None of the above can read out the installed version
    releaseURL="https://www.econtechnologies.com/UC/updatecheck.php?prod=ChronoAgent&lang=en&plat=mac&os=10.14.1&hw=i64&req=1&vers=#"
    appNewVersion=$(curl -sf $releaseURL | sed -r 's/.*VERSION=([^<]+).*/\1/')
    downloadURL="https://downloads.econtechnologies.com/CA_Mac_Download.dmg"
    expectedTeamID="9U697UM7YX"
    ;;

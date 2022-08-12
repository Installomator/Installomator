duodevicehealth)
    name="Duo Device Health"
    type="pkgInDmg"
    downloadURL="https://dl.duosecurity.com/DuoDeviceHealth-latest.dmg"
    appNewVersion=$(curl -fsLIXGET "https://dl.duosecurity.com/DuoDeviceHealth-latest.dmg" | grep -i "^content-disposition" | sed -e 's/.*filename\=\"DuoDeviceHealth\-\(.*\)\.dmg\".*/\1/')
    appName="Duo Device Health.app"
    expectedTeamID="FNN8Z5JMFP"
    ;;


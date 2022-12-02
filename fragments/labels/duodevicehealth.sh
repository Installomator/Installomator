duodevicehealth)
    name="Duo Device Health"
    type="pkg"
    downloadURL="https://dl.duosecurity.com/DuoDeviceHealth-latest.pkg"
    appNewVersion=$(curl -fsLIXGET "https://dl.duosecurity.com/DuoDeviceHealth-latest.pkg" | grep -i "^content-disposition" | sed -e 's/.*filename\=\"DuoDeviceHealth\-\(.*\)\.pkg\".*/\1/')
    appName="Duo Device Health.app"
    expectedTeamID="FNN8Z5JMFP"
    ;;

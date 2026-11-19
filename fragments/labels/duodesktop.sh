duodevicehealth|\
duodesktop)
    name="Duo Desktop"
    type="pkg"
    appNewVersion=$(curl -fsLIXGET "https://dl.duosecurity.com/DuoDesktop-latest.pkg" | grep -i "^content-disposition" | sed -e 's/.*filename\=\"DuoDesktop\-\(.*\)\.pkg\".*/\1/' | tr -d '\r')
    downloadURL="https://dl.duosecurity.com/DuoDesktop-${appNewVersion}.pkg"
    expectedTeamID="FNN8Z5JMFP"
    ;;

duodevicehealth|\
duodesktop)
    name="Duo Desktop"
    type="pkg"
    downloadURL="https://dl.duosecurity.com/DuoDesktop-latest.pkg"
    appNewVersion=$(curl -fsLIXGET "https://dl.duosecurity.com/DuoDesktop-latest.pkg" | grep -i "^content-disposition" | sed -e 's/.*filename\=\"DuoDesktop\-\(.*\)\.pkg\".*/\1/')
    expectedTeamID="FNN8Z5JMFP"
    ;;

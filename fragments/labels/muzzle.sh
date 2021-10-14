muzzle)
    name="Muzzle"
    type="zip"
    downloadURL="https://muzzleapp.com/binaries/muzzle.zip"
    appNewVersion=$(curl -fs https://muzzleapp.com/updates/  | grep -io 'h2.*Version.* [0-9.]*.*h2' | head -1 | sed -E 's/.*ersion *([0-9.]*).*/\1/g')
    expectedTeamID="49EYHPJ4Q3"
    ;;

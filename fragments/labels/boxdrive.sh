boxdrive)
    name="Box"
    type="pkg"
    packageID="com.box.desktop.installer.desktop"
    appNewVersion=$(curl -fsL "https://formulae.brew.sh/api/cask/box-drive.json" | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4 | cut -d',' -f1)
    downloadURL="https://e3.boxcdn.net/desktop/releases/mac/BoxDrive-${appNewVersion}.pkg"
    expectedTeamID="M683GB7CPW"
    ;;

virtualbox)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    virtualboxDetails=$(curl -fs 'https://update.virtualbox.org/query.php/?platform=DARWIN_64BITS_GENERIC&version=0.0.0&branch=stable')
    downloadURL=$(echo "${virtualboxDetails}" | cut -d" " -f2)
    appNewVersion=$(echo "${virtualboxDetails}" | cut -d" " -f1)
    expectedTeamID="VB5E2TV963"
    ;;

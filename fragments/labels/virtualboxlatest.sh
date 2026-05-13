virtualboxlatest)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    appNewVersion=$(curl -fs "https://download.virtualbox.org/virtualbox/LATEST.TXT")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.virtualbox.org/virtualbox/${appNewVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${appNewVersion}/" | grep "macOSArm64" | cut -d\" -f2)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.virtualbox.org/virtualbox/${appNewVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${appNewVersion}/" | grep "OSX.dmg" | cut -d\" -f2)"
    fi
    expectedTeamID="VB5E2TV963"
    ;;

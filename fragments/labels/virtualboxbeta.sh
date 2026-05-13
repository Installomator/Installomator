virtualboxbeta)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    betaVersion="$(curl -fs "https://download.virtualbox.org/virtualbox/LATEST-BETA.TXT")"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.virtualbox.org/virtualbox/${betaVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${betaVersion}/" | grep "macOSArm64" | cut -d\" -f2)"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.virtualbox.org/virtualbox/${betaVersion}/$(curl -fs "https://download.virtualbox.org/virtualbox/${betaVersion}/" | grep "OSX.dmg" | cut -d\" -f2)"
    fi
    appNewVersion="$(echo $betaVersion | cut -d_ -f1)"
    expectedTeamID="VB5E2TV963"
    ;;

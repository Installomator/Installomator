virtualbox)
    # credit: AP Orlebeke (@apizz)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    if [[ $(arch) == "arm64" ]]; then
        virtualBoxBuild="macOSArm64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        virtualBoxBuild="OSX.dmg"
    fi
    downloadURL="https:$(curl -fsL "https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html" | grep "${virtualBoxBuild}" | xmllint --html --xpath 'string(//a/@href)' -)"
    appNewVersion=$(echo "${downloadURL}" | awk -F '/' '{print $5}')
    expectedTeamID="VB5E2TV963"
    blockingProcesses=( VirtualBox VirtualBoxVM VBoxHeadless )
    ;;

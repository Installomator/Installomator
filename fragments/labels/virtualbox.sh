virtualbox)
    # credit: AP Orlebeke (@apizz)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    if [[ $(arch) == i386 ]]; then
        platform="OSX"
    elif [[ $(arch) == arm64 ]]; then
        platform="macOSArm64"
    fi
    downloadURL="https:$(curl -fsL "https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html" | grep "${platform}.dmg" | xmllint --html --xpath 'string(//a/@href)' -)"
    appNewVersion=$(echo "${downloadURL}" | awk -F '/' '{print $5}')
    expectedTeamID="VB5E2TV963"
    ;;

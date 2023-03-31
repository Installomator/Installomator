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
    downloadURL=$(curl -fs "https://www.virtualbox.org/wiki/Downloads" | awk -F '"' "/$platform.dmg/ { print \$4 }")
    appNewVersion=$(curl -fs "https://www.virtualbox.org/wiki/Downloads" | awk -F '"' "/$platform.dmg/ { print \$4 }" | sed -E 's/.*virtualbox\/([0-9.]*)\/.*/\1/')
    expectedTeamID="VB5E2TV963"
    ;;

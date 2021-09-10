virtualbox)
    # credit: AP Orlebeke (@apizz)
    name="VirtualBox"
    type="pkgInDmg"
    pkgName="VirtualBox.pkg"
    downloadURL=$(curl -fs "https://www.virtualbox.org/wiki/Downloads" \
        | awk -F '"' "/OSX.dmg/ { print \$4 }")
    appNewVersion=$(curl -fs "https://www.virtualbox.org/wiki/Downloads" | awk -F '"' "/OSX.dmg/ { print \$4 }" | sed -E 's/.*virtualbox\/([0-9.]*)\/.*/\1/')
    expectedTeamID="VB5E2TV963"
    ;;

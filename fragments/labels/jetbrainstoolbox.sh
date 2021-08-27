jetbrainstoolbox)
    name="JetBrains Toolbox"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        downloadURL="https://download.jetbrains.com/product?code=TB&latest&distribution=mac"
    elif [[ $(arch) == arm64 ]]; then
        downloadURL="https://download.jetbrains.com/product?code=TB&latest&distribution=macM1"
    fi
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*\/[a-zA-Z-]*-([0-9.]*).*[-.].*dmg/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
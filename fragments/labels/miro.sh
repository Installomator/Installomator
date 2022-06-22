miro)
    # credit: @matins
    name="Miro"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://desktop.miro.com/platforms/darwin-arm64/Miro.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://desktop.miro.com/platforms/darwin/Miro.dmg"
    fi
    expectedTeamID="M3GM7MFY7U"
    ;;

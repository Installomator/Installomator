korgsoftwarepass)
    name="Korg Software Pass"
    type="pkgInDmg"
    downloadURL="https://id.korg.com/redirect/korg-software-pass/mac"
    appNewVersion="$(curl -LIs -o /dev/null -w "%{url_effective}\n" "$downloadURL" | grep -oE '[0-9]+_[0-9]+_[0-9]+' | tr '_' '.')"
    expectedTeamID="9H3HFX7NG2"
    ;;

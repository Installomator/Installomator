keybase)
    name="Keybase"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL=$(curl -s https://keybase.io/docs/the_app/install_macos | grep data-target | cut -d '"' -f2 | grep arm64 )
    elif [[ $(arch) == i386 ]]; then
        downloadURL=$(curl -s https://keybase.io/docs/the_app/install_macos | grep data-target | cut -d '"' -f2 | grep -v arm64 )
    fi
    expectedTeamID="99229SGT5K"
    ;; 

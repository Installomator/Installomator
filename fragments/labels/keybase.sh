keybase)
    name="Keybase"
    type="dmg"
    downloadURL=$(curl -s https://keybase.io/docs/the_app/install_macos | grep data-target | cut -d '"' -f2)
    expectedTeamID="99229SGT5K"
    ;;

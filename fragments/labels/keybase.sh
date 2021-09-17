keybase)
    # credit: Todd Fleisher (@fleish)
    name="Keybase"
    type="dmg"
    downloadURL=$(curl -s https://keybase.io/docs/the_app/install_macos | grep data-target | awk -F\= '{print $2}' | tr -d \")
    expectedTeamID="99229SGT5K"
    ;;

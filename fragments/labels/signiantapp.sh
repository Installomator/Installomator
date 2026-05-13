signiantapp)
    name="Signiant App"
    type="dmg"
    downloadURL="https://updates.signiant.com/signiant_app/$(curl -fs "https://updates.signiant.com/signiant_app/signiant-app-info-mac.json" | grep -o '"file": *"[^"]*"' | awk -F '"' '{print $4}')"
    appNewVersion="$(echo $downloadURL | sed -E 's/.*Signiant_App_([0-9]+(\.[0-9]+)*)\.dmg/\1/')"
    expectedTeamID="U6ZZ4QLU4Q"
    ;;

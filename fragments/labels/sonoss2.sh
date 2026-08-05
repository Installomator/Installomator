sonoss2)
    name="Sonos"
    type="dmg"
    downloadURL="https://update-software.sonos.com/software/rT0797IawE/Sonos_90.0-77070.dmg"
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/Sonos_([0-9]+)\.([0-9]+)-([0-9]+)\.dmg|\1.\2.\3|')
    versionKey="CFBundleVersion"
    expectedTeamID="2G4LW83Q3E"
    ;;

godot)
    name="Godot"
    type="zip"
    appNewVersion=$(curl -fsSL https://godotengine.org/download/archive/ | tr '\302\240' ' ' | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?-stable' | head -n1 | sed 's/-stable$//')
    downloadURL="https://downloads.godotengine.org/?version=$appNewVersion&flavor=stable&slug=macos.universal.zip&platform=macos.universal"
    expectedTeamID="6K46PWY5DM"
    versionKey="CFBundleVersion"
    ;;


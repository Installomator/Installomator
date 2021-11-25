applesfsymbols|\
sfsymbols)
    name="SF Symbols"
    type="pkgInDmg"
    downloadURL=$( curl -fs "https://developer.apple.com/sf-symbols/" | grep -oe "https.*\.dmg" | head -1 )
    appNewVersion=$( echo "$downloadURL" | head -1 | sed -E 's/.*SF-Symbols-([0-9.]*)\..*/\1/g')
    expectedTeamID="Software Update"
    ;;

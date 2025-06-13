applesfsymbols|\
sfsymbols)
    name="SF Symbols"
    type="pkgInDmg"
    downloadURL=$( curl -fs "https://developer.apple.com/sf-symbols/" | grep -oe "https.*Symbols.*\.dmg" | head -1 )
    ver=${downloadURL##*SF-Symbols-}
    ver=${ver%.dmg}
    if [[ $ver != *.* ]]; then
        ver=$ver.0
    fi
    appNewVersion=$ver
    expectedTeamID="Software Update"
    ;;

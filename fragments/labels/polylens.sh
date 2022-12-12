polylens)
    name="Poly Lens"
    type="dmg"
    appNewVersion=$(curl -fs "https://info.lens.poly.com/lens-dt-rn/atom.xml" | grep "Version" | head -1 | cut -d "[" -f3 | sed 's/Version //g' | sed 's/]]\>\<\/title\>//g')
    downloadURL="https://swupdate.lens.poly.com/lens-desktop-mac/$appNewVersion/$appNewVersion/PolyLens-$appNewVersion.dmg"
    expectedTeamID="SKWK2Q7JJV"
    ;;

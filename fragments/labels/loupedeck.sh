loupedeck)
    name="Loupedeck"
    type="pkgInDmg"
    #downloadURL="https://5145542.fs1.hubspotusercontent-na1.net/hubfs/5145542/Knowledge%20Base/LD%20Software%20Downloads/5.8.1/LoupedeckInstaller_5.8.1.18057.dmg"
    downloadURL=$(curl -fs "https://loupedeck.com/downloads/" | xmllint --html --format - 2>/dev/null | grep -oE "https.*.dmg" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*_([0-9.]*).dmg/\1/')
    expectedTeamID="M24R8BN5BK"
    ;;

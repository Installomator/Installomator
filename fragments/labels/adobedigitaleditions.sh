adobedigitaleditions)
    name="Adobe Digital Editions"
    type="pkgInDmg"
    packageID="com.adobe.digitaleditions"
    downloadPage=$(curl -fsL "https://www.adobe.com/solutions/ebook/digital-editions/download.html")
    downloadURL=$(echo "$downloadPage" | grep -oE 'https://[^"'\''[:space:]]*\.dmg' | grep -v "\.exe" | head -1)
    appNewVersion=$(echo "$downloadPage" | grep -o 'Adobe Digital Editions.*Installers' | awk -F' ' '{ print $4 }')
    expectedTeamID="JQ525L2MZD"
    ;;

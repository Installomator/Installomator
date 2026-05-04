rodecentral)
    name="RODE Central"
    type="pkgInZip"
    #packageID="com.rodecentral.installer"
    downloadURL="https://update.rode.com/central/RODE_Central_MACOS.zip"
    appNewVersion=$(curl -fLs https://rode.com/en/release-notes/rode-central | xmllint --html --format - 2>/dev/null | grep -o "release-notes-data='.*'>" | sed -E 's/release-notes-data='\''|'\''>//g' | jq -r '.[].version' | sed 's/[V|v]ersion //g' | sort --version-sort | tail -1)
    expectedTeamID="Z9T72PWTJA"
    ;;

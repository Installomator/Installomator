rodecentral)
    name="RODE Central"
    type="pkgInZip"
    #packageID="com.rodecentral.installer"
    downloadURL="https://update.rode.com/central/RODE_Central_MACOS.zip"
    appNewVersion=$(curl -fs https://rode.com/en/release-notes/rode-central | xmllint --html --format - 2>/dev/null | tr '"' '\n' | sed 's/\&quot\;/\n/g' | grep -i -o "Version .*" | head -1 | cut -w -f2)
    expectedTeamID="Z9T72PWTJA"
    ;;

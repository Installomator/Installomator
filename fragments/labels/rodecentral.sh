rodecentral)
    name="RODE Central"
    type="pkgInZip"
    #packageID="com.rodecentral.installer"
    downloadURL="https://update.rode.com/central/RODE_Central_MACOS.zip"
    appNewVersion=$(curl -fLs https://rode.com/en/release-notes/rode-central | grep -oE "Version [0-9].[0-9].[0-9.]*" | awk '{print$2}' | sort --version-sort | tail -1)
    expectedTeamID="Z9T72PWTJA"
    ;;

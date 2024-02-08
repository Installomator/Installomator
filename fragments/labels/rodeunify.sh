rodecentral)
    name="RODE Central"
    type="pkgInZip"
    #packageID="com.rodecentral.installer"
    downloadURL="https://update.rode.com/unify_new/macos/RODE_UNIFY_MACOS.zip"
    #appNewVersion=$(curl -fs https://rode.com/en/release-notes/unify | xmllint --html --format - 2>/dev/null | tr '"' '\n' | grep -i -o "Version .*" | head -1 | cut -w -f2)
    expectedTeamID="Z9T72PWTJA"
    ;;

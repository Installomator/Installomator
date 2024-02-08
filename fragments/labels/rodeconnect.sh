rodeconnect)
    name="RODE Connect"
    type="pkgInZip"
    #packageID="com.rodeconnect.installer" #Versioned wrong as 0 in 1.1.0 pkg
    downloadURL="https://cdn1.rode.com/rodeconnect_installer_mac.zip"
    #appNewVersion=$(curl -fs https://rode.com/en/release-notes/rode-connect | xmllint --html --format - 2>/dev/null | tr '"' '\n' | grep -i -o "Version .*" | head -1 | cut -w -f2)
    expectedTeamID="Z9T72PWTJA"
    ;;

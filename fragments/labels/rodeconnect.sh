rodeconnect)
    name="RODE Connect"
    type="pkgInZip"
    #packageID="com.rodeconnect.installer" #Versioned wrong as 0 in 1.1.0 pkg
    downloadURL="https://update.rode.com/connect/RODE_Connect_MACOS.zip"
    appNewVersion=$(curl -fs https://rode.com/en/release-notes/rode-connect | xmllint --html --format - 2>/dev/null | tr '"' '\n' | sed 's/\&quot\;/\n/g' | grep -i -o "Version .*" | head -1 | cut -w -f2)
    expectedTeamID="Z9T72PWTJA"
    ;;

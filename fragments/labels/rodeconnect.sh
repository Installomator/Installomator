rodeconnect)
    name="RODE Connect"
    type="pkgInZip"
    #packageID="com.rodeconnect.installer" #Versioned wrong as 0 in 1.1.0 pkg
    downloadURL="https://cdn1.rode.com/rodeconnect_installer_mac.zip"
    appNewVersion="$(curl -fs https://rode.com/software/rode-connect | grep -i -o ">Current version .*<" | cut -d " " -f4)"
    expectedTeamID="Z9T72PWTJA"
    ;;

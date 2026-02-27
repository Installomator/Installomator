keyaccess)
    name="KeyAccess"
    type="pkg"
    keyaccessHost="INSERT_YOUR_SERVER_IP_HERE"
    downloadURL="https://download.sassafras.com/software/release/current/Installers/MacOS/Client/ksp-client.pkg"
    appNewVersion="$(curl -s "https://solutions.teamdynamix.com/TDClient/1965/Portal/KB/ArticleDet?ID=169236" | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)+' | sort -V | tail -1)"
    expectedTeamID="7Z2KSDFMVY"
    # Application is not installed in /Applications
    appName="Library/KeyAccess/KeyAccess.app"
    # Allowing for setting host as it is the only setting required for a fresh install.
    if [[ -n $keyaccessHost ]]; then
        defaults write /Library/Preferences/com.sassafras.KeyAccess host -string "${keyaccessHost}"
    fi
    ;;

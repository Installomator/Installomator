keyaccess)
    name="KeyAccess"
    type="pkg"
    downloadURL="https://download.sassafras.com/software/release/current/Installers/MacOS/Client/ksp-client.pkg"
    appNewVersion="$(curl -s "https://solutions.teamdynamix.com/TDClient/1965/Portal/KB/ArticleDet?ID=169236" | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)+' | sort -V | tail -1)"
    expectedTeamID="7Z2KSDFMVY"
    appName="Library/KeyAccess/KeyAccess.app"
    ;;

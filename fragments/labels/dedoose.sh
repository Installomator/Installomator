dedoose)
    name="Dedoose"
    type="dmg"
    appNewVersion=$(curl https://www.dedoose.com/download-the-app | grep -o "Dedoose [0-9.].*[0-9.].*[0-9.] (DMG)" | awk '{print $2}')
    downloadURL="https://downloads.ctfassets.net/hk7rjv5qs0cy/L9ciKTARWP9o6ZTKtDPl6/252c2aadce210fbc21cce40162053c1b/Dedoose-$appNewVersion.dmg"
    expectedTeamID="9U74Q6K62X"
    ;;

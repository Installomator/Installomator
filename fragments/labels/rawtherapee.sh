rawtherapee)
    name="RawTherapee"
    # Open Source RAW Converter from https://rawtherapee.com
    # Documentation: https://rawpedia.rawtherapee.com/
    type="appInDmgInZip"
    downloadURL=$(curl -fs "https://rawtherapee.com/downloads/" | grep -oE "https.*/builds/mac/.*\.zip")
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*mac.*Universal_([0-9.]*).zip/\1/')
    #appNewVersion=$(versionFromGit "Beep6581" "RawTherapee")
    expectedTeamID="5SJ86G6Q2R"
    ;;

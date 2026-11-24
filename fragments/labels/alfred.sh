alfred)
    # credit: AP Orlebeke (@apizz)
    name="Alfred"
    type="dmg"
    downloadURL=$(curl -fs https://www.alfredapp.com | awk -F '"' "/dmg/ {print \$2}" | head -1)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*Alfred_([0-9.]*)_.*/\1/')
    # the app bundle is named after the major version (Alfred 5.app, Alfred 6.app)
    appName="Alfred ${appNewVersion%%.*}.app"
    expectedTeamID="XZZXE9SED4"
    ;;

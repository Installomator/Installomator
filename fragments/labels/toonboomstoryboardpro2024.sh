toonboomstoryboardpro2024)
    name="Storyboard Pro 24"
    type="dmg"
    downloadURL=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=24.0.0&b=00000" | sed -n 's/.*<package platform="macos" open_in_browser="false">\([^<]*\).*/\1/p')
    folderName="Toon Boom Storyboard Pro 24"
    appName="${folderName}/Storyboard Pro 24.app"
    appNewVersion=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=24.0.0&b=00000" | xmllint --xpath 'string(//update/@version)' -)
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;
    

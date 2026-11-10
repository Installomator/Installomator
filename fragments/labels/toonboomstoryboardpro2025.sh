toonboomstoryboardpro2025)
    name="Storyboard Pro 25"
    type="dmg"
    downloadURL=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=25.0.0&b=00000" | sed -n 's/.*<package platform="macos" open_in_browser="false">\([^<]*\).*/\1/p')
    version=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=25.0.0&b=00000" | xmllint --xpath 'string(//update/@version)' -)
    major_minor=${version:0:4}
    folderName="Toon Boom Storyboard Pro ${major_minor}"
    appName="${folderName}/Storyboard Pro ${major_minor}.app"
    appNewVersion=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=25.0.0&b=00000" | xmllint --xpath 'string(//update/@version)' -)
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;
    

toonboomstoryboardpro2025)
    name="Storyboard Pro 25"
    type="dmg"
    update=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=25.0.0&b=00000")
    version=$(echo $update| xmllint --xpath 'string(//update/@version)' -)
    downloadURL=$(echo $update | sed -n 's/.*<package platform="macos" open_in_browser="false">\([^<]*\).*/\1/p')
    appNewVersion=$(echo $update | xmllist --xpath 'string(//update/@version)' -)
    major_minor=${appNewVersion:0:4}
    folderName="Toon Boom Storyboard Pro ${major_minor}"
    appName="${folderName}/Storyboard Pro ${major_minor}.app"
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;

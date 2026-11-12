toonboomstoryboardpro2027)
    name="Storyboard Pro 27"
    type="dmg"
    update=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=27.0.0&b=00000")
    tmp_version=$(echo $update| xmllint --xpath 'string(//update/@version)' -)
    appNewVersion="${${tmp_version/ \(/.}/\)}"
    downloadURL=$(echo $update | sed -n 's/.*<package platform="macos" open_in_browser="false">\([^<]*\).*/\1/p')
    major_minor=${appNewVersion:0:4}
    folderName="Toon Boom Storyboard Pro ${major_minor}"
    appName="${folderName}/Storyboard Pro ${major_minor}.app"
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;


toonboomstoryboardpro2027)
    name="Storyboard Pro 27"
    type="dmg"
    updateData=$(curl -s "https://updates.toonboom.com/updates.php?p=sboardPro&v=27.0.0&b=00000")
    appNewVersion=$(echo $updateData | xpath -e 'string(//update/@version)' 2>/dev/null | sed -E 's/ \(([0-9]+)\)$/.\1/')
    downloadURL="https://$(echo $updateData | xpath -e 'string(//package[@platform="macos"])' 2>/dev/null)"
    majorMinor=$(echo $appNewVersion | cut -d "." -f 1,2)
    folderName="Toon Boom Storyboard Pro ${majorMinor}"
    appName="${folderName}/Storyboard Pro ${majorMinor}.app"
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;


eshareosx)
    name="e-Share"
    type="pkg"
    #packageID="com.ncryptedcloud.e-Share.pkg"
    downloadURL=https://www.ncryptedcloud.com/static/downloads/osx/$(curl -fs https://www.ncryptedcloud.com/static/downloads/osx/ | grep -o -i "href.*\".*\"" | cut -d '"' -f2)
    versionKey="CFBundleVersion"
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z\-]*_([0-9.]*)\.pkg/\1/g' )
    expectedTeamID="X9MBQS7DDC"
    ;;

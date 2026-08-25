jre8)
    name="Java Runtime Environment 8"
    type="pkgInDmg"
    versionKey="CFBundleVersion"
    sparkleData=$(curl -fs "$(curl -fs "https://javadl-esd-secure.oracle.com/update/mac/map-mac-1.8.0.xml" | xmllint --xpath 'string((//java-update-map/mapping/url[not(contains(., "-cb.xml"))])[last()])' -)")
    appNewVersion=$(echo "$sparkleData" | xmllint --xpath 'string((//*[local-name()="enclosure"]/@*[local-name()="version"])[last()])' -)
    appBuildVersion=$(echo "$appNewVersion" | cut -d. -f3)
    downloadURL=$(echo "$sparkleData" | xmllint --xpath 'string((//*[local-name()="enclosure"]/@url)[last()])' -)
    pkgName="Java 8 Update ${appBuildVersion}.app/Contents/Resources/JavaAppletPlugin.pkg"
    appCustomVersion(){ defaults read "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Info.plist" "${versionKey}" 2>/dev/null }
    expectedTeamID="VB5E2TV963"
    blockingProcesses=( NONE )
    ;;

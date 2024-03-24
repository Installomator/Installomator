jre8)
    name="Java Runtime Environment 8"
    type="pkgInDmg"
    versionKey="CFBundleVersion"
    versionURL=$(curl -fs "https://javadl-esd-secure.oracle.com/update/mac/map-mac-1.8.0.xml" | xpath '( //java-update-map/mapping/url)[last()]' 2>/dev/null | cut -d\> -f2 | cut -d\< -f1)
    appNewVersion=$(curl -fs "${versionURL}" | xpath '(//rss/channel/item/enclosure/@sparkle:version)' 2>/dev/null | cut -d '"' -f 2)
    appBuildVersion=$(echo $appNewVersion | cut -d. -f3)
    downloadURL="$(curl -fs "${versionURL}" | xpath '(//rss/channel/item/enclosure/@url)[last()]' 2>/dev/null | cut -d '"' -f 2)"
    pkgName="Java 8 Update ${appBuildVersion}.app/Contents/Resources/JavaAppletPlugin.pkg"
    appCustomVersion(){ defaults read "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Info.plist" "${versionKey}" 2>/dev/null }
    expectedTeamID="VB5E2TV963"
    ;;

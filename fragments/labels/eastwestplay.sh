eastwestplay)
    name="Play"
    type="pkgInZip"
    downloadXML="$(curl -fs 'http://s3.amazonaws.com/ic-resources/products/PLAY.xml')"
    downloadURL="$(echo "${downloadXML}" | xpath '(//product/files/file[@platform="mac"]/url/text())' 2>/dev/null)"
    appNewVersion="$(echo "${downloadXML}" | xpath '(//product/version/text())' 2>/dev/null)"
    appCustomVersion(){ /usr/bin/defaults read "/Library/Application Support/East West/Play.app/Contents/Info.plist" CFBundleShortVersionString }
    pkgName="Play Installer ${appNewVersion}.pkg"
    expectedTeamID="TWK4WE76V9"
    ;;

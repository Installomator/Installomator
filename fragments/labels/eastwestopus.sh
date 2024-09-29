eastwestopus)
    name="Opus"
    type="pkgInZip"
    packageID="com.eastwest.pkg.OpusInstaller"
    downloadXML="$(curl -fs 'http://s3.amazonaws.com/ic-resources/products/OPUS.xml')"
    downloadURL="$(echo "${downloadXML}" | xpath '(//product/files/file[@platform="mac"]/url/text())' 2>/dev/null)"
    appNewVersion="$(echo "${downloadXML}" | xpath '(//product/version/text())' 2>/dev/null)"
    expectedTeamID="TWK4WE76V9"
    ;;

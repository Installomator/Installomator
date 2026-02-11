viennaassistant)
    name="Vienna Assistant"
    type="pkgInZip"
    downloadURL="https://api.vsl.co.at/data/download/va?os=mac"
    appNewVersion="$(getJSONValue $(curl -fs 'https://api.vsl.co.at/data/.well-known/dataservice-configuration') vaLatestVersionReadable)"
    appCustomVersion(){/usr/bin/defaults read "/Applications/Vienna Assistant/Vienna Assistant.app/Contents/Info.plist" CFBundleVersion}
    expectedTeamID="XR8G94NNCL"
    ;;
